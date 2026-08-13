import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bookscout/l10n/app_localizations.dart';
import 'package:bookscout/database/app_database.dart';

class ReadingSessionValidator {
  static String? validate({
    required BuildContext context,
    required DateTime start,
    required DateTime end,
    required int? endPage,
    required List<ReadingSession> previousSessions,
  }) {
    final l10n = AppLocalizations.of(context)!;

    if (end.isBefore(start)) {
      return l10n.errorEndTimeBeforeStart;
    }

    if (endPage == null || endPage < 0) {
      return l10n.errorInvalidPage;
    }

    for (final s in previousSessions) {
      if (end.isAfter(s.date) && endPage < s.endPage) {
        return l10n.errorConflictReachedPage(
          DateFormat('dd/MM/yy HH:mm').format(s.date),
          s.endPage,
        );
      }
      if (start.isBefore(s.date) && endPage > s.startPage) {
        return l10n.errorConflictStartedPage(
          DateFormat('dd/MM/yy HH:mm').format(s.date),
          s.startPage,
        );
      }
    }

    int startPage = 0;
    for (final s in previousSessions) {
      if (s.date.isBefore(start) && s.endPage > startPage) {
        startPage = s.endPage;
      }
    }
    if (endPage <= startPage) {
      return l10n.errorEndPageLessThanStart(endPage, startPage);
    }

    return null;
  }

  static int calculateStartPage(
    DateTime start,
    List<ReadingSession> previousSessions,
  ) {
    int startPage = 0;
    for (final s in previousSessions) {
      if (s.date.isBefore(start) && s.endPage > startPage) {
        startPage = s.endPage;
      }
    }
    return startPage;
  }
}
