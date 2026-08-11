import 'package:flutter/material.dart';
import 'package:bookscout/models/book.dart';
import 'package:bookscout/widgets/buttons/library_button.dart';
import 'package:bookscout/widgets/text_and_info/expandable_description.dart';
import 'package:bookscout/l10n/app_localizations.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double topPadding = MediaQuery.paddingOf(context).top;
                final double minHeight = kToolbarHeight + topPadding;
                const double expandedHeight = 300.0;
                final double t = ((constraints.maxHeight - minHeight) / (expandedHeight - minHeight)).clamp(0.0, 1.0);
                
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
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: book.coverUrl != null && book.coverUrl!.isNotEmpty
                                    ? Image.network(
                                        book.coverUrl!,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) =>
                                            Container(color: theme.colorScheme.surfaceContainerHighest),
                                      )
                                    : AspectRatio(
                                        aspectRatio: 0.65,
                                        child: Container(
                                          color: theme.colorScheme.surfaceContainerHighest,
                                          child: Icon(
                                            Icons.book,
                                            size: 60,
                                            color: theme.colorScheme.onSurfaceVariant,
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          book.title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      LibraryButton(book: book),
                    ],
                  ),
                  if (book.subtitle != null && book.subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      book.subtitle!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    book.authorsFormatted,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (book.pageCount != null)
                        _buildStat(
                          context,
                          Icons.pages,
                          l10n.pagesCount(book.pageCount!),
                        ),
                      if (book.publishedYear != null)
                        _buildStat(
                          context,
                          Icons.calendar_today,
                          book.publishedYear!,
                        ),
                      if (book.averageRating != null)
                        _buildStat(
                          context,
                          Icons.star,
                          book.averageRating!.toStringAsFixed(1),
                        ),
                      if (book.language != null)
                        _buildStat(
                          context,
                          Icons.language,
                          book.language!.toUpperCase(),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ExpandableDescription(
                    text: book.description ?? '',
                    initialMaxLines: 20,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
