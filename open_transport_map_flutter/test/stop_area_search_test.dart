import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_transport_map_flutter/models/stop_search_result.dart';
import 'package:open_transport_map_flutter/widgets/stop_area_search_bar.dart';

StopSearchResult _stop(
  String name, {
  String? municipality,
  String id = '9021014001760000',
}) => StopSearchResult(
  externalId: id,
  name: name,
  latitude: 57.7,
  longitude: 11.9,
  municipality: municipality,
);

/// Past the 250 ms debounce, then flush the awaited query and its rebuild.
Future<void> _settleSearch(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pump();
}

/// The mobile layout: the search sheet sits directly in the map stack.
Widget _narrowHost({
  required StopAreaSearch search,
  ValueChanged<StopSearchResult>? onSelected,
  Future<List<String>> Function()? recentSearches,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: StopAreaSearchBar(
              wide: false,
              searchStops: search,
              onStopAreaSelected: onSelected ?? (_) {},
              recentSearches: recentSearches,
            ),
          ),
        ],
      ),
    ),
  );
}

/// The desktop layout: the anchored search sits inline.
Widget _wideHost({
  required StopAreaSearch search,
  ValueChanged<StopSearchResult>? onSelected,
  Future<List<String>> Function()? recentSearches,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 320,
          child: StopAreaSearchBar(
            wide: true,
            searchStops: search,
            onStopAreaSelected: onSelected ?? (_) {},
            recentSearches: recentSearches,
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('narrow layout', () {
    testWidgets('peeks the sheet with the field directly tappable', (
      tester,
    ) async {
      await tester.pumpWidget(
        _narrowHost(search: (query) async => [_stop('Brunnsparken')]),
      );

      expect(find.byType(DraggableScrollableSheet), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Type a stop name to search'), findsOneWidget);
    });

    testWidgets('lists matching stops below the box', (tester) async {
      await tester.pumpWidget(
        _narrowHost(
          search: (query) async => [
            _stop('Brunnsparken', municipality: 'Göteborg'),
          ],
        ),
      );

      await tester.enterText(find.byType(TextField), 'brunn');
      await _settleSearch(tester);

      expect(find.text('Brunnsparken'), findsOneWidget);
      expect(find.textContaining('Göteborg'), findsOneWidget);
    });

    testWidgets('shows the no-result state', (tester) async {
      await tester.pumpWidget(_narrowHost(search: (query) async => const []));
      await tester.enterText(find.byType(TextField), 'zzz');
      await _settleSearch(tester);

      expect(find.text('No stops found for "zzz"'), findsOneWidget);
    });

    testWidgets('shows the error state', (tester) async {
      await tester.pumpWidget(
        _narrowHost(search: (query) async => throw Exception('boom')),
      );
      await tester.enterText(find.byType(TextField), 'brunn');
      await _settleSearch(tester);

      expect(find.textContaining('Search error:'), findsOneWidget);
    });

    testWidgets('picking a result reports the stop and clears the field', (
      tester,
    ) async {
      StopSearchResult? picked;
      await tester.pumpWidget(
        _narrowHost(
          search: (query) async => [_stop('Brunnsparken')],
          onSelected: (stop) => picked = stop,
        ),
      );

      await tester.enterText(find.byType(TextField), 'brunn');
      await _settleSearch(tester);
      await tester.tap(find.text('Brunnsparken'));
      await tester.pump();

      expect(picked?.name, 'Brunnsparken');
      expect(find.text('Brunnsparken'), findsNothing);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty,
      );
    });

    testWidgets('shows recent queries while the field is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        _narrowHost(
          search: (query) async => const [],
          recentSearches: () async => ['brunn', 'central'],
        ),
      );
      await tester.pump();

      expect(find.text('brunn'), findsOneWidget);
      expect(find.text('central'), findsOneWidget);
    });

    testWidgets('focusing the field grows the sheet', (tester) async {
      await tester.pumpWidget(_narrowHost(search: (query) async => const []));
      final before = tester.getTopLeft(find.byType(TextField)).dy;

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(tester.getTopLeft(find.byType(TextField)).dy, lessThan(before));
    });

    testWidgets('dragging the handle grows the sheet', (tester) async {
      await tester.pumpWidget(_narrowHost(search: (query) async => const []));
      final before = tester.getTopLeft(find.byType(TextField)).dy;

      await tester.drag(
        find.byKey(stopAreaSearchSheetHandleKey),
        const Offset(0, -150),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(tester.getTopLeft(find.byType(TextField)).dy, lessThan(before));
    });
  });

  group('wide layout', () {
    testWidgets('shows recent queries before a query', (tester) async {
      await tester.pumpWidget(
        _wideHost(
          search: (query) async => const [],
          recentSearches: () async => ['brunn', 'central'],
        ),
      );

      await tester.tap(find.byType(SearchBar));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('brunn'), findsOneWidget);
      expect(find.text('central'), findsOneWidget);
    });

    testWidgets('keeps the desktop anchored search', (tester) async {
      await tester.pumpWidget(
        _wideHost(search: (query) async => [_stop('Brunnsparken')]),
      );

      expect(find.byType(SearchBar), findsOneWidget);

      await tester.tap(find.byType(SearchBar));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.enterText(find.byType(TextField).first, 'brunn');
      await _settleSearch(tester);

      expect(find.text('Brunnsparken'), findsOneWidget);
    });
  });
}
