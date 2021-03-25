import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:meta/meta.dart';

class Place {
  final LatLng location;
  final String name;

  Place({
    @required this.location,
    this.name,
  });
}
