import 'package:injector/injector.dart';
import 'package:maps_app/domain/bloc/map/map_bloc.dart';
import 'package:maps_app/domain/bloc/map_search/map_search_bloc.dart';
import 'package:maps_app/domain/bloc/ubication/ubication_bloc.dart';
import 'package:maps_app/domain/repositories/abstract_routes.dart';

class BlocRegister {
  final injector = Injector.appInstance;

  BlocRegister() {
    injector.registerSingleton<MapSearchBloc>(() {
      return MapSearchBloc();
    });
    injector.registerSingleton<UbicationBloc>(() {
      return UbicationBloc();
    });
    injector.registerSingleton<MapBloc>(() {
      return MapBloc(injector.get<AbstractRouteRepository>(),
          injector.get<MapSearchBloc>());
    });
  }
}
