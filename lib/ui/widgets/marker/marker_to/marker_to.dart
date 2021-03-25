part of '../custom_markers.dart';

class MarkerToPainter extends CustomPainter {
  final String description;
  final int minutes;

  MarkerToPainter(this.description, this.minutes);

  @override
  void paint(Canvas canvas, Size size) {
    final double radio = 20;

    Paint paint = new Paint()..color = Colors.black;

    canvas.drawCircle(Offset(radio, size.height - radio), 20, paint);

    paint.color = Colors.white;

    canvas.drawCircle(Offset(radio, size.height - radio), 7, paint);

    final Path path = new Path();

    path.moveTo(0, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(0, 100);

    canvas.drawShadow(path, Colors.black87, 10, false);

    final whiteBox = Rect.fromLTWH(0, 20, size.width - 10, 80);

    canvas.drawRect(whiteBox, paint);

    paint.color = Colors.black;
    final blackBox = Rect.fromLTWH(0, 20, 70, 80);

    canvas.drawRect(blackBox, paint);

    // Draw texts
    TextSpan textSpan = new TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
        text: minutes.toString());

    TextPainter textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, Offset(0, 35));

    textSpan = new TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
        text: 'Min');

    textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70);

    textPainter.paint(canvas, Offset(20, 67));

    // My Location

    textSpan = new TextSpan(
        style: TextStyle(
            color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400),
        text: this.description);

    textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
        maxLines: 2,
        ellipsis: '...')
      ..layout(maxWidth: size.width - 100);

    textPainter.paint(canvas, Offset(90, 35));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
