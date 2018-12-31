import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:convert';
import 'package:tfl/tfl/api.dart';
import 'package:tfl/widgets/nearest_station.dart';
import 'package:tfl/widgets/status_indicator.dart';
import 'package:tfl_di/tfl_di.dart';

// Create a MockClient using the Mock class provided by the Mockito package.
// We will create new instances of this class in each test.
class MockApi extends Mock implements TflApi {}

class MockGeoLocator extends Mock implements Geolocator {}

class MockPosition extends Mock implements Position {
  final double longitude;

  final double latitude;

  MockPosition(this.longitude, this.latitude);
}

void main() {

  configureInjector();

  setUp(() async {
  });

  loadFixture(filename) {
    var filePath =
        dirname(Platform.script.path.replaceFirst('/', '')) + '/' + filename;

    return jsonDecode(new File(filePath).readAsStringSync());
  }

  group('Status Indicator', () {
    testWidgets('Good service', (WidgetTester tester) async {
      await tester.runAsync(() async {
        // mock the API
        final mockApi = MockApi();

        var response =
            loadFixture('test/fixtures/line_status_good_service.json');

        when(mockApi.getLineStatus(['district']))
            .thenAnswer((_) async => response);

        // test the widget
        await tester.pumpWidget(MaterialApp(
            home: Scaffold(
                body: ListView(
          children: <Widget>[
            // TODO Use DI
            StatusIndicator(['district'], api: mockApi)
          ],
        ))));

        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.check), findsOneWidget);
        expect(find.text('Good Service'), findsOneWidget);
      });
    });

    testWidgets('Delays', (WidgetTester tester) async {
      await tester.runAsync(() async {
        // mock the API
        final mockApi = MockApi();

        var response =
            loadFixture('test/fixtures/line_status_minor_delays.json');

        when(mockApi.getLineStatus(['district']))
            .thenAnswer((_) async => response);

        // test the widget
        await tester.pumpWidget(MaterialApp(
            home: Scaffold(
                body: ListView(
          children: <Widget>[
            // TODO Use DI
            StatusIndicator(['district'], api: mockApi)
          ],
        ))));

        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.warning), findsOneWidget);
        expect(find.text('Signal failure'), findsOneWidget);
      });
    });
  });

  group('Station Details', () {
    testWidgets('Nearest', (WidgetTester tester) async {
      await tester.runAsync(() async {
        final mockApi = new MockApi();

        var response = loadFixture('test/fixtures/nearest_station.json');

        when(mockApi.getStopPointsByLocation(any, any))
            .thenAnswer((_) async => response['stopPoints']);

        final mockGeoLocator = new MockGeoLocator();

        Position mockPosition = MockPosition(-0.199282, 51.450905);

        when(mockGeoLocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high))
            .thenAnswer((_) async => mockPosition);

        // test the widget
        await tester.pumpWidget(MaterialApp(
            home: Scaffold(
                body: ListView(
          children: <Widget>[
            NearestStation(mockApi, mockGeoLocator)
          ],
        ))));

        await tester.pumpAndSettle();
        expect(find.text("Earl's Court Underground Station"), findsWidgets);
      });
    });
  });
}
