import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:bookscout/l10n/app_localizations.dart';
import 'package:bookscout/models/book.dart';
import 'package:bookscout/models/custom_colors.dart';
import 'package:bookscout/utils/app_constants.dart';

class BookCustomCacheManager {
  static const key = AppConstants.bookCoverCacheKey;
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: AppConstants.cacheMaxAgeDays),
      maxNrOfCacheObjects: AppConstants.cacheMaxObjects,
      fileService: HttpFileService(),
    ),
  );
}

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  static const double cardHeight = 150.0;

  const BookCard({super.key, required this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: cardHeight,
            child: Card(
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              child: InkWell(
                onTap: onTap,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _bookCover(context, book.coverUrl),
                    const SizedBox(width: 12),
                    _bookDetails(context),
                  ],
                ),
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: customColors.dividerColor),
        ],
      ),
    );
  }

  Widget _bookCover(BuildContext context, String? coverUrl) {
    final theme = Theme.of(context);
    final placeholder = Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: 36,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );

    if (coverUrl == null || coverUrl.isEmpty) {
      return AspectRatio(aspectRatio: 2 / 3, child: placeholder);
    }

    return AspectRatio(
      aspectRatio: 2 / 3,
      child: CachedNetworkImage(
        imageUrl: coverUrl,
        cacheManager: BookCustomCacheManager.instance,
        fit: BoxFit.cover,
        memCacheHeight: 300,
        memCacheWidth: 200,
        fadeInDuration: const Duration(milliseconds: 150),
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => placeholder,
      ),
    );
  }

  Widget _bookDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;

    final authorText = book.authorsFormatted.isNotEmpty
        ? book.authorsFormatted
        : l10n.unknownAuthor;

    final List<String> metaParts = [];
    if (book.publishedYear != null) {
      metaParts.add(book.publishedYear!);
    }
    if (book.pageCount != null && book.pageCount! > 0) {
      metaParts.add(l10n.pagesCount(book.pageCount!));
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  authorText,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (metaParts.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    metaParts.join(' • '),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.8,
                      ),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (book.hasRating)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 18,
                        color: customColors.ratedBook,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        book.averageRating!.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      if (book.ratingsCount != null && book.ratingsCount! > 0)
                        Text(
                          ' (${book.ratingsCount})',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  )
                else if (book.categories.isNotEmpty)
                  Flexible(
                    child: Text(
                      book.categories.first,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.primary,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
