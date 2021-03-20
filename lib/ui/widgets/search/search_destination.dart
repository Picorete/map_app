import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:maps_app/data/models/places_response.dart';
import 'package:maps_app/domain/entities/search_result.dart';
import 'package:maps_app/domain/repositories/abstract_routes.dart';
import 'package:injector/injector.dart';

class SearchDestination extends SearchDelegate<SearchResult> {
  @override
  final String searchFieldLabel;
  final AbstractRouteRepository _routeRepository;
  final LatLng proximity;
  final List<SearchResult> history;
  SearchDestination(this.proximity, this.history)
      : this.searchFieldLabel = 'Search...',
        this._routeRepository =
            Injector.appInstance.get<AbstractRouteRepository>();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => this.query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () => this.close(context, SearchResult(cancel: true)),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return this._buildSuggetsResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (this.query.length == 0) {
      return ListView(
        children: [
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Select manual location'),
            onTap: () {
              this.close(context, SearchResult(cancel: false, manual: true));
            },
          ),
          ...this
              .history
              .map((place) => ListTile(
                    leading: Icon(Icons.history),
                    title: Text(place.destinationName),
                    subtitle: Text(place.description),
                    onTap: () {
                      this.close(context, place);
                    },
                  ))
              .toList()
              .reversed
        ],
      );
    }

    return this._buildSuggetsResults();
  }

  Widget _buildSuggetsResults() {
    this._routeRepository.getPlacesByQueryDeBouncer(
        query: this.query.trim(), proximity: this.proximity);

    return StreamBuilder(
      stream: this._routeRepository.placesStream,
      builder: (BuildContext context, AsyncSnapshot<PlacesResponse> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final places = snapshot.data.features;

        return ListView.separated(
            itemBuilder: (_, i) {
              final place = places[i];

              return ListTile(
                leading: Icon(Icons.place),
                title: Text(place.textEs),
                subtitle: Text(place.placeNameEs),
                onTap: () {
                  this.close(
                      context,
                      SearchResult(
                        cancel: false,
                        manual: false,
                        location: LatLng(place.center[1], place.center[0]),
                        destinationName: place.textEs,
                        description: place.placeNameEs,
                      ));
                },
              );
            },
            separatorBuilder: (_, i) => Divider(),
            itemCount: places.length);
      },
    );
  }
}
