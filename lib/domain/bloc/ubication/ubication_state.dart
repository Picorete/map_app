part of 'ubication_bloc.dart';

@immutable
class UbicationState {
  final bool following;
  final bool existUbication;
  final LatLng ubication;

  UbicationState({
    this.following = true,
    this.existUbication = false,
    this.ubication,
  });

  UbicationState copyWith(
          {bool following, bool existUbication, LatLng ubication}) =>
      new UbicationState(
          following: following ?? this.following,
          existUbication: existUbication ?? this.existUbication,
          ubication: ubication ?? this.ubication);
}
