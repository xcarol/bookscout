import 'package:flutter/material.dart';

import 'package:bookscout/services/books/book_list_service.dart';
import 'package:bookscout/widgets/chips/book_chip.dart';
import 'package:bookscout/l10n/app_localizations.dart';

class BookList extends StatefulWidget {
  final BookListService listService;

  const BookList({super.key, required this.listService});

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.listService.hasMore && !widget.listService.isLoadingMore) {
        widget.listService.loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.listService,
      builder: (context, _) {
        if (widget.listService.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final books = widget.listService.books;

        if (books.isEmpty) {
          final l10n = AppLocalizations.of(context)!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.menu_book_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.welcomeMessage,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.emptyBooksMessage,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          );
        }

        return Scrollbar(
          controller: _scrollController,
          child: GridView.builder(
            controller: _scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: books.length + (widget.listService.hasMore ? 1 : 0),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 140.0,
              childAspectRatio: cardWidth / cardHeight,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              if (index == books.length) {
                return const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                );
              }

              final book = books[index];
              return BookChip(book: book);
            },
          ),
        );
      },
    );
  }
}
