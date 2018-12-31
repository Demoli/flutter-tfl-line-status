import 'package:tfl/models/app_state.dart';
import 'actions.dart';

AppState appReducers(AppState state, dynamic action) {
  if(action is SetHomeStation) {
    return AppState(homeStation: action.homeStation);
  }

  return state;
}
