import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps_app/domain/bloc/map/map_bloc.dart';
import 'package:maps_app/domain/bloc/map_search/map_search_bloc.dart';
import 'package:maps_app/domain/bloc/ubication/ubication_bloc.dart';
import 'package:maps_app/ui/widgets/btn_follow_ubication.dart';
import 'package:maps_app/ui/widgets/btn_location.dart';
import 'package:maps_app/ui/widgets/btn_my_route.dart';
import 'package:maps_app/ui/widgets/map_central_marker.dart';
import 'package:maps_app/ui/widgets/search/searchbar.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    context.read<UbicationBloc>().initFollowing();
    super.initState();
  }

  @override
  void dispose() {
    context.read<UbicationBloc>().cancelFollowing();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<UbicationBloc, UbicationState>(
            builder: (BuildContext context, state) => createMap(state),
          ),
          BlocBuilder<MapSearchBloc, MapSearchState>(
            builder: (context, state) {
              if (state.manualSelection) {
                return CentralMarker();
              } else {
                return Positioned(
                  top: 15,
                  child: SearchBar(),
                );
              }
            },
          ),
          BlocBuilder<MapBloc, MapState>(
            builder: (context, state) {
              if (state.isLoading) {
                return Container(
                  height: height,
                  color: Colors.black26,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
      floatingActionButton: BlocBuilder<MapBloc, MapState>(
        builder: (_, state) {
          List<Widget> buttonList = (state.isLoading)
              ? []
              : [BtnUbication(), BtnFollowUbication(), BtnMyRoute()];
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: buttonList,
          );
        },
      ),
    );
  }

  Widget createMap(UbicationState state) {
    if (!state.existUbication) return Center(child: Text('Locating...'));

    final mapBloc = BlocProvider.of<MapBloc>(context);

    mapBloc.add(OnLocationUpdate(state.ubication));

    final cameraPosition = new CameraPosition(
      target: state.ubication,
      zoom: 15,
    );
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return GoogleMap(
          initialCameraPosition: cameraPosition,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: mapBloc.initMap,
          polylines: mapBloc.state.polylines.values.toSet(),
          onCameraMove: (cameraPosition) {
            mapBloc.add(OnMapsMove(cameraPosition.target));
          },
        );
      },
    );
  }
}
