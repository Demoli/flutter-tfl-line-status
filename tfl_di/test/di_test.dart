import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tfl/tfl/api.dart';
import 'package:tfl_di/tfl_di.dart';

void main() {
  Injector injector;

  setUp(() {
    configureInjector();
    injector = Injector.getInjector();
  });

  test('DI Mappings', () {
    var actual = injector.get<TflApi>();
    expect((actual is TflApi), true, reason: 'DI does not return a valid TflApi instance');
  });
}
