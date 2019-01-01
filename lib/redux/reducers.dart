import 'package:tfl/models/app_state.dart';
import 'actions.dart';

AppState appReducers(AppState state, dynamic action) {
  if (action is SetHomeStation) {
    return AppState(
        homeStation: action.homeStation,
        previousHomeStation: state.homeStation);
  }

  if (action is UndoHomeStation) {
    return AppState(
        homeStation: state.previousHomeStation, previousHomeStation: null);
  }

  return state;
}
