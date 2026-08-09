import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookscout/models/book.dart';
import 'package:bookscout/models/custom_colors.dart';
import 'package:bookscout/widgets/cards/book_card.dart';

const double cardHeight = 280.0;
const double cardWidth = 140.0;

class BookChip extends StatelessWidget {
  final Book book;

  const BookChip({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: cardHeight,
        width: cardWidth,
        child: Card(
          color: Theme.of(
            context,
          ).extension<CustomColors>()!.chipCardBackground,
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: () {
              // TODO: Navigate to book details
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _bookCover(context, book.coverUrl),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    child: Container(
                      color: Theme.of(context)
                          .extension<CustomColors>()!
                          .chipCardBackground
                          .withValues(alpha: 0.95),
                      padding: const EdgeInsets.all(8.0),
                      child: _details(context, book),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
          size: 48,
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
        memCacheHeight: 400,
        memCacheWidth: 300,
        fadeInDuration: const Duration(milliseconds: 150),
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => placeholder,
      ),
    );
  }

  Widget _details(BuildContext context, Book book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          book.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        if (book.authorsFormatted.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            book.authorsFormatted,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
