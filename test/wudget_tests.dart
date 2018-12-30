import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:convert';
import 'package:tfl/tfl/api.dart';
import 'package:tfl/widgets/status_indicator.dart';

// Create a MockClient using the Mock class provided by the Mockito package.
// We will create new instances of this class in each test.
class MockApi extends Mock implements TflApi {}

void main() {
  setUp(() async {});

  loadFixture(filename) {
    var filePath =
        dirname(Platform.script.path.replaceFirst('/', '')) + '/' + filename;

    return jsonDecode(new File(filePath).readAsStringSync());
  }

  testWidgets('Get good line status', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // mock the API
      final mockApi = MockApi();

      var response = loadFixture('test/fixtures/line_status_good_service.json');

      when(mockApi.getLineStatus(['district']))
          .thenAnswer((_) async => response);

      // test the widget
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: ListView(
        children: <Widget>[
          StatusIndicator(['district'], api: mockApi)
        ],
      ))));

      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('Good Service'), findsOneWidget);
    });
  });
}
