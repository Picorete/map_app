import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/domain/bloc/map/map_bloc.dart';
import 'package:maps_app/domain/bloc/ubication/ubication_bloc.dart';

class BtnUbication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapBloc = context.read<MapBloc>();
    final ubicationBloc = context.read<UbicationBloc>();

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: Icon(
            Icons.my_location,
            color: Colors.black87,
          ),
          onPressed: () {
            final newDestination = ubicationBloc.state.ubication;
            mapBloc.moveCamera(newDestination);
          },
        ),
      ),
    );
  }
}
