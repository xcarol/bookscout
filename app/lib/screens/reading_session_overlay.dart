import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bookscout/models/book.dart';
import 'package:bookscout/models/reading_location.dart';
import 'package:bookscout/l10n/app_localizations.dart';
import 'package:bookscout/services/books/library_repository.dart';
import 'package:bookscout/services/books/reading_session_service.dart';
import 'package:bookscout/widgets/modals/finish_reading_dialog.dart';

class ReadingSessionOverlay extends StatefulWidget {
  const ReadingSessionOverlay({super.key});

  @override
  State<ReadingSessionOverlay> createState() => _ReadingSessionOverlayState();
}

class _ReadingSessionOverlayState extends State<ReadingSessionOverlay> {
  Book? _book;
  Timer? _timer;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadBook();

    final startTime = context.read<ReadingSessionService>().sessionStartTime;
    if (startTime != null) {
      _duration = DateTime.now().difference(startTime);
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        final startTime = context
            .read<ReadingSessionService>()
            .sessionStartTime;
        if (startTime != null) {
          setState(() {
            _duration = DateTime.now().difference(startTime);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadBook() async {
    final service = context.read<ReadingSessionService>();
    final repo = context.read<LibraryRepository>();
    if (service.activeBookId != null) {
      final book = await repo.getBook(service.activeBookId!);
      if (mounted && book != null) {
        setState(() {
          _book = book;
        });
      }
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    if (d.inHours > 0) return "$hours:$minutes:$seconds";
    return "$minutes:$seconds";
  }

  void _onEndSession() {
    final service = context.read<ReadingSessionService>();
    if (service.activeBookId == null || service.sessionStartTime == null) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => FinishReadingDialog(
        bookId: service.activeBookId!,
        initialStartTime: service.sessionStartTime!,
        initialLocation: service.sessionLocation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ReadingSessionService>();
    if (!service.isSessionActive || service.isMinimized) {
      return const SizedBox.shrink();
    }

    if (_book == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locations = ReadingLocation.values;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sessionInProgress),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32),
          onPressed: () {
            service.minimizeSession();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Expanded(
                flex: 4,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _book!.coverUrl?.isNotEmpty == true
                          ? CachedNetworkImage(
                              imageUrl: _book!.coverUrl!,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _book!.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_book!.authorsFormatted.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  _book!.authorsFormatted,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              Text(
                _formatDuration(_duration),
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w300,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ReadingLocation>(
                    value: service.sessionLocation != null
                        ? ReadingLocation.fromString(service.sessionLocation!)
                        : ReadingLocation.home,
                    icon: const Icon(Icons.location_on_outlined),
                    alignment: AlignmentDirectional.center,
                    items: locations.map((loc) {
                      return DropdownMenuItem(
                        value: loc,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(loc.icon, size: 18),
                            const SizedBox(width: 8),
                            Text(loc.getLocalizedName(context).toUpperCase()),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        service.updateLocation(val.name);
                      }
                    },
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _onEndSession,
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: Text(l10n.endSessionButton),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
