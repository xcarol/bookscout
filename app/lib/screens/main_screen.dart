import 'package:flutter/material.dart';
import 'package:bookscout/l10n/app_localizations.dart';
import 'package:bookscout/models/custom_colors.dart';
import 'package:bookscout/screens/search.dart';
import 'package:bookscout/widgets/layout/app_drawer.dart';
import 'package:bookscout/widgets/lists/book_list.dart';
import 'package:bookscout/screens/reading_session_overlay.dart';
import 'package:bookscout/services/books/reading_session_service.dart';
import 'package:bookscout/services/books/book_list_service.dart';
import 'package:bookscout/services/books/library_repository.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late final BookListService _libraryListService;

  @override
  void initState() {
    super.initState();
    final libraryRepository = context.read<LibraryRepository>();
    _libraryListService = BookListService(libraryRepository)..load();
  }

  @override
  void dispose() {
    _libraryListService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final customColors = Theme.of(context).extension<CustomColors>()!;

    final readingSessionService = context.watch<ReadingSessionService>();

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: customColors.appBarText),
            title: Text(
              _getTitleForIndex(_currentIndex, context),
              style: TextStyle(
                color: customColors.appBarText,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            centerTitle: true,
            backgroundColor: customColors.appBarBackground,
          ),
          drawer: const AppDrawer(),
          body: IndexedStack(
            index: _currentIndex,
            children: [_homeView(context), const Search()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: customColors.navigationBarSelected,
            unselectedItemColor: customColors.navigationBarNotSelected,
            backgroundColor: customColors.bottomNavigationBarBackground,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (newIndex) {
              setState(() {
                _currentIndex = newIndex;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.menu_book_rounded),
                label: '',
                tooltip: l10n.home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.search_rounded),
                label: '',
                tooltip: l10n.search,
              ),
            ],
          ),
        ),

        if (readingSessionService.isSessionActive &&
            !readingSessionService.isMinimized)
          const Positioned.fill(child: ReadingSessionOverlay()),

        if (readingSessionService.isSessionActive &&
            readingSessionService.isMinimized)
          Positioned(
            bottom: 80,
            right: 16,
            child: FloatingActionButton.extended(
              onPressed: () => readingSessionService.maximizeSession(),
              icon: const Icon(Icons.menu_book_rounded),
              label: const Text('Session'),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
      ],
    );
  }

  Widget _homeView(BuildContext context) {
    return BookList(listService: _libraryListService);
  }

  String _getTitleForIndex(int index, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (index) {
      case 0:
        return 'BookScout';
      case 1:
        return l10n.search;
      default:
        return 'BookScout';
    }
  }
}
