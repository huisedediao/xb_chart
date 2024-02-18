import 'dart:math';

import 'package:flutter/material.dart';

import 'xb_annulus_chart_config.dart';
import 'xb_annulus_chart_model.dart';

class XBAnnulusChartData extends StatefulWidget {
  final double width;
  final double height;

  /// 环形的宽度
  final double strokeWidth;

  /// 选中时，突出的距离
  final double selectedDistance;

  /// 数据源
  final List<XBAnnulusChartModel> models;

  /// 选中和未选中的回调
  final XBAnnulusOnSelected onSelected;

  const XBAnnulusChartData(
      {required this.models,
      required this.width,
      required this.height,
      this.strokeWidth = 40,
      this.selectedDistance = 10,
      required this.onSelected,
      super.key});

  @override
  State<XBAnnulusChartData> createState() => _XBAnnulusChartDataState();
}

class _XBAnnulusChartDataState extends State<XBAnnulusChartData> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        _handleTap(details.localPosition);
      },
      child: Container(
        // color: Colors.blue.withAlpha(10),
        child: CustomPaint(
          size: Size(widget.width, widget.height),
          painter: XBAnnulusChartPainter(
              models: widget.models,
              strokeWidth: widget.strokeWidth,
              selectedDistance: widget.selectedDistance),
        ),
      ),
    );
  }

  void _handleTap(Offset localPosition) {
    final center = Offset(widget.width / 2, widget.height / 2);
    final touchAngle =
        atan2(localPosition.dy - center.dy, localPosition.dx - center.dx);

    double startAngle = -pi / 2;
    double totalValue =
        widget.models.fold(0, (prev, element) => prev + element.value);

    XBAnnulusChartModel? selectedModel;
    Offset centerOffset = Offset.zero;

    for (var model in widget.models) {
      final sweepAngle = 2 * pi * (model.value / totalValue);
      // calculate the mid angle of the current sector
      double midAngle = startAngle + sweepAngle / 2;
      // calculate the center point of the current sector
      double centerX = (widget.width / 2) +
          (widget.width / 2 - widget.strokeWidth / 2) * cos(midAngle);
      double centerY = (widget.height / 2) +
          (widget.height / 2 - widget.strokeWidth / 2) * sin(midAngle);
      // print(
      //     "model.value:${model.value},startAngle:$startAngle,sweepAngle:$sweepAngle,startAngle + sweepAngle:${startAngle + sweepAngle},touchAngle:$touchAngle");
      if (touchAngle >= startAngle && touchAngle <= (startAngle + sweepAngle) ||
          ((startAngle + sweepAngle > pi) &&
              touchAngle > -pi &&
              touchAngle <= (-pi + startAngle + sweepAngle - pi))) {
        setState(() {
          model.isSelected = !model.isSelected;
          if (model.isSelected) {
            selectedModel = model;
            centerOffset = Offset(centerX, centerY);
          }
        });
      } else {
        model.isSelected = false;
      }
      startAngle += sweepAngle;
      if (startAngle > pi) {
        startAngle = -pi + startAngle - pi;
      }
    }

    widget.onSelected(selectedModel, centerOffset);
  }
}

class XBAnnulusChartPainter extends CustomPainter {
  final List<XBAnnulusChartModel> models;
  final double strokeWidth;
  final double selectedDistance;

  XBAnnulusChartPainter(
      {required this.models,
      required this.strokeWidth,
      required this.selectedDistance});

  @override
  void paint(Canvas canvas, Size size) {
    double startAngle = -pi / 2;
    double totalValue = models.fold(0, (prev, element) => prev + element.value);

    for (var model in models) {
      final sweepAngle = 2 * pi * (model.value / totalValue);
      final paint = Paint()
        ..color = model.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      double dx = 0, dy = 0;
      if (model.isSelected) {
        double midAngle = startAngle + sweepAngle / 2;
        dx = selectedDistance * cos(midAngle);
        dy = selectedDistance * sin(midAngle);
      }

      double fixDistance = selectedDistance * 2;

      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width / 2 + dx, size.height / 2 + dy),
          width: size.width - strokeWidth - fixDistance,
          height: size.height - strokeWidth - fixDistance,
        ),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
