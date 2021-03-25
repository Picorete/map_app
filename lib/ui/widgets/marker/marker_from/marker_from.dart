part of '../custom_markers.dart';

class MarkerFromPainter extends CustomPainter {
  int distance;

  MarkerFromPainter(this.distance);

  @override
  void paint(Canvas canvas, Size size) {
    final double radio = 20;

    Paint paint = new Paint()..color = Colors.black;

    canvas.drawCircle(Offset(radio, size.height - radio), 20, paint);

    paint.color = Colors.white;

    canvas.drawCircle(Offset(radio, size.height - radio), 7, paint);

    final Path path = new Path();

    path.moveTo(40, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(40, 100);

    canvas.drawShadow(path, Colors.black87, 10, false);

    final whiteBox = Rect.fromLTWH(40, 20, size.width - 55, 80);

    canvas.drawRect(whiteBox, paint);

    paint.color = Colors.black;
    final blackBox = Rect.fromLTWH(40, 20, 70, 80);

    canvas.drawRect(blackBox, paint);

    // Draw texts
    TextSpan textSpan = new TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
        text: distance.toString());

    TextPainter textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, Offset(40, 35));

    textSpan = new TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
        text: 'Km');

    textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, Offset(40, 67));

    // My Location

    textSpan = new TextSpan(
        style: TextStyle(
            color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400),
        text: 'My location');

    textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: size.width - 130);

    textPainter.paint(canvas, Offset(170, 50));
  }

  @override
  bool shouldRepaint(MarkerFromPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(MarkerFromPainter oldDelegate) => false;
}
