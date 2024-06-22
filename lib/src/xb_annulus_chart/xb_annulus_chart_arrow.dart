import 'package:flutter/material.dart';

class XBAnnulusChartArrow extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  const XBAnnulusChartArrow(
      {this.width = 10, this.height = 5, this.color = Colors.black, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height), //指定画布大小
      painter: XBAnnulusChartArrowPainter(color: color),
    );
  }
}

class XBAnnulusChartArrowPainter extends CustomPainter {
  final Color? color;
  const XBAnnulusChartArrowPainter({this.color});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color ?? Colors.black
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(size.width / 2, size.height); //顶点
    path.lineTo(0, 0); //左下角
    path.lineTo(size.width, 0); //右下角
    path.close(); //闭合路径以形成一个三角形

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
