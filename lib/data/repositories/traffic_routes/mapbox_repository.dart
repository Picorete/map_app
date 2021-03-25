import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:maps_app/data/models/places_response.dart';
import 'package:maps_app/data/models/reverse_query_response.dart';
import 'package:maps_app/data/models/route_response.dart';
import 'package:maps_app/domain/repositories/abstract_routes.dart';
import 'package:maps_app/helpers/debouncer.dart';

class MapBoxRepository extends AbstractRouteRepository {
  final _dio = new Dio();
  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400));

  @override
  final StreamController<PlacesResponse> _placesStreamController =
      new StreamController<PlacesResponse>.broadcast();

  @override
  Stream<PlacesResponse> get placesStream =>
      this._placesStreamController.stream;

  final _urlDir = 'https://api.mapbox.com/directions/v5';
  final _urlPlaces = 'https://api.mapbox.com/geocoding/v5';
  final _apiKey =
      'pk.eyJ1IjoicGljb3JldGUiLCJhIjoiY2s4enRjdzh0MXd4bjNocXMxamo1ZnRibiJ9.nRALIvItrs4f8NmDLWelwA';

  @override
  Future<RouteResponse> getRouteFromTo({LatLng from, LatLng to}) async {
    final coordString =
        '${from.longitude},${from.latitude};${to.longitude},${to.latitude}';
    final url = '${this._urlDir}/mapbox/driving/$coordString';

    final resp = await this._dio.get(url, queryParameters: {
      'alternatives': true,
      'geometries': 'polyline6',
      'steps': false,
      'access_token': _apiKey,
      'language': 'es'
    });

    final data = RouteResponse.fromJson(resp.data);
    return data;
  }

  @override
  Future<void> getPlacesByQueryDeBouncer(
      {String query, LatLng proximity}) async {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results =
          await this.getPlacesByQuery(query: value, proximity: proximity);
      this._placesStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      debouncer.value = query;
    });

    Future.delayed(Duration(milliseconds: 201)).then((_) => timer.cancel());
  }

  @override
  Future<ReverseQueryResponse> getInfoOfPlace(LatLng coords) async {
    final url =
        '${this._urlPlaces}/mapbox.places/${coords.longitude},${coords.latitude}.json';

    final resp = await this
        ._dio
        .get(url, queryParameters: {'access_token': _apiKey, 'language': 'es'});

    final data = reverseQueryResponseFromJson(resp.data);

    return data;
  }

  Future<PlacesResponse> getPlacesByQuery(
      {String query, LatLng proximity}) async {
    try {
      final url = '${this._urlPlaces}/mapbox.places/$query.json';
      final resp = await this._dio.get(url, queryParameters: {
        'autocomplete': true,
        'proximity': '${proximity.longitude},${proximity.latitude}',
        'access_token': _apiKey,
        'language': 'es'
      });
      final placesResponse = placesResponseFromJson(resp.data);

      return placesResponse;
    } catch (e) {
      return PlacesResponse(features: []);
    }
  }
}
