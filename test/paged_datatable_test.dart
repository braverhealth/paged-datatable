import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paged_datatable/paged_datatable.dart';

void main() {
  group('PagedDataTableThemeData', () {
    test('exposes filter dialog shell styling knobs', () {
      const borderRadius = BorderRadius.all(Radius.circular(12));
      const boxShadow = [
        BoxShadow(
          color: Color(0x33000000),
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ];

      const theme = PagedDataTableThemeData(
        filterDialogBorderRadius: borderRadius,
        filterDialogBoxShadow: boxShadow,
      );

      expect(theme.filterDialogBorderRadius, borderRadius);
      expect(theme.filterDialogBoxShadow, boxShadow);
    });

    test('includes filter dialog shell styling in equality', () {
      const base = PagedDataTableThemeData();
      const custom = PagedDataTableThemeData(
        filterDialogBorderRadius: BorderRadius.all(Radius.circular(12)),
        filterDialogBoxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      );

      expect(base, isNot(custom));
    });
  });

  group('filter dialog', () {
    testWidgets('uses the table theme in the desktop popup route', (
      tester,
    ) async {
      const borderRadius = BorderRadius.all(Radius.circular(12));
      const boxShadow = [
        BoxShadow(
          color: Color(0x33000000),
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ];

      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1800, 800);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            PagedDataTableLocalization.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: Scaffold(
            body: PagedDataTableTheme(
              data: const PagedDataTableThemeData(
                filterDialogBorderRadius: borderRadius,
                filterDialogBoxShadow: boxShadow,
              ),
              child: PagedDataTable<String, String>(
                initialPageSize: 10,
                pageSizes: const [10],
                fetcher: (
                  pageSize,
                  sortModel,
                  filterModel,
                  pageToken,
                ) async =>
                    (const <String>[], null),
                columns: [
                  TableColumn<String, String>(
                    title: const Text('Name'),
                    cellBuilder: (context, item, index) => Text(item),
                  ),
                ],
                filters: [
                  TextTableFilter(
                    id: 'name',
                    name: 'Name',
                    chipFormatter: (value) => value,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.filter_list_rounded));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((widget) {
          if (widget is! Container) return false;
          final decoration = widget.decoration;
          return decoration is BoxDecoration &&
              decoration.borderRadius == borderRadius &&
              decoration.boxShadow == boxShadow;
        }),
        findsOneWidget,
      );
    });
  });
}
