import 'package:flutter/material.dart';
import 'package:bookscout/database/app_database.dart';
import 'package:bookscout/services/books/library_repository.dart';
import 'package:bookscout/services/books/reading_session_service.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:bookscout/l10n/app_localizations.dart';

class FinishReadingDialog extends StatefulWidget {
  final String bookId;
  final DateTime initialStartTime;
  final String? initialLocation;

  const FinishReadingDialog({
    super.key,
    required this.bookId,
    required this.initialStartTime,
    this.initialLocation,
  });

  @override
  State<FinishReadingDialog> createState() => _FinishReadingDialogState();
}

class _FinishReadingDialogState extends State<FinishReadingDialog> {
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;

  final _locationController = TextEditingController();
  final _pageController = TextEditingController();

  List<ReadingSession> _previousSessions = [];
  bool _isLoading = true;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartTime;
    _startTime = TimeOfDay.fromDateTime(widget.initialStartTime);

    final now = DateTime.now();
    _endDate = now;
    _endTime = TimeOfDay.fromDateTime(now);

    _locationController.text = widget.initialLocation ?? '';

    _loadPreviousSessions();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadPreviousSessions() async {
    final repo = context.read<LibraryRepository>();
    final sessions = await repo.getReadingSessions(widget.bookId);
    if (mounted) {
      setState(() {
        _previousSessions = sessions;
        _isLoading = false;

        if (sessions.isNotEmpty) {
          _pageController.text = sessions.first.endPage.toString();
        } else {
          _pageController.text = '0';
        }
      });
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _errorMsg = null;
    });

    final start = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _startTime.hour,
      _startTime.minute,
    );
    final end = DateTime(
      _endDate.year,
      _endDate.month,
      _endDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    if (end.isBefore(start)) {
      setState(() => _errorMsg = l10n.errorEndTimeBeforeStart);
      return;
    }

    final int? endPage = int.tryParse(_pageController.text);
    if (endPage == null || endPage < 0) {
      setState(() => _errorMsg = l10n.errorInvalidPage);
      return;
    }

    for (final s in _previousSessions) {
      if (end.isAfter(s.date) && endPage < s.endPage) {
        setState(
          () => _errorMsg = l10n.errorConflictReachedPage(
            DateFormat('dd/MM/yy HH:mm').format(s.date),
            s.endPage,
          ),
        );
        return;
      }
      if (start.isBefore(s.date) && endPage > s.startPage) {
        setState(
          () => _errorMsg = l10n.errorConflictStartedPage(
            DateFormat('dd/MM/yy HH:mm').format(s.date),
            s.startPage,
          ),
        );
        return;
      }
    }

    int startPage = 0;
    for (final s in _previousSessions) {
      if (s.date.isBefore(start) && s.endPage > startPage) {
        startPage = s.endPage;
      }
    }
    if (endPage <= startPage) {
      setState(
        () => _errorMsg = l10n.errorEndPageLessThanStart(endPage, startPage),
      );
      return;
    }

    final duration = end.difference(start).inMinutes;
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final companion = ReadingSessionsCompanion.insert(
      id: id,
      bookId: widget.bookId,
      date: drift.Value(end),
      startPage: startPage,
      endPage: endPage,
      pagesRead: endPage - startPage,
      durationMinutes: drift.Value(duration),
      location: drift.Value(_locationController.text),
    );

    final libraryRepo = context.read<LibraryRepository>();
    final sessionService = context.read<ReadingSessionService>();

    await libraryRepo.insertReadingSession(companion);
    await sessionService.endSession();

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _ensureChronologicalOrder() {
    final start = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _startTime.hour,
      _startTime.minute,
    );
    final end = DateTime(
      _endDate.year,
      _endDate.month,
      _endDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    if (start.isAfter(end)) {
      _endDate = start;
      _endTime = TimeOfDay.fromDateTime(start);
    }
  }

  Future<void> _pickStartDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      setState(() {
        _startDate = d;
        _ensureChronologicalOrder();
      });
    }
  }

  Future<void> _pickStartTime() async {
    final t = await showTimePicker(context: context, initialTime: _startTime);
    if (t != null) {
      setState(() {
        _startTime = t;
        _ensureChronologicalOrder();
      });
    }
  }

  Future<void> _pickEndDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => _endDate = d);
  }

  Future<void> _pickEndTime() async {
    final t = await showTimePicker(context: context, initialTime: _endTime);
    if (t != null) setState(() => _endTime = t);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const AlertDialog(
        content: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final l10n = AppLocalizations.of(context)!;
    final df = DateFormat('dd/MM/yyyy');

    return AlertDialog(
      title: Text(l10n.endReadingSessionTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_errorMsg != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 16),
                color: Theme.of(context).colorScheme.errorContainer,
                child: Text(
                  _errorMsg!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),

            Text(
              l10n.startLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickStartDate,
                    child: Text(df.format(_startDate)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickStartTime,
                    child: Text(_startTime.format(context)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Text(
              l10n.endLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickEndDate,
                    child: Text(df.format(_endDate)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickEndTime,
                    child: Text(_endTime.format(context)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: l10n.locationLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _pageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.pageReachedLabel,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _save, child: Text(l10n.save)),
      ],
    );
  }
}
