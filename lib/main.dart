import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:maps_app/domain/bloc/map/map_bloc.dart';
import 'package:maps_app/domain/bloc/map_search/map_search_bloc.dart';
import 'package:maps_app/domain/bloc/ubication/ubication_bloc.dart';
import 'package:maps_app/ui/pages/access_gps_page.dart';
import 'package:maps_app/ui/pages/loading_page.dart';
import 'package:maps_app/ui/pages/map_page.dart';

import 'package:maps_app/di/bloc_register.dart';
import 'di/repositories_register.dart';

void main() {
  RepositoriesRegister();
  BlocRegister();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: Injector.appInstance.get<UbicationBloc>()),
          BlocProvider.value(value: Injector.appInstance.get<MapBloc>()),
          BlocProvider.value(value: Injector.appInstance.get<MapSearchBloc>()),
        ],
        child: MaterialApp(
          title: 'Material App',
          debugShowCheckedModeBanner: false,
          home: LoadingPage(),
          routes: {
            'map': (_) => MapPage(),
            'loading': (_) => LoadingPage(),
            'access': (_) => AccessGpsPage(),
          },
        ));
  }
}
