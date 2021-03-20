part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class OnMapReady extends MapEvent {}

class OnDrawPath extends MapEvent {}

class OnFollowUbication extends MapEvent {}

class OnMapsMove extends MapEvent {
  final centralPoint;

  OnMapsMove(this.centralPoint);
}

class OnCalculateLocation extends MapEvent {
  final LatLng from;
  final LatLng to;
  OnCalculateLocation(this.from, this.to);
}

class OnLocationUpdate extends MapEvent {
  final LatLng ubication;

  OnLocationUpdate(this.ubication);
}
