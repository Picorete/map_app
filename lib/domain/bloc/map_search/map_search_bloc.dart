import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:maps_app/domain/entities/search_result.dart';
import 'package:meta/meta.dart';

part 'map_search_event.dart';
part 'map_search_state.dart';

class MapSearchBloc extends Bloc<MapSearchEvent, MapSearchState> {
  MapSearchBloc() : super(MapSearchState());

  @override
  Stream<MapSearchState> mapEventToState(
    MapSearchEvent event,
  ) async* {
    if (event is OnToggleCentralMarker) {
      yield state.copyWith(manualSelection: !state.manualSelection);
    } else if (event is OnAddHistory) {
      final ifExist = state.history
          .where(
              (place) => place.destinationName == event.place.destinationName)
          .length;

      if (ifExist == 0) {
        final newHistory = [...state.history, event.place];
        yield state.copyWith(history: newHistory);
      }
    }
  }
}
