part of 'map_search_bloc.dart';

@immutable
class MapSearchState {
  final bool manualSelection;
  final List<SearchResult> history;
  MapSearchState({this.manualSelection = false, List<SearchResult> history})
      : this.history = (history == null) ? [] : history;

  copyWith({bool manualSelection, List<SearchResult> history}) =>
      MapSearchState(
          manualSelection: manualSelection ?? this.manualSelection,
          history: history ?? this.history);
}
