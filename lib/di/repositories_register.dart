import 'package:injector/injector.dart';
import 'package:maps_app/data/repositories/traffic_routes/mapbox_repository.dart';
import 'package:maps_app/domain/repositories/abstract_routes.dart';

class RepositoriesRegister {
  final injector = Injector.appInstance;

  RepositoriesRegister() {
    injector.registerDependency<AbstractRouteRepository>(() {
      return MapBoxRepository();
    });
  }
}
