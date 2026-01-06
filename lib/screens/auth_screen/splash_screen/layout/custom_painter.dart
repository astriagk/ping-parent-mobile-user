import '../../../../config.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.1529412);
    path_0.cubicTo(0, size.height * 0.07899529, 0, size.height * 0.04202235,
        size.width * 0.01748615, size.height * 0.01905043);
    path_0.cubicTo(
        size.width * 0.03497224,
        size.height * -0.003921569,
        size.width * 0.06311582,
        size.height * -0.003921569,
        size.width * 0.1194030,
        size.height * -0.003921569);
    path_0.lineTo(size.width * 0.8805970, size.height * -0.003921569);
    path_0.cubicTo(
        size.width * 0.9368836,
        size.height * -0.003921569,
        size.width * 0.9650269,
        size.height * -0.003921569,
        size.width * 0.9825134,
        size.height * 0.01905043);
    path_0.cubicTo(size.width, size.height * 0.04202235, size.width,
        size.height * 0.07899529, size.width, size.height * 0.1529412);
    path_0.lineTo(size.width, size.height * 0.8431373);
    path_0.cubicTo(
        size.width,
        size.height * 0.9170824,
        size.width,
        size.height * 0.9540549,
        size.width * 0.9825134,
        size.height * 0.9770275);
    path_0.cubicTo(size.width * 0.9650269, size.height, size.width * 0.9368836,
        size.height, size.width * 0.8805970, size.height);
    path_0.lineTo(size.width * 0.1194030, size.height);
    path_0.cubicTo(
        size.width * 0.06311582,
        size.height,
        size.width * 0.03497224,
        size.height,
        size.width * 0.01748615,
        size.height * 0.9770275);
    path_0.cubicTo(0, size.height * 0.9540549, 0, size.height * 0.9170824, 0,
        size.height * 0.8431373);
    path_0.lineTo(0, size.height * 0.1529412);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Colors.white.withValues(alpha: 1.0);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.5030179, size.height * -0.1293937);
    path_1.cubicTo(
        size.width * 0.5694478,
        size.height * -0.1278314,
        size.width * 0.6320806,
        size.height * -0.03921569,
        size.width * 0.6985194,
        size.height * -0.03921569);
    path_1.lineTo(size.width * 0.9850746, size.height * -0.03921569);
    path_1.cubicTo(
        size.width * 0.9933164,
        size.height * -0.03921569,
        size.width,
        size.height * -0.03043694,
        size.width,
        size.height * -0.01960784);
    path_1.lineTo(size.width, size.height * -0.01960784);
    path_1.cubicTo(size.width, size.height * -0.008778745,
        size.width * 0.9933164, 0, size.width * 0.9850746, 0);
    path_1.lineTo(size.width * 0.6985194, 0);
    path_1.cubicTo(
        size.width * 0.6320806,
        0,
        size.width * 0.5694478,
        size.height * 0.08861569,
        size.width * 0.5030179,
        size.height * 0.09017804);
    path_1.cubicTo(
        size.width * 0.5025104,
        size.height * 0.09019020,
        size.width * 0.5020030,
        size.height * 0.09019608,
        size.width * 0.5014925,
        size.height * 0.09019608);
    path_1.cubicTo(
        size.width * 0.5009821,
        size.height * 0.09019608,
        size.width * 0.5004746,
        size.height * 0.09019020,
        size.width * 0.4999672,
        size.height * 0.09017804);
    path_1.cubicTo(size.width * 0.4335373, size.height * 0.08861569,
        size.width * 0.3709045, 0, size.width * 0.3044657, 0);
    path_1.lineTo(size.width * 0.01492534, 0);
    path_1.cubicTo(size.width * 0.006682299, 0, 0, size.height * -0.008778745,
        0, size.height * -0.01960784);
    path_1.lineTo(0, size.height * -0.01960784);
    path_1.cubicTo(
        0,
        size.height * -0.03043694,
        size.width * 0.006682328,
        size.height * -0.03921569,
        size.width * 0.01492537,
        size.height * -0.03921569);
    path_1.lineTo(size.width * 0.3044657, size.height * -0.03921569);
    path_1.cubicTo(
        size.width * 0.3709045,
        size.height * -0.03921569,
        size.width * 0.4335373,
        size.height * -0.1278314,
        size.width * 0.4999672,
        size.height * -0.1293937);
    path_1.cubicTo(
        size.width * 0.5004746,
        size.height * -0.1294059,
        size.width * 0.5009821,
        size.height * -0.1294118,
        size.width * 0.5014925,
        size.height * -0.1294118);
    path_1.cubicTo(
        size.width * 0.5020030,
        size.height * -0.1294118,
        size.width * 0.5025104,
        size.height * -0.1294059,
        size.width * 0.5030179,
        size.height * -0.1293937);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = Color(0xffF1F1F1).withValues(alpha: 1.0);
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
