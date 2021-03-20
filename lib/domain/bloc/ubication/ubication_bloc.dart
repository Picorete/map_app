import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'ubication_event.dart';
part 'ubication_state.dart';

class UbicationBloc extends Bloc<UbicationEvent, UbicationState> {
  UbicationBloc() : super(UbicationState());

  StreamSubscription<Position> _positionSuscription;

  void initFollowing() {
    this._positionSuscription = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.high, distanceFilter: 10)
        .listen((Position position) {
      final newLocation = new LatLng(position.latitude, position.longitude);
      add(OnUbicationChange(newLocation));
    });
  }

  void cancelFollowing() {
    this._positionSuscription?.cancel();
  }

  @override
  Stream<UbicationState> mapEventToState(
    UbicationEvent event,
  ) async* {
    if (event is OnUbicationChange) {
      yield state.copyWith(existUbication: true, ubication: event.ubication);
    }
  }
}
