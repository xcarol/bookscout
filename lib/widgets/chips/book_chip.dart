import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookscout/models/book.dart';
import 'package:bookscout/models/custom_colors.dart';
import 'package:bookscout/services/books/reading_session_service.dart';
import 'package:bookscout/widgets/cards/book_card.dart';
import 'package:provider/provider.dart';

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
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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
                _bookCover(context, book.coverUrl),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Consumer<ReadingSessionService>(
                          builder: (context, readingSessionService, child) {
                            final isSessionActive =
                                readingSessionService.isSessionActive;

                            return Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isSessionActive
                                    ? Colors.grey.withValues(alpha: 0.5)
                                    : Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                          .withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                iconSize: 20,
                                icon: const Icon(Icons.play_arrow_rounded),
                                color: isSessionActive
                                    ? Colors.white.withValues(alpha: 0.38)
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                onPressed: isSessionActive
                                    ? null
                                    : () async {
                                        await readingSessionService
                                            .startSession(book.id);
                                      },
                              ),
                            );
                          },
                        ),
                        if (book.currentPage != null && book.currentPage! > 0)
                          Text(
                            '${book.currentPage} • ${book.pageCount != null && book.pageCount! > 0 ? ((book.currentPage!) / book.pageCount! * 100).toStringAsFixed(0) : '  '}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
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
}
