import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookscout/models/book.dart';
import 'package:bookscout/services/books/library_repository.dart';

class LibraryButton extends StatelessWidget {
  final Book book;

  const LibraryButton({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryRepository>(
      builder: (context, libraryRepository, child) {
        final isInLibrary = libraryRepository.isInLibrary(book.id);

        return IconButton(
          icon: Icon(
            isInLibrary ? Icons.check : Icons.add_circle_outline,
            color: isInLibrary
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onPressed: () async {
            libraryRepository.toggleLibrary(book);
          },
        );
      },
    );
  }
}
