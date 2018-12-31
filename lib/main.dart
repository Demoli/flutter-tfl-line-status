import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tfl/models/app_state.dart';
import 'package:tfl/screens/home_screen.dart';
import 'package:tfl_di/tfl_di.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:tfl/redux/reducers.dart';

void main() async {
  configureInjector();

  // Create Persistor
  final persistor = Persistor<AppState>(
    storage: FlutterStorage(),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
  );

  // Load initial state
  final initialState = await persistor.load();

  final store = new Store<AppState>(
    appReducers,
    initialState: initialState ?? new AppState(),
    middleware: [persistor.createMiddleware()],
  );

  runApp(ReduxApp(store));
}

class ReduxApp extends StatelessWidget {
  final Store<AppState> store;

  ReduxApp(this.store);

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
      store: store,
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TFL Line Status',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
//        '/nearest': (context) => NearestStationScreen(),
//        '/search': (context) => StationSearch(),
//        '/sandbox': (context) => SandboxScreen()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
