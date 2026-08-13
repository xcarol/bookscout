import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookscout/l10n/app_localizations.dart';
import 'package:bookscout/models/book.dart';
import 'package:bookscout/models/search_filter.dart';
import 'package:bookscout/services/books/book_search_service.dart';
import 'package:bookscout/services/settings/search_history_service.dart';
import 'package:bookscout/utils/app_constants.dart';
import 'package:bookscout/widgets/cards/book_card.dart';
import 'package:bookscout/screens/book_details_screen.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  late final TextEditingController _controller;
  late final BookSearchService _searchService;
  final SearchHistoryService _historyService = SearchHistoryService();

  String _previousText = '';
  String _lastSearchedText = '';
  SearchFilter _searchFilter = SearchFilter.title;
  Timer? _debounce;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final String _searchGroupId = 'book_search_overlay_group';
  final double _searchHorizontalPadding = 8.0;
  final double _searchVerticalPadding = 12.0;
  final double _overlayHeightOffset = 60.0;
  List<String> _overlaySuggestions = [];

  @override
  void initState() {
    super.initState();
    _searchService = BookSearchService();
    _controller = TextEditingController();
    _controller.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChanged);
    _scrollController.addListener(_onScroll);
    _historyService.load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _removeOverlay();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _controller.removeListener(_onSearchChanged);
    _searchFocusNode.removeListener(_onFocusChanged);
    _controller.dispose();
    _searchFocusNode.dispose();
    _searchService.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_searchService.hasMore && !_searchService.isLoadingMore) {
        final langCode = Localizations.localeOf(context).languageCode;
        _searchService.loadMore(langCode: langCode);
      }
    }
  }

  StateSetter? _overlaySetState;

  void _onFocusChanged() {
    if (_searchFocusNode.hasFocus) {
      _showOverlay();
    }
  }

  void _onSearchChanged() {
    final text = _controller.text;

    if (_searchFocusNode.hasFocus) {
      _showOverlay();
    }

    if (text == _previousText) return;

    if (text.isNotEmpty && text.length > _previousText.length) {
      final suggestions = _historyService.getSuggestions(text);
      if (suggestions.isNotEmpty) {
        final bestMatch = suggestions.first;
        if (bestMatch.toLowerCase().startsWith(text.toLowerCase()) &&
            bestMatch.length > text.length) {
          _controller.value = TextEditingValue(
            text: bestMatch,
            selection: TextSelection(
              baseOffset: text.length,
              extentOffset: bestMatch.length,
            ),
          );
        }
      }
    }
    _previousText = _controller.text;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (text.trim().length >= AppConstants.minSearchChars) {
      _debounce = Timer(
        const Duration(milliseconds: AppConstants.searchDebounceMs),
        () {
          if (mounted) {
            searchBooks(_controller.text);
          }
        },
      );
    } else if (text.trim().isEmpty) {
      _resetLastSearch();
      _searchService.clear();
    }
  }

  void _showOverlay() {
    final text = _controller.text.trim();
    final suggestions = _historyService.getSuggestions(text);
    _overlaySuggestions = text.isEmpty
        ? suggestions.take(5).toList()
        : suggestions
              .where((s) => s.toLowerCase() != text.toLowerCase())
              .take(5)
              .toList();

    if (_overlaySuggestions.isEmpty) {
      _removeOverlay();
      return;
    }

    if (_overlayEntry != null) {
      _overlaySetState?.call(() {});
      return;
    }

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          width:
              MediaQuery.sizeOf(context).width - _searchHorizontalPadding * 2,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(_searchHorizontalPadding, _overlayHeightOffset),
            child: TapRegion(
              groupId: _searchGroupId,
              child: StatefulBuilder(
                builder: (context, setOverlayState) {
                  _overlaySetState = setOverlayState;
                  return _suggestionsList();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _suggestionsList() {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: _overlaySuggestions.length,
        itemBuilder: (context, index) {
          final suggestion = _overlaySuggestions[index];
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text(suggestion),
            trailing: IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () async {
                await _historyService.delete(suggestion);
                if (mounted) {
                  _showOverlay();
                }
              },
            ),
            onTap: () {
              _controller.text = suggestion;
              _removeOverlay();
              searchBooks(suggestion);
            },
          );
        },
      ),
    );
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _overlaySetState = null;
  }

  void _resetLastSearch() {
    _lastSearchedText = '';
  }

  Future<void> _resetSearch({bool clearText = false}) async {
    if (clearText) {
      _controller.clear();
      _previousText = '';
      _resetLastSearch();
      _removeOverlay();
    }
    _searchService.clear();
  }

  void searchBooks(String query) async {
    final term = query.trim();
    if (term.isEmpty) return;

    await _historyService.add(term);

    if (term == _lastSearchedText) return;

    _lastSearchedText = term;
    _removeOverlay();

    if (!mounted) return;
    final langCode = Localizations.localeOf(context).languageCode;
    await _searchService.search(
      term,
      langCode: langCode,
      filter: _searchFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _searchService,
      child: GestureDetector(
        onTap: () {
          _removeOverlay();
          _searchFocusNode.unfocus();
        },
        child: Column(
          children: <Widget>[
            TapRegion(
              groupId: _searchGroupId,
              onTapOutside: (event) {
                _removeOverlay();
              },
              child: CompositedTransformTarget(
                link: _layerLink,
                child: searchBox(),
              ),
            ),
            Expanded(child: searchResults()),
          ],
        ),
      ),
    );
  }

  Widget searchBox() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = colorScheme.onSurface;
    final borderColor = colorScheme.outline;

    return Container(
      color: colorScheme.surfaceContainer,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: _searchHorizontalPadding,
        vertical: _searchVerticalPadding,
      ),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            focusNode: _searchFocusNode,
            style: TextStyle(color: textColor),
            cursorColor: colorScheme.primary,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchHint,
              hintStyle: TextStyle(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              prefixIcon: Icon(Icons.search, color: colorScheme.primary),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () async =>
                          await _resetSearch(clearText: true),
                      tooltip: AppLocalizations.of(context)!.clearSearch,
                    )
                  : null,
              filled: true,
              fillColor: colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor.withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
            ),
            onSubmitted: (title) {
              searchBooks(title);
            },
          ),
          const SizedBox(height: 12),
          SegmentedButton<SearchFilter>(
            segments: [
              ButtonSegment<SearchFilter>(
                value: SearchFilter.all,
                label: Text(AppLocalizations.of(context)!.searchFilterAll),
              ),
              ButtonSegment<SearchFilter>(
                value: SearchFilter.title,
                label: Text(AppLocalizations.of(context)!.searchFilterTitle),
              ),
              ButtonSegment<SearchFilter>(
                value: SearchFilter.author,
                label: Text(AppLocalizations.of(context)!.searchFilterAuthor),
              ),
              ButtonSegment<SearchFilter>(
                value: SearchFilter.isbn,
                label: Text(AppLocalizations.of(context)!.searchFilterIsbn),
              ),
            ],
            selected: <SearchFilter>{_searchFilter},
            onSelectionChanged: (Set<SearchFilter> newSelection) {
              setState(() {
                _searchFilter = newSelection.first;
              });
              if (_controller.text.trim().isNotEmpty) {
                _resetLastSearch();
                searchBooks(_controller.text);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget searchResults() {
    return Consumer<BookSearchService>(
      builder: (context, service, _) {
        if (service.isLoading) {
          return _loadingState();
        }

        if (service.hasError) {
          return _errorState(context, service);
        }

        if (service.currentQuery.isEmpty) {
          return _initialState(context);
        }

        if (service.isEmpty) {
          return _emptyState(context);
        }

        return _resultsList(service);
      },
    );
  }

  Widget _loadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _errorState(BuildContext context, BookSearchService service) {
    final l10n = AppLocalizations.of(context)!;
    final isTimeout = service.errorMessage == 'TIMEOUT';
    final errorText = isTimeout ? l10n.searchTimeout : l10n.searchError;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              errorText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                if (_lastSearchedText.isNotEmpty) {
                  final term = _lastSearchedText;
                  _lastSearchedText = '';
                  searchBooks(term);
                }
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _initialState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            size: 64,
            color: theme.colorScheme.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.searchInitialPrompt,
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: theme.colorScheme.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noBooksFound,
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultsList(BookSearchService service) {
    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.zero,
        itemCount: service.count + (service.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == service.count) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              ),
            );
          }

          final Book? book = service.getItem(index);
          if (book == null) return const SizedBox.shrink();

          return BookCard(
            book: book,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BookDetailsScreen(book: book),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
