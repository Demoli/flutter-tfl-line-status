import 'package:tfl/models/app_state.dart';
import 'actions.dart';

AppState appReducers(AppState state, dynamic action) {
  if (action is SetHomeStation) {
    return state.copyWith(
        homeStation: action.homeStation,
        previousHomeStation: state.homeStation);
  }

  if (action is UndoHomeStation) {
    return state.copyWith(
        homeStation: state.previousHomeStation, previousHomeStation: null);
  }

  if (action is ToggleFavourite) {
    final currentFavourites = state.favourites;
    final existingIndex = currentFavourites.indexWhere((test) {
      return test['id'] == action.station['id'];
    });

    if (existingIndex == -1) {
      currentFavourites.add(action.station);
    } else {
      currentFavourites.removeAt(existingIndex);
    }

    return state.copyWith(favourites: currentFavourites);
  }

  return state;
}
