import 'package:flutter/material.dart';
import 'package:bookscout/models/book.dart';
import 'package:bookscout/widgets/buttons/library_button.dart';
import 'package:bookscout/widgets/text_and_info/expandable_description.dart';
import 'package:bookscout/l10n/app_localizations.dart';
import 'package:bookscout/models/custom_colors.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

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
                          tag: 'book_cover_${book.id}',
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
                                    book.coverUrl != null &&
                                        book.coverUrl!.isNotEmpty
                                    ? Image.network(
                                        book.coverUrl!,
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
              text: book.description ?? '',
              initialMaxLines: 20,
            ),
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
              Text(
                book.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        LibraryButton(book: book),
      ],
    );
  }

  Widget _buildAuthorsAndSubtitle(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (book.authorsFormatted.isNotEmpty)
          Text(
            book.authorsFormatted,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (book.authorsFormatted.isEmpty)
          Text(
            l10n.unknownAuthor,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontStyle: FontStyle.italic,
            ),
          ),
        if (book.subtitle != null && book.subtitle!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            book.subtitle!,
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
        if (book.pageCount != null)
          _buildMetaRow(l10n.labelPages, book.pageCount.toString(), context),
        if (book.publishedYear != null)
          _buildMetaRow(l10n.labelPublished, book.publishedYear!, context),
        if (book.publisher != null && book.publisher!.isNotEmpty)
          _buildMetaRow(l10n.labelPublisher, book.publisher!, context),
        if (book.language != null && book.language!.isNotEmpty)
          _buildMetaRow(l10n.language, book.language!.toUpperCase(), context),
        if (book.categories.isNotEmpty)
          _buildMetaRow(l10n.labelGenres, book.categories.join(', '), context),
        if (book.hasRating)
          _buildMetaRow(
            l10n.labelRating,
            '${book.averageRating!.toStringAsFixed(1)} (${book.ratingsCount ?? 0})',
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
}
