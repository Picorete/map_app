import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:maps_app/data/models/places_response.dart';
import 'package:maps_app/data/models/reverse_query_response.dart';
import 'package:maps_app/data/models/route_response.dart';

abstract class AbstractRouteRepository {
  final StreamController<PlacesResponse> _placesStreamController =
      new StreamController<PlacesResponse>.broadcast();

  Stream<PlacesResponse> get placesStream =>
      this._placesStreamController.stream;

  Future<RouteResponse> getRouteFromTo({LatLng from, LatLng to});
  void getPlacesByQueryDeBouncer({String query, LatLng proximity});
  Future<ReverseQueryResponse> getInfoOfPlace(LatLng coords);

  void dispose() {
    this._placesStreamController.close();
  }
}
