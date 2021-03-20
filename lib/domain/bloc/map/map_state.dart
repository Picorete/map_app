part of 'map_bloc.dart';

@immutable
class MapState {
  final bool mapReady;
  final bool drawPath;
  final bool followUbication;
  final LatLng centralPoint;
  final bool isLoading;

  // Polylines
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  MapState(
      {this.mapReady = false,
      this.drawPath = false,
      this.followUbication = false,
      this.centralPoint,
      this.isLoading = false,
      Map<String, Polyline> markers,
      Map<String, Polyline> polylines})
      : this.polylines = polylines ?? new Map(),
        this.markers = markers ?? new Map();

  MapState copyWith({
    bool mapReady,
    bool drawPath,
    bool followUbication,
    LatLng centralPoint,
    bool isLoading,
    Map<String, Polyline> polylines,
  }) =>
      MapState(
        mapReady: mapReady ?? this.mapReady,
        drawPath: drawPath ?? this.drawPath,
        polylines: polylines ?? this.polylines,
        centralPoint: centralPoint ?? this.centralPoint,
        followUbication: followUbication ?? this.followUbication,
        isLoading: isLoading ?? this.isLoading,
      );
}
