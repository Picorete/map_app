import 'package:flutter/material.dart';

import 'custom_markers.dart';

class Marker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          height: 150,
          color: Colors.red,
          child: CustomPaint(
            // painter: MarkerFromPainter(250),
            painter: MarkerToPainter(
                'Mi casa por algun lado del munod esta aqui, bien pinche largo',
                12),
          ),
        ),
      ),
    );
  }
}
