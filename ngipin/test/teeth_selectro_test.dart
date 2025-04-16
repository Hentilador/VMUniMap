import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teeth_selector/teeth_selector.dart'; // Adjust the import as per your project structure

void main() {
  group('TeethSelector Widget Tests', () {
    late List<String> selectedTeeth;

    setUp(() {
      selectedTeeth = [];
    });

    Widget createWidgetUnderTest({
      List<String> initiallySelected = const [],
      bool multiSelect = false,
      bool showPrimary = false,
      bool showPermanent = true,
      String leftString = "Left",
      String rightString = "Right",
      String Function(String isoString)? notation,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: TeethSelector(
            initiallySelected: initiallySelected,
            multiSelect: multiSelect,
            showPrimary: showPrimary,
            showPermanent: showPermanent,
            onChange: (selected) {
              selectedTeeth = selected;
            },
            rightString: rightString,
            leftString: leftString,
            notation: notation,
          ),
        ),
      );
    }

    testWidgets('renders without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(TeethSelector), findsOneWidget);
    });

    testWidgets("Selects teeth & multiselect is disabled by default", (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Test first selection
      expect(find.byKey(Key("tooth-iso-11-not-selected")), findsOneWidget);
      await tester.tap(find.byKey(Key("tooth-iso-11-not-selected")));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("tooth-iso-11-not-selected")), findsNothing);
      expect(find.byKey(Key("tooth-iso-11-selected")), findsOneWidget);
      expect(selectedTeeth, ['11']);

      // Test second selection
      expect(find.byKey(Key("tooth-iso-12-not-selected")), findsOneWidget);
      await tester.tap(find.byKey(Key("tooth-iso-12-not-selected")));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("tooth-iso-12-not-selected")), findsNothing);
      expect(find.byKey(Key("tooth-iso-11-not-selected")), findsOneWidget);

      expect(selectedTeeth, ['12']);
    });

    testWidgets("Initially selected works", (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(initiallySelected: ['11']));
      expect(find.byKey(Key("tooth-iso-11-selected")), findsOneWidget);
      expect(find.byKey(Key("tooth-iso-12-selected")), findsNothing);

      await tester.tap(find.byKey(Key("tooth-iso-12-not-selected")));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("tooth-iso-11-selected")), findsNothing);
      expect(find.byKey(Key("tooth-iso-12-selected")), findsOneWidget);
    });

    testWidgets("Tapping again would deselect the selected both in multi select", (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(initiallySelected: ['11', '12'], multiSelect: true));
      expect(find.byKey(Key("tooth-iso-11-selected")), findsOneWidget);
      expect(find.byKey(Key("tooth-iso-12-selected")), findsOneWidget);

      await tester.tap(find.byKey(Key("tooth-iso-11-selected")));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("tooth-iso-11-selected")), findsNothing);
      expect(find.byKey(Key("tooth-iso-12-selected")), findsOneWidget);

      await tester.tap(find.byKey(Key("tooth-iso-12-selected")));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("tooth-iso-11-selected")), findsNothing);
      expect(find.byKey(Key("tooth-iso-12-selected")), findsNothing);
    });

    testWidgets("Tapping again would deselect the selected both in single select", (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(initiallySelected: ['11'], multiSelect: false));
      expect(find.byKey(Key("tooth-iso-11-selected")), findsOneWidget);
      expect(find.byKey(Key("tooth-iso-12-selected")), findsNothing);
      await tester.tap(find.byKey(Key("tooth-iso-11-selected")));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("tooth-iso-11-selected")), findsNothing);
      expect(find.byKey(Key("tooth-iso-12-selected")), findsNothing);
    });

    testWidgets("Multi select works", (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(multiSelect: true));
      expect(find.byKey(Key("tooth-iso-11-not-selected")), findsOneWidget);
      await tester.tap(find.byKey(Key("tooth-iso-11-not-selected")));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("tooth-iso-11-not-selected")), findsNothing);
      expect(find.byKey(Key("tooth-iso-11-selected")), findsOneWidget);
      expect(selectedTeeth, ['11']);
      await tester.tap(find.byKey(Key("tooth-iso-12-not-selected")));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("tooth-iso-12-not-selected")), findsNothing);
      expect(find.byKey(Key("tooth-iso-11-selected")), findsOneWidget);
      expect(find.byKey(Key("tooth-iso-12-selected")), findsOneWidget);
      expect(selectedTeeth, ['11', '12']);
    });

    testWidgets("Primary teeth can shown", (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(showPrimary: true));
      expect(find.byKey(Key("tooth-iso-51-not-selected")), findsOneWidget);
      expect(find.byKey(Key("tooth-iso-61-not-selected")), findsOneWidget);
      expect(find.byKey(Key("tooth-iso-71-not-selected")), findsOneWidget);
      expect(find.byKey(Key("tooth-iso-81-not-selected")), findsOneWidget);
    });

    testWidgets("Primary teeth can be hidden", (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(showPrimary: false));
      expect(find.byKey(Key("tooth-iso-51-not-selected")), findsNothing);
      expect(find.byKey(Key("tooth-iso-61-not-selected")), findsNothing);
      expect(find.byKey(Key("tooth-iso-71-not-selected")), findsNothing);
      expect(find.byKey(Key("tooth-iso-81-not-selected")), findsNothing);
    });

    testWidgets("Primary teeth are not shown by default", (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(showPrimary: false));
      expect(find.byKey(Key("tooth-iso-51-not-selected")), findsNothing);
      expect(find.byKey(Key("tooth-iso-61-not-selected")), findsNothing);
      expect(find.byKey(Key("tooth-iso-71-not-selected")), findsNothing);
      expect(find.byKey(Key("tooth-iso-81-not-selected")), findsNothing);
    });

    testWidgets("Permanent teeth are shown by default", (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byKey(Key("tooth-iso-11-not-selected")), findsOneWidget);
      expect(find.byKey(Key("tooth-iso-21-not-selected")), findsOneWidget);
      expect(find.byKey(Key("tooth-iso-31-not-selected")), findsOneWidget);
      expect(find.byKey(Key("tooth-iso-41-not-selected")), findsOneWidget);
    });

    testWidgets("Permanent teeth can be shown", (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(showPermanent: true));
      expect(find.byKey(Key("tooth-iso-11-not-selected")), findsOneWidget);
      expect(find.byKey(Key("tooth-iso-21-not-selected")), findsOneWidget);
      expect(find.byKey(Key("tooth-iso-31-not-selected")), findsOneWidget);
      expect(find.byKey(Key("tooth-iso-41-not-selected")), findsOneWidget);
    });

    testWidgets("Permanent teeth can be hidden", (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(showPermanent: false));
      expect(find.byKey(Key("tooth-iso-11-not-selected")), findsNothing);
      expect(find.byKey(Key("tooth-iso-21-not-selected")), findsNothing);
      expect(find.byKey(Key("tooth-iso-31-not-selected")), findsNothing);
      expect(find.byKey(Key("tooth-iso-41-not-selected")), findsNothing);
    });

    testWidgets("Left and right strings are shown as specified", (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(leftString: "1111", rightString: "2222"));
      expect(find.text("1111"), findsOneWidget);
      expect(find.text("2222"), findsOneWidget);
    });

    testWidgets("Notation is shown", (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(notation: (isoString) => "SOME NOTATION"));
      expect(find.byTooltip("SOME NOTATION"), findsNWidgets(32));
    });
  });
}
