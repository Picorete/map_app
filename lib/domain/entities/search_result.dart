import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:meta/meta.dart';

class SearchResult {
  final bool cancel;
  final bool manual;
  final LatLng location;
  final String destinationName;
  final String description;

  SearchResult({
    @required this.cancel,
    this.manual,
    this.location,
    this.destinationName,
    this.description,
  });
}
