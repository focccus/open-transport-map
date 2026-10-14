import 'dart:async';

import 'package:flutter/material.dart';

import '../client.dart';
import '../models/stop_search_result.dart';

/// Signature of the stop-area query, so a layout can be tested without a server
/// by injecting its own handler.
typedef StopAreaSearch = Future<List<StopSearchResult>> Function(String query);

const _searchHint = 'Search stops (e.g. Centralstation)...';

/// Key of the narrow search sheet's grabber, so a test can drag it to grow the
/// sheet.
const stopAreaSearchSheetHandleKey = Key('stop-area-search-handle');

/// Stop-area search, presented for the layout it sits in.
///
/// On a wide layout ([wide]) the desktop search is kept: a [SearchAnchor] whose
/// suggestions open in Material's anchored view. On a narrow layout the search
/// is a bottom sheet that always peeks at the bottom, so the field is directly
/// tappable; its body lists the results and the sheet grows as the user drags
/// or scrolls.
///
/// Results come from the local stop cache by default; [searchStops] overrides
/// that. [recentSearches] and [onSearchCommitted] wire the recent-query history.
class StopAreaSearchBar extends StatelessWidget {
  const StopAreaSearchBar({
    super.key,
    required this.onStopAreaSelected,
    this.wide = false,
    this.searchStops,
    this.recentSearches,
    this.onSearchCommitted,
  });

  /// Called when a stop area is picked from the results.
  final ValueChanged<StopSearchResult> onStopAreaSelected;

  /// Whether to render the desktop anchored search (wide) instead of the
  /// peeking bottom sheet (narrow).
  final bool wide;

  /// Optional search handler for querying stop areas, e.g. for testing.
  /// Defaults to the local stop cache.
  final StopAreaSearch? searchStops;

  /// Loads the most recently used queries, newest first. When null no recent
  /// queries are shown.
  final Future<List<String>> Function()? recentSearches;

  /// Called with the query that led to a picked stop, to record it as recent.
  final ValueChanged<String>? onSearchCommitted;

  Future<List<StopSearchResult>> _search(String query) =>
      searchStops?.call(query) ?? stopSearchStore.search(query);

  @override
  Widget build(BuildContext context) {
    return wide
        ? _AnchoredStopAreaSearch(
            search: _search,
            onStopAreaSelected: onStopAreaSelected,
            recentSearches: recentSearches,
            onSearchCommitted: onSearchCommitted,
          )
        : _StopAreaSearchSheet(
            search: _search,
            onStopAreaSelected: onStopAreaSelected,
            recentSearches: recentSearches,
            onSearchCommitted: onSearchCommitted,
          );
  }
}

/// Desktop search: the search the app has always had, a [SearchAnchor] whose
/// suggestions open in Material's anchored view.
class _AnchoredStopAreaSearch extends StatefulWidget {
  const _AnchoredStopAreaSearch({
    required this.search,
    required this.onStopAreaSelected,
    this.recentSearches,
    this.onSearchCommitted,
  });

  final StopAreaSearch search;
  final ValueChanged<StopSearchResult> onStopAreaSelected;
  final Future<List<String>> Function()? recentSearches;
  final ValueChanged<String>? onSearchCommitted;

  @override
  State<_AnchoredStopAreaSearch> createState() =>
      _AnchoredStopAreaSearchState();
}

class _AnchoredStopAreaSearchState extends State<_AnchoredStopAreaSearch> {
  final SearchController _controller = SearchController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Iterable<Widget>> _buildSuggestions(
    BuildContext context,
    SearchController controller,
  ) async {
    final query = controller.text.trim();
    if (query.isEmpty) {
      return await _recentSuggestions(controller);
    }

    // 250ms debounce
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (controller.text.trim() != query) {
      return const [];
    }

    try {
      final results = await widget.search(query);

      if (controller.text.trim() != query) {
        return const [];
      }

      if (results.isEmpty) {
        return [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Center(child: Text('No stops found for "$query"')),
          ),
        ];
      }

      return results.map((stop) {
        final municipality = stop.municipality;

        return ListTile(
          leading: const Icon(Icons.directions_transit),
          title: Text(stop.name),
          subtitle: municipality != null && municipality.isNotEmpty
              ? Text(municipality)
              : null,
          onTap: () {
            controller.closeView(stop.name);
            widget.onSearchCommitted?.call(query);
            widget.onStopAreaSelected(stop);
          },
        );
      });
    } catch (e) {
      if (controller.text.trim() != query) {
        return const [];
      }
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Center(child: Text('Search error: $e')),
        ),
      ];
    }
  }

  /// What the view shows before a query: the most recently picked queries, or
  /// the prompt when there is no history.
  Future<Iterable<Widget>> _recentSuggestions(
    SearchController controller,
  ) async {
    final load = widget.recentSearches;
    final recents = load == null ? const <String>[] : await load();
    if (recents.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Center(
            child: Text(
              'Type a stop name to search',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ];
    }
    return [
      for (final recent in recents)
        ListTile(
          leading: const Icon(Icons.history),
          title: Text(recent),
          onTap: () {
            // The anchor listens to the controller, so setting the text reruns
            // the suggestions for the picked query.
            controller.text = recent;
            controller.selection = TextSelection.collapsed(
              offset: recent.length,
            );
          },
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _controller,
      viewHintText: _searchHint,
      builder: (context, controller) {
        return ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return SearchBar(
              controller: controller,
              hintText: _searchHint,
              leading: const Icon(Icons.search),
              trailing: [
                if (controller.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    tooltip: 'Clear',
                    onPressed: () {
                      controller.clear();
                    },
                  ),
              ],
              onTap: () {
                controller.openView();
              },
              onChanged: (_) {
                controller.openView();
              },
            );
          },
        );
      },
      suggestionsBuilder: _buildSuggestions,
    );
  }
}

/// Narrow-layout search: a bottom sheet that always peeks at the bottom so the
/// field is directly tappable, growing as the user drags or scrolls.
class _StopAreaSearchSheet extends StatefulWidget {
  const _StopAreaSearchSheet({
    required this.search,
    required this.onStopAreaSelected,
    this.recentSearches,
    this.onSearchCommitted,
  });

  final StopAreaSearch search;
  final ValueChanged<StopSearchResult> onStopAreaSelected;
  final Future<List<String>> Function()? recentSearches;
  final ValueChanged<String>? onSearchCommitted;

  @override
  State<_StopAreaSearchSheet> createState() => _StopAreaSearchSheetState();
}

class _StopAreaSearchSheetState extends State<_StopAreaSearchSheet> {
  // Same snap sizes and settling as the departures sheet, so the two sheets
  // feel alike even though they drag through their own controllers.
  static const _minSize = 0.15;
  static const _initialSize = 0.4;
  static const _maxSize = 2 / 3;
  static const _snapSizes = <double>[_minSize, _initialSize, _maxSize];
  static const _snapDuration = Duration(milliseconds: 200);
  static const _flingVelocity = 400.0;
  static const _sizeEpsilon = 0.005;

  final _sheetController = DraggableScrollableController();
  final _field = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChanged);
    _sheetController.dispose();
    _field.dispose();
    _focus.dispose();
    super.dispose();
  }

  /// Tapping the bar opens the sheet enough to show results; leaving it empty
  /// and unfocused drops it back to the peek.
  void _onFocusChanged() {
    if (!_sheetController.isAttached) return;
    if (_focus.hasFocus && _sheetController.size < _initialSize) {
      unawaited(_animateSize(_initialSize));
    } else if (!_focus.hasFocus && _field.text.trim().isEmpty) {
      unawaited(_animateSize(_minSize));
    }
  }

  void _select(StopSearchResult stop) {
    widget.onSearchCommitted?.call(_field.text);
    _field.clear();
    _focus.unfocus();
    widget.onStopAreaSelected(stop);
  }

  /// Runs a recent query again by putting it back in the field.
  void _useRecent(String query) {
    _field.text = query;
    _field.selection = TextSelection.collapsed(offset: query.length);
    _focus.requestFocus();
  }

  void _dragHandle(DragUpdateDetails details, double parentHeight) {
    if (!_sheetController.isAttached || parentHeight <= 0) return;
    final next = (_sheetController.size - details.delta.dy / parentHeight)
        .clamp(
          _minSize,
          _maxSize,
        );
    _sheetController.jumpTo(next);
  }

  void _endHandleDrag(DragEndDetails details) {
    if (!_sheetController.isAttached) return;
    final current = _sheetController.size;
    final velocity = details.velocity.pixelsPerSecond.dy;
    final target = velocity.abs() > _flingVelocity
        ? _stepSize(current, velocity > 0 ? -1 : 1)
        : _nearestSize(current);
    unawaited(_animateSize(target));
  }

  /// Snap size nearest to [current].
  double _nearestSize(double current) {
    var best = _snapSizes.first;
    var bestDelta = (best - current).abs();
    for (final size in _snapSizes.skip(1)) {
      final delta = (size - current).abs();
      if (delta >= bestDelta) continue;
      best = size;
      bestDelta = delta;
    }
    return best;
  }

  /// Next snap size in [step]'s direction: -1 collapses, 1 expands.
  double _stepSize(double current, int step) {
    if (step < 0) {
      for (final size in _snapSizes) {
        if (size < current - _sizeEpsilon) return size;
      }
      return _snapSizes.first;
    }
    for (final size in _snapSizes.reversed) {
      if (size > current + _sizeEpsilon) return size;
    }
    return _snapSizes.last;
  }

  Future<void> _animateSize(double size) async {
    if (!_sheetController.isAttached) return;
    try {
      await _sheetController.animateTo(
        size,
        duration: _snapDuration,
        curve: Curves.easeOutCubic,
      );
    } catch (_) {
      // The sheet was closed mid-animation.
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final parentHeight = constraints.maxHeight;
        return DraggableScrollableSheet(
          controller: _sheetController,
          // Starts as a peek: the field is visible, the body is out of sight.
          initialChildSize: _minSize,
          minChildSize: _minSize,
          maxChildSize: _maxSize,
          snap: true,
          snapSizes: _snapSizes,
          snapAnimationDuration: _snapDuration,
          builder: (context, scrollController) => Material(
            elevation: 8,
            clipBehavior: Clip.antiAlias,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: GestureDetector(
              // Inside the list the sheet follows the scroll itself; this
              // catches the grabber and the field, which sit outside it.
              onVerticalDragUpdate: (details) =>
                  _dragHandle(details, parentHeight),
              onVerticalDragEnd: _endHandleDrag,
              child: Column(
                children: [
                  const _SheetGrabber(key: stopAreaSearchSheetHandleKey),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                    child: _StopSearchField(
                      controller: _field,
                      focusNode: _focus,
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _field,
                      builder: (context, value, _) => _StopAreaSearchResults(
                        query: value.text,
                        search: widget.search,
                        onSelected: _select,
                        recentSearches: widget.recentSearches,
                        onRecentSelected: _useRecent,
                        scrollController: scrollController,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// The query field shared by the narrow sheet.
class _StopSearchField extends StatelessWidget {
  const _StopSearchField({required this.controller, this.focusNode});

  final TextEditingController controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: _searchHint,
        isDense: true,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: 'Clear',
                  onPressed: controller.clear,
                ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}

/// Centred grabber bar at the top of the search sheet.
class _SheetGrabber extends StatelessWidget {
  const _SheetGrabber({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          width: 34,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

/// Which body the results widget is showing.
enum _SearchPhase { idle, loading, results, empty, error }

/// The query and results body the narrow sheet renders.
///
/// Debounces [query], runs it through [search], and renders the result rows,
/// the recently used queries, or the loading, no-result, and error states.
class _StopAreaSearchResults extends StatefulWidget {
  const _StopAreaSearchResults({
    required this.query,
    required this.search,
    required this.onSelected,
    this.recentSearches,
    this.onRecentSelected,
    this.scrollController,
  });

  final String query;
  final StopAreaSearch search;
  final ValueChanged<StopSearchResult> onSelected;
  final Future<List<String>> Function()? recentSearches;
  final ValueChanged<String>? onRecentSelected;

  /// Listens to the results list; the sheet passes the controller its drag
  /// needs.
  final ScrollController? scrollController;

  @override
  State<_StopAreaSearchResults> createState() => _StopAreaSearchResultsState();
}

class _StopAreaSearchResultsState extends State<_StopAreaSearchResults> {
  static const _debounce = Duration(milliseconds: 250);

  final _ownScrollController = ScrollController();
  Timer? _timer;

  /// Monotonic id of the in-flight query. A reply whose id is stale is dropped,
  /// so a fast typist never sees an older query's results.
  int _requestId = 0;
  _SearchPhase _phase = _SearchPhase.idle;
  List<StopSearchResult> _results = const [];
  String _error = '';
  String _answeredQuery = '';

  @override
  void initState() {
    super.initState();
    _run(widget.query);
  }

  @override
  void didUpdateWidget(covariant _StopAreaSearchResults oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != oldWidget.query) _run(widget.query);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ownScrollController.dispose();
    super.dispose();
  }

  /// Applies the new query. Called from [initState] and [didUpdateWidget], both
  /// of which are followed by a build, so it deliberately does not `setState`.
  void _run(String rawQuery) {
    _timer?.cancel();
    final query = rawQuery.trim();
    if (query.isEmpty) {
      _requestId++;
      _phase = _SearchPhase.idle;
      _results = const [];
      _error = '';
      _answeredQuery = '';
      return;
    }
    _phase = _SearchPhase.loading;
    _timer = Timer(_debounce, () => _query(query));
  }

  Future<void> _query(String query) async {
    final id = ++_requestId;
    try {
      final results = await widget.search(query);
      if (!mounted || id != _requestId) return;
      setState(() {
        _answeredQuery = query;
        _results = results;
        _error = '';
        _phase = results.isEmpty ? _SearchPhase.empty : _SearchPhase.results;
      });
    } catch (error) {
      if (!mounted || id != _requestId) return;
      setState(() {
        _answeredQuery = query;
        _error = '$error';
        _phase = _SearchPhase.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_phase) {
      case _SearchPhase.idle:
        final load = widget.recentSearches;
        if (load == null) {
          return const _SearchMessage('Type a stop name to search');
        }
        return _RecentQueries(load: load, onSelected: widget.onRecentSelected);
      case _SearchPhase.loading:
        return const _SearchMessage('Searching…');
      case _SearchPhase.empty:
        return _SearchMessage('No stops found for "$_answeredQuery"');
      case _SearchPhase.error:
        return _SearchMessage('Search error: $_error');
      case _SearchPhase.results:
        return ListView.builder(
          controller: widget.scrollController ?? _ownScrollController,
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: _results.length,
          itemBuilder: (context, index) =>
              _StopRow(stop: _results[index], onTap: widget.onSelected),
        );
    }
  }
}

/// The recently used queries, shown while the field is empty. Falls back to the
/// hint when there is no history yet.
class _RecentQueries extends StatefulWidget {
  const _RecentQueries({required this.load, this.onSelected});

  final Future<List<String>> Function() load;
  final ValueChanged<String>? onSelected;

  @override
  State<_RecentQueries> createState() => _RecentQueriesState();
}

class _RecentQueriesState extends State<_RecentQueries> {
  late final Future<List<String>> _queries = widget.load();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _queries,
      builder: (context, snapshot) {
        final queries = snapshot.data ?? const <String>[];
        if (queries.isEmpty) {
          return const _SearchMessage('Type a stop name to search');
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: queries.length,
          itemBuilder: (context, index) {
            final query = queries[index];
            return ListTile(
              leading: const Icon(Icons.history),
              title: Text(query),
              onTap: widget.onSelected == null
                  ? null
                  : () => widget.onSelected!(query),
            );
          },
        );
      },
    );
  }
}

/// One stop-area result row.
class _StopRow extends StatelessWidget {
  const _StopRow({required this.stop, required this.onTap});

  final StopSearchResult stop;
  final ValueChanged<StopSearchResult> onTap;

  @override
  Widget build(BuildContext context) {
    final municipality = stop.municipality;
    return ListTile(
      leading: const Icon(Icons.directions_transit),
      title: Text(stop.name),
      subtitle: municipality != null && municipality.isNotEmpty
          ? Text(municipality)
          : null,
      onTap: () => onTap(stop),
    );
  }
}

/// Centred placeholder for the empty, loading, no-result, and error states.
class _SearchMessage extends StatelessWidget {
  const _SearchMessage(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
