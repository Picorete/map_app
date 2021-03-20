import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:maps_app/domain/bloc/map/map_bloc.dart';
import 'package:maps_app/domain/bloc/map_search/map_search_bloc.dart';
import 'package:maps_app/domain/bloc/ubication/ubication_bloc.dart';
import 'package:maps_app/domain/entities/search_result.dart';
import 'package:maps_app/ui/widgets/search/search_destination.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return FadeInDown(
      duration: Duration(milliseconds: 300),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          width: width,
          child: GestureDetector(
            onTap: () async {
              final proximity = context.read<UbicationBloc>().state.ubication;
              final history = context.read<MapSearchBloc>().state.history;

              SearchResult result = await showSearch(
                  context: context,
                  delegate: SearchDestination(proximity, history));
              this.returnSearch(context, result);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              width: double.infinity,
              child: Text(
                'Where do you wanna go?',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 5),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  void returnSearch(BuildContext context, SearchResult result) {
    if (result.cancel) return;

    if (result.manual) {
      context.read<MapSearchBloc>().add(OnToggleCentralMarker());
      return;
    }

    context.read<MapBloc>().add(OnCalculateLocation(
        context.read<UbicationBloc>().state.ubication, result.location));
    context.read<MapSearchBloc>().add(OnAddHistory(result));
  }
}
