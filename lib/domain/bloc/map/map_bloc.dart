import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Colors, Offset;
import 'package:maps_app/domain/bloc/map_search/map_search_bloc.dart';
import 'package:maps_app/domain/entities/place.dart';
import 'package:maps_app/domain/repositories/abstract_routes.dart';
import 'package:maps_app/helpers/helpers.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/themes/map.dart';
import 'package:polyline/polyline.dart' as Poly;

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final AbstractRouteRepository _routeRepository;
  final MapSearchBloc _mapSearchBloc;

  MapBloc(this._routeRepository, @required this._mapSearchBloc)
      : super(MapState());

  // Map Controller
  GoogleMapController _mapController;

  // Polylines
  Polyline _myRoute = new Polyline(
    polylineId: PolylineId('my_route'),
    width: 4,
    color: Colors.transparent,
  );

  Polyline _myDestinationRoute = new Polyline(
    polylineId: PolylineId('my_destination_route'),
    width: 4,
    color: Colors.black87,
  );

  void initMap(GoogleMapController controller) {
    if (!state.mapReady) {
      this._mapController = controller;
      this._mapController.setMapStyle(jsonEncode(mapTheme));

      add(OnMapReady());
    }
  }

  void moveCamera(LatLng destination) {
    final cameraUpdate = CameraUpdate.newCameraPosition(
        CameraPosition(target: destination, zoom: 15));
    this._mapController?.animateCamera(
          cameraUpdate,
        );
  }

  @override
  Stream<MapState> mapEventToState(
    MapEvent event,
  ) async* {
    if (event is OnMapReady) {
      yield state.copyWith(mapReady: true);
    } else if (event is OnLocationUpdate) {
      yield* this._onLocationUpdate(event);
    } else if (event is OnDrawPath) {
      yield* this._onDrawPath(event);
    } else if (event is OnFollowUbication) {
      yield* this._onFollowUbication(event);
    } else if (event is OnMapsMove) {
      yield state.copyWith(centralPoint: event.centralPoint);
    } else if (event is OnCalculateLocation) {
      yield state.copyWith(isLoading: true);
      yield* this._onCalculateLocation(event);
    }
  }

  // Methods
  Stream<MapState> _onLocationUpdate(OnLocationUpdate event) async* {
    if (state.followUbication) {
      this.moveCamera(event.ubication);
    }

    List<LatLng> points = [...this._myRoute.points, event.ubication];
    this._myRoute = this._myRoute.copyWith(pointsParam: points);

    final currentPolylines = state.polylines;
    currentPolylines['my_route'] = this._myRoute;

    yield state.copyWith(polylines: currentPolylines);
  }

  Stream<MapState> _onDrawPath(OnDrawPath event) async* {
    if (!state.drawPath) {
      this._myRoute = this._myRoute.copyWith(colorParam: Colors.black87);
    } else {
      this._myRoute = this._myRoute.copyWith(colorParam: Colors.transparent);
    }

    final currentPolylines = state.polylines;
    currentPolylines['my_route'] = this._myRoute;

    yield state.copyWith(
      polylines: currentPolylines,
      drawPath: !state.drawPath,
    );
  }

  Stream<MapState> _onFollowUbication(OnFollowUbication event) async* {
    if (!state.followUbication) {
      this.moveCamera(this._myRoute.points[this._myRoute.points.length - 1]);
    }

    yield state.copyWith(followUbication: !state.followUbication);
  }

  Stream<MapState> _onCalculateLocation(OnCalculateLocation event) async* {
    final routeResponse =
        await _routeRepository.getRouteFromTo(from: event.from, to: event.to);

    // Polylines
    final polylines = this._getPolylines(routeResponse.routes[0].geometry);

    // Markers
    final placeInfo = await this._routeRepository.getInfoOfPlace(event.to);
    final toPlaceName = placeInfo.features[0].placeName;

    final markers = await this._getFromToMarkers(
        from: new Place(location: event.from),
        to: new Place(location: event.to, name: toPlaceName),
        duration: routeResponse.routes[0].duration,
        distance: routeResponse.routes[0].distance);

    if (this._mapSearchBloc.state.manualSelection) {
      this._mapSearchBloc.add(OnToggleCentralMarker());
    }
    this.moveCamera(event.to);

    yield state.copyWith(
      polylines: polylines,
      markers: markers,
      isLoading: false,
    );
  }

  Map<String, Polyline> _getPolylines(String geometry) {
    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
        .decodedCoords;
    final routePoints =
        points.map((point) => LatLng(point[0], point[1])).toList();

    this._myDestinationRoute = this._myDestinationRoute.copyWith(
          pointsParam: routePoints,
        );
    final currentPolylines = state.polylines;
    currentPolylines['my_destination_route'] = this._myDestinationRoute;

    return currentPolylines;
  }

  Future<Map<String, Marker>> _getFromToMarkers(
      {Place from, Place to, double duration, double distance}) async {
    final fromIcon = await getMarkerFromIcon(distance);
    final toIcon = await getMarkerToIcon(duration, to.name);

    final fromMarker = Marker(
        anchor: Offset(0.0, 1.0),
        markerId: MarkerId('fromMarker'),
        position: from.location,
        icon: fromIcon,
        infoWindow: InfoWindow(
            title: 'Mi casa', snippet: 'Esta es el punto inicial de mi casa'));
    final toMarker = Marker(
        anchor: Offset(0.0, 1.0),
        markerId: MarkerId('toMarker'),
        position: to.location,
        icon: toIcon,
        infoWindow: InfoWindow(
            title: to.name,
            snippet: 'Time to arrive: ${(duration / 60).floor()} minutes'));

    final markers = {...state.markers};
    markers['fromMarker'] = fromMarker;
    markers['toMarker'] = toMarker;

    return markers;
  }
}
