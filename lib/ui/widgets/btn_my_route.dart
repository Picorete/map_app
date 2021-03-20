import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/domain/bloc/map/map_bloc.dart';

class BtnMyRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapBloc = context.read<MapBloc>();

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: Icon(
            Icons.more_horiz,
            color: Colors.black87,
          ),
          onPressed: () {
            mapBloc.add(OnDrawPath());
          },
        ),
      ),
    );
  }
}
