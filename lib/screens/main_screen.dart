import 'package:flutter/material.dart';
import 'package:bookscout/l10n/app_localizations.dart';
import 'package:bookscout/models/custom_colors.dart';
import 'package:bookscout/screens/search.dart';
import 'package:bookscout/widgets/layout/app_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
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
    );
  }

  Widget _homeView(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            l10n.welcomeMessage,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
