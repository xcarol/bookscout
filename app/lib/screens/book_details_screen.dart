import 'package:flutter/material.dart';
import 'package:bookscout/models/book.dart';
import 'package:bookscout/models/availability_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bookscout/utils/app_constants.dart';
import 'package:bookscout/widgets/buttons/library_button.dart';
import 'package:bookscout/widgets/text_and_info/expandable_description.dart';
import 'package:bookscout/l10n/app_localizations.dart';
import 'package:bookscout/models/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:bookscout/services/books/library_repository.dart';
import 'package:bookscout/services/api/bookscout_api_service.dart';
import 'package:bookscout/services/settings/location_service.dart';
import 'package:bookscout/screens/reading_sessions_screen.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  late Book _book;
  bool _isLoadingFull = false;
  List<AvailabilityProvider>? _providers;
  bool _isLoadingAvailability = true;

  @override
  void initState() {
    super.initState();
    _book = widget.book;
    _loadFullDetailsIfNeeded();
    _loadAvailability();
  }

  Future<void> _loadAvailability() async {
    if (_book.isbn == null) {
      if (mounted) setState(() => _isLoadingAvailability = false);
      return;
    }

    final locationService = context.read<LocationService>();
    final country = locationService.currentCountry;
    final region = locationService.currentRegion;

    final providers = await BookScoutApiService().getAvailability(
      _book.isbn!,
      country: country,
      region: region,
    );
    if (mounted) {
      setState(() {
        _providers = providers;
        _isLoadingAvailability = false;
      });
    }
  }

  Future<void> _loadFullDetailsIfNeeded() async {
    if (!_book.isLite) return;

    setState(() => _isLoadingFull = true);
    final repo = context.read<LibraryRepository>();

    if (repo.isInLibrary(_book.id)) {
      final fullBook = await repo.getBook(_book.id);
      if (fullBook != null && mounted) {
        setState(() => _book = fullBook);
      }
    } else {
      if (_book.isbn != null) {
        final fullBook = await BookScoutApiService().getBookDetails(
          _book.isbn!,
        );
        if (fullBook != null && mounted) {
          setState(() => _book = fullBook);
        }
      }
    }

    if (mounted) {
      setState(() => _isLoadingFull = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [_buildSliverAppBar(context), _buildBookInfo(context)],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double topPadding = MediaQuery.paddingOf(context).top;
          final double minHeight = kToolbarHeight + topPadding;
          const double expandedHeight = 300.0;
          final double t =
              ((constraints.maxHeight - minHeight) /
                      (expandedHeight - minHeight))
                  .clamp(0.0, 1.0);

          final double opacity = (t * 2).clamp(0.0, 1.0);
          final double yOffset = (1.0 - t) * -150.0;

          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                      theme.colorScheme.surface,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(0, yOffset),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                      child: Center(
                        child: Hero(
                          tag: 'book_cover_${_book.id}',
                          child: AspectRatio(
                            aspectRatio: 0.65,
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: customColors.bookCoverShadow,
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child:
                                    _book.coverUrl != null &&
                                        _book.coverUrl!.isNotEmpty
                                    ? Image.network(
                                        _book.coverUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  color: theme
                                                      .colorScheme
                                                      .surfaceContainerHighest,
                                                ),
                                      )
                                    : Container(
                                        color: theme
                                            .colorScheme
                                            .surfaceContainerHighest,
                                        child: Icon(
                                          Icons.book,
                                          size: 60,
                                          color: theme
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ), // Hero
                      ), // Center
                    ), // Padding
                  ), // SafeArea
                ), // Transform.translate
              ), // Opacity
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(theme),
            const SizedBox(height: 8),
            _buildAuthorsAndSubtitle(theme, l10n),
            const SizedBox(height: 24),
            _buildMetadata(context),
            const SizedBox(height: 24),
            ExpandableDescription(
              text: _book.description ?? '',
              initialMaxLines: 20,
            ),
            const SizedBox(height: 40),
            _buildAvailabilitySection(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoadingFull) ...[
                const Center(child: LinearProgressIndicator()),
                const SizedBox(height: 16),
              ],
              Text(
                _book.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit_note),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReadingSessionsScreen(book: _book),
              ),
            );
          },
        ),
        LibraryButton(book: _book),
      ],
    );
  }

  Widget _buildAuthorsAndSubtitle(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_book.authorsFormatted.isNotEmpty)
          Text(
            _book.authorsFormatted,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (_book.authorsFormatted.isEmpty)
          Text(
            l10n.unknownAuthor,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontStyle: FontStyle.italic,
            ),
          ),
        if (_book.subtitle != null && _book.subtitle!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            _book.subtitle!,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMetadata(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_book.pageCount != null)
          _buildMetaRow(l10n.labelPages, _book.pageCount.toString(), context),
        if (_book.publishedYear != null)
          _buildMetaRow(l10n.labelPublished, _book.publishedYear!, context),
        if (_book.publisher != null && _book.publisher!.isNotEmpty)
          _buildMetaRow(l10n.labelPublisher, _book.publisher!, context),
        if (_book.language != null && _book.language!.isNotEmpty)
          _buildMetaRow(l10n.language, _book.language!.toUpperCase(), context),
        if (_book.categories.isNotEmpty)
          _buildMetaRow(l10n.labelGenres, _book.categories.join(', '), context),
        if (_book.hasRating)
          _buildMetaRow(
            l10n.labelRating,
            '${_book.averageRating!.toStringAsFixed(1)} (${_book.ratingsCount ?? 0})',
            context,
          ),
      ],
    );
  }

  Widget _buildMetaRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        '$label: $value',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }

  Widget _buildAvailabilitySection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;

    if (_isLoadingAvailability) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_providers == null || _providers!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.availability,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._providers!.map(
          (provider) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(
                provider.format.toUpperCase() == ProviderFormat.digital ||
                        provider.format.toUpperCase() ==
                            ProviderFormat.audiobook
                    ? Icons.devices
                    : Icons.menu_book,
                color: provider.isAvailable
                    ? customColors.availabilityAvailable
                    : customColors.availabilityUnavailable,
              ),
              title: Text(
                provider.providerName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                provider.status.replaceAll('_', ' '),
                style: TextStyle(
                  color: provider.isAvailable
                      ? customColors.availabilityAvailable
                      : customColors.availabilityUnavailable,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.open_in_new),
                onPressed: () async {
                  final url = Uri.parse(provider.url);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
