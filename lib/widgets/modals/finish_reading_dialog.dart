import 'package:flutter/material.dart';
import 'package:bookscout/database/app_database.dart';
import 'package:bookscout/services/books/library_repository.dart';
import 'package:bookscout/services/books/reading_session_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:bookscout/l10n/app_localizations.dart';
import 'package:bookscout/utils/reading_session_validator.dart';
import 'package:bookscout/models/reading_location.dart';

class FinishReadingDialog extends StatefulWidget {
  final String bookId;
  final DateTime initialStartTime;
  final String? initialLocation;

  final bool isManualAdd;
  final ReadingSession? existingSession;

  const FinishReadingDialog({
    super.key,
    required this.bookId,
    required this.initialStartTime,
    this.initialLocation,
    this.isManualAdd = false,
    this.existingSession,
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
  bool _initializedLocation = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initializedLocation) {
      _initializedLocation = true;
      final dbText =
          widget.existingSession?.location ?? widget.initialLocation ?? '';
      if (dbText.isNotEmpty) {
        final loc = ReadingLocation.fromString(dbText);
        if (loc != ReadingLocation.other || dbText == 'other') {
          _locationController.text = loc.getLocalizedName(context);
        } else {
          _locationController.text = dbText;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.existingSession != null) {
      final s = widget.existingSession!;
      _endDate = s.date;
      _endTime = TimeOfDay.fromDateTime(s.date);
      _startDate = s.date.subtract(Duration(minutes: s.durationMinutes));
      _startTime = TimeOfDay.fromDateTime(_startDate);
      _pageController.text = s.endPage.toString();
    } else {
      _startDate = widget.initialStartTime;
      _startTime = TimeOfDay.fromDateTime(widget.initialStartTime);

      final now = DateTime.now();
      _endDate = now;
      _endTime = TimeOfDay.fromDateTime(now);
    }

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
    var sessions = await repo.getReadingSessions(widget.bookId);

    if (widget.existingSession != null) {
      sessions = sessions
          .where((s) => s.id != widget.existingSession!.id)
          .toList();
    }

    if (mounted) {
      setState(() {
        _previousSessions = sessions;
        _isLoading = false;

        if (widget.existingSession == null) {
          if (sessions.isNotEmpty) {
            _pageController.text = sessions.first.endPage.toString();
          } else {
            _pageController.text = '0';
          }
        }
      });
    }
  }

  Future<void> _save() async {
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

    final int? endPageInput = int.tryParse(_pageController.text);
    final error = ReadingSessionValidator.validate(
      context: context,
      start: start,
      end: end,
      endPage: endPageInput,
      previousSessions: _previousSessions,
    );

    if (error != null) {
      setState(() => _errorMsg = error);
      return;
    }

    final int endPage = int.parse(_pageController.text);
    final duration = end.difference(start).inMinutes;
    final libraryRepo = context.read<LibraryRepository>();
    final sessionService = context.read<ReadingSessionService>();

    String locationToSave = _locationController.text;
    for (final loc in ReadingLocation.values) {
      if (loc.getLocalizedName(context) == locationToSave) {
        locationToSave = loc.name;
        break;
      }
    }

    if (widget.existingSession != null) {
      final updatedSession = ReadingSession(
        id: widget.existingSession!.id,
        bookId: widget.bookId,
        date: end,
        endPage: endPage,
        durationMinutes: duration,
        location: locationToSave,
        createdAt: widget.existingSession!.createdAt,
      );
      await libraryRepo.updateReadingSession(updatedSession);
    } else {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final session = ReadingSession(
        id: id,
        bookId: widget.bookId,
        date: end,
        endPage: endPage,
        durationMinutes: duration,
        location: locationToSave,
        createdAt: DateTime.now(),
      );
      await libraryRepo.insertReadingSession(session);

      if (!widget.isManualAdd) {
        await sessionService.endSession();
      }
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _ensureChronologicalOrder() {
    DateTime start = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _startTime.hour,
      _startTime.minute,
    );
    DateTime end = DateTime(
      _endDate.year,
      _endDate.month,
      _endDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    final now = DateTime.now();

    if (start.isAfter(now)) {
      start = now;
      _startDate = start;
      _startTime = TimeOfDay.fromDateTime(start);
    }

    if (end.isAfter(now)) {
      end = now;
      _endDate = end;
      _endTime = TimeOfDay.fromDateTime(end);
    }

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
    if (d != null) {
      setState(() {
        _endDate = d;
        _ensureChronologicalOrder();
      });
    }
  }

  Future<void> _pickEndTime() async {
    final t = await showTimePicker(context: context, initialTime: _endTime);
    if (t != null) {
      setState(() {
        _endTime = t;
        _ensureChronologicalOrder();
      });
    }
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

            DropdownMenu<String>(
              controller: _locationController,
              label: Text(l10n.locationLabel),
              expandedInsets: EdgeInsets.zero,
              requestFocusOnTap: true,
              dropdownMenuEntries: ReadingLocation.values
                  .map(
                    (loc) => DropdownMenuEntry(
                      value: loc.name,
                      label: loc.getLocalizedName(context),
                    ),
                  )
                  .toList(),
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
