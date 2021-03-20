import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/domain/bloc/map/map_bloc.dart';
import 'package:maps_app/domain/bloc/map_search/map_search_bloc.dart';
import 'package:maps_app/domain/bloc/ubication/ubication_bloc.dart';

class CentralMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Positioned(
            top: 70,
            left: 20,
            child: FadeInLeft(
              duration: Duration(milliseconds: 150),
              child: CircleAvatar(
                maxRadius: 25,
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    context.read<MapSearchBloc>().add(OnToggleCentralMarker());
                  },
                ),
              ),
            )),
        Center(
          child: Transform.translate(
            offset: Offset(0, -15),
            child: BounceInDown(
              child: Icon(
                Icons.location_on,
                size: 50,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 70,
          left: 40,
          child: FadeIn(
            child: MaterialButton(
              minWidth: width - 120,
              child: Text('Confirm location',
                  style: TextStyle(color: Colors.white)),
              color: Colors.black,
              shape: StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              onPressed: () {
                context.read<MapBloc>().add(OnCalculateLocation(
                      context.read<UbicationBloc>().state.ubication,
                      context.read<MapBloc>().state.centralPoint,
                    ));
              },
            ),
          ),
        ),
      ],
    );
  }
}
