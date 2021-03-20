import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:maps_app/helpers/helpers.dart';
import 'package:maps_app/ui/pages/access_gps_page.dart';
import 'package:maps_app/ui/pages/map_page.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (await Geolocator.isLocationServiceEnabled()) {
        Navigator.pushReplacementNamed(context, 'map');
      }
    }

    // super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: this.checkGpsAndLocation(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Center(child: Text(snapshot.data));
          } else {
            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 2,
            ));
          }
        },
      ),
    );
  }

  Future checkGpsAndLocation(BuildContext context) async {
    // PermisoGPS
    final permissonsGps = await Permission.location.isGranted;
    // GPS esta activo
    final gpsIsActive = await Geolocator.isLocationServiceEnabled();

    if (permissonsGps && gpsIsActive) {
      Navigator.pushReplacement(context, navigateFadeIn(context, MapPage()));
      return '';
    } else if (!permissonsGps) {
      Navigator.pushReplacement(
          context, navigateFadeIn(context, AccessGpsPage()));
      // return 'We need permissons of location';
    } else {
      return 'You need active the gps';
    }
    // Navigator.pushReplacement(
    // context, navigateFadeIn(context, AccessGpsPage()));
    // Navigator.pushReplacement(context, navigateFadeIn(context, MapPage()));
  }
}
