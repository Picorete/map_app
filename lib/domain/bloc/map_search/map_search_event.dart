part of 'map_search_bloc.dart';

@immutable
abstract class MapSearchEvent {}

class OnToggleCentralMarker extends MapSearchEvent {}

class OnAddHistory extends MapSearchEvent {
  final SearchResult place;

  OnAddHistory(this.place);
}
