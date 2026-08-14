import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:bookscout/models/book.dart';
import 'package:bookscout/models/reading_location.dart';
import 'package:bookscout/database/app_database.dart' hide Book;
import 'package:bookscout/l10n/app_localizations.dart';
import 'package:bookscout/services/books/library_repository.dart';
import 'package:bookscout/widgets/modals/finish_reading_dialog.dart';

class ReadingSessionsScreen extends StatelessWidget {
  final Book book;

  const ReadingSessionsScreen({super.key, required this.book});

  void _showAddSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => FinishReadingDialog(
        bookId: book.id,
        initialStartTime: DateTime.now(),
        isManualAdd: true,
      ),
    );
  }

  void _showEditSessionDialog(BuildContext context, ReadingSession session) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => FinishReadingDialog(
        bookId: book.id,
        initialStartTime: DateTime.now(),
        isManualAdd: true,
        existingSession: session,
      ),
    );
  }

  IconData _getLocationIcon(String? location) {
    if (location == null || location.isEmpty) return Icons.location_on_outlined;
    final loc = ReadingLocation.fromString(location);
    return loc.icon;
  }

  Future<bool> _confirmDelete(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(l10n.confirmDeleteSession),
          content: Text(l10n.confirmDeleteSessionMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: Text(l10n.actionDelete),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final df = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSessionDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer<LibraryRepository>(
        builder: (context, repo, child) {
          return FutureBuilder<List<ReadingSession>>(
            future: repo.getReadingSessions(book.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final sessions = snapshot.data ?? [];
              if (sessions.isEmpty) {
                return Center(
                  child: Text(
                    l10n.noReadingSessions,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  final int startPage = (index + 1 < sessions.length)
                      ? sessions[index + 1].endPage
                      : 0;
                  final int pagesRead = session.endPage - startPage;

                  return Dismissible(
                    key: Key(session.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      color: Theme.of(context).colorScheme.error,
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                    confirmDismiss: (direction) =>
                        _confirmDelete(context, l10n),
                    onDismissed: (direction) {
                      repo.deleteReadingSession(session.id);
                    },
                    child: Card(
                      child: ListTile(
                        onTap: () => _showEditSessionDialog(context, session),
                        leading: const Icon(Icons.auto_stories),
                        title: Text(df.format(session.date)),
                        subtitle: Text(
                          '${l10n.labelPages}: $pagesRead ($startPage - ${session.endPage})\n'
                          '${session.durationMinutes} min',
                        ),
                        isThreeLine: true,
                        trailing: session.location != null
                            ? Icon(_getLocationIcon(session.location))
                            : null,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
