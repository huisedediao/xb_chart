// ignore_for_file: avoid_unnecessary_containers

import 'dart:math';
import 'package:flutter/material.dart';
import 'xb_line_chart_config.dart';
import 'xb_line_chart_model.dart';
import 'xb_line_chart_x_title.dart';

class XBLineChartData extends StatefulWidget {
  final int leftTitleCount;
  final List<XBLineChartXTitle> xTitles;
  final List<XBLineChartModel> models;
  final int valueRangeMax;
  final int valueRangeMin;
  final int valueLineCount;
  final double painterWidth;
  final double painterHeight;
  final XBLineChartOnHover onHover;
  final double dayGap;
  final double datasExtensionSpace;
  final int fractionDigits;
  final Color touchLineColor;
  final double lineWidth;
  final double circleRadius;
  final double valueFontSize;
  final FontWeight valueFontWeight;
  const XBLineChartData(
      {required this.leftTitleCount,
      required this.xTitles,
      required this.models,
      required this.valueRangeMax,
      required this.valueRangeMin,
      required this.painterWidth,
      required this.painterHeight,
      required this.valueLineCount,
      required this.onHover,
      required this.dayGap,
      required this.datasExtensionSpace,
      required this.fractionDigits,
      required this.touchLineColor,
      required this.lineWidth,
      required this.circleRadius,
      required this.valueFontSize,
      required this.valueFontWeight,
      super.key});

  @override
  State<XBLineChartData> createState() => XBLineChartDataState();
}

String _indexKey = 'index';
String _nearestXKey = 'nearestX';

class XBLineChartDataState extends State<XBLineChartData> {
  double? _touchX;

  Map<String, dynamic> _findModelIndex(double? touchX) {
    if (touchX == null) {
      return {
        _indexKey: null,
        _nearestXKey: null,
      };
    }
    int nearestIndex = 0;
    double nearestDistance = 0;
    double nearestX = 0;
    for (int i = 0; i < xbLineChartMaxValueCount(widget.models); i++) {
      double x = i * widget.dayGap + widget.datasExtensionSpace;
      if (nearestDistance == 0) {
        nearestDistance = (x - touchX).abs();
        nearestIndex = i;
        nearestX = x;
      } else {
        double tempDistance = (x - touchX).abs();
        if (tempDistance < nearestDistance) {
          nearestDistance = tempDistance;
          nearestIndex = i;
          nearestX = x;
        }
      }
    }
    return {
      _indexKey: nearestIndex,
      _nearestXKey: nearestX,
    };
  }

  Offset? _localPosition;

  void hideHover() {
    setState(() {
      _touchX = null;
      widget.onHover(null, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (event) {
        hideHover();
      },
      child: GestureDetector(
        onTap: () {
          if (_localPosition != null) {
            setState(() {
              final findResult = _findModelIndex(_localPosition!.dx);
              _touchX = findResult[_nearestXKey];
              widget.onHover(findResult[_indexKey], _touchX ?? 0);
            });
          }
        },
        onPanDown: (details) {
          _localPosition = details.localPosition;
        },
        onTapUp: (details) {
          hideHover();
        },
        child: Container(
          // color: colors.randColor,
          alignment: Alignment.center,
          child: Container(
            // color: Colors.orange,
            child: RepaintBoundary(
              child: CustomPaint(
                size: Size(widget.painterWidth, widget.painterHeight),
                painter: XBDataPainter(
                    models: widget.models,
                    max: widget.valueRangeMax,
                    min: widget.valueRangeMin,
                    lineCount: widget.valueLineCount,
                    xTitles: widget.xTitles,
                    touchX: _touchX,
                    dayGap: widget.dayGap,
                    datasExtensionSpace: widget.datasExtensionSpace,
                    fractionDigits: widget.fractionDigits,
                    touchLineColor: widget.touchLineColor,
                    lineWidth: widget.lineWidth,
                    circleRadius: widget.circleRadius,
                    valueFontSize: widget.valueFontSize,
                    valueFontWeight: widget.valueFontWeight),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class XBDataPainter extends CustomPainter {
  final List<XBLineChartModel> models;
  final int max;
  final int min;
  final int lineCount;
  final List<XBLineChartXTitle> xTitles;
  final double? touchX;
  final double dayGap;
  final double datasExtensionSpace;
  final int fractionDigits;
  final Color touchLineColor;
  final double lineWidth;
  final double circleRadius;
  final double valueFontSize;
  final FontWeight valueFontWeight;
  XBDataPainter(
      {required this.models,
      required this.max,
      required this.min,
      required this.lineCount,
      required this.xTitles,
      required this.touchX,
      required this.dayGap,
      required this.datasExtensionSpace,
      required this.fractionDigits,
      required this.touchLineColor,
      required this.lineWidth,
      required this.circleRadius,
      required this.valueFontSize,
      required this.valueFontWeight});

  @override
  void paint(Canvas canvas, Size size) {
    const double maxY =
        xbLineChartLeftTitleExtensionSpace + xbLineChartLeftTitleHeight * 0.5;
    final double minY = size.height - maxY - xbLineChartBottomTitleFix;
    final double rangeY = maxY - minY;
    final double stepY = rangeY / (lineCount - 1);
    final double stepX = dayGap;

    var paint = Paint()
      ..color = Colors.grey.withAlpha(40)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < lineCount; i++) {
      final double y = maxY - i * stepY;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);

      // Draw vertical lines on the last horizontal line
      if (i == lineCount - 1) {
        const double verticalLineHeight = 7;
        paint.color = Colors.grey.withAlpha(40); // Or any color you prefer

        for (double x = datasExtensionSpace; x <= size.width; x += stepX) {
          final double topY = y - verticalLineHeight;
          canvas.drawLine(Offset(x, y), Offset(x, topY), paint);
        }

        paint.color = Colors.grey.withAlpha(40); // Restore original color
      }
    }

    paint.strokeWidth = lineWidth;

    // Draw values
    for (final model in models) {
      paint.color = model.color;
      double fontSize = valueFontSize;
      double valuePointW = circleRadius;
      double valueTextYOffset = 7;
      for (int i = 0; i < model.values.length - 1; i++) {
        final value = model.values[i];
        final double x = i * stepX + datasExtensionSpace;
        final double ratio = value / max;
        final double y = minY + ratio * rangeY;

        final nextValue = model.values[i + 1];
        final double nextX = (i + 1) * stepX + datasExtensionSpace;
        final double nextRatio = nextValue / max;
        final double nextY = minY + nextRatio * rangeY;

        final double circleRadius = valuePointW;
        final double lineStartX =
            x + circleRadius * cos(atan2(nextY - y, nextX - x));
        final double lineStartY =
            y + circleRadius * sin(atan2(nextY - y, nextX - x));
        final double lineEndX =
            nextX - circleRadius * cos(atan2(nextY - y, nextX - x));
        final double lineEndY =
            nextY - circleRadius * sin(atan2(nextY - y, nextX - x));

        canvas.drawCircle(Offset(x, y), circleRadius, paint);
        canvas.drawLine(
            Offset(lineStartX, lineStartY), Offset(lineEndX, lineEndY), paint);

        // Draw value text
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: value.toStringAsFixed(fractionDigits),
            style: TextStyle(
                color: model.color,
                fontSize: fontSize,
                fontWeight: valueFontWeight),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        _drawShadow(
            canvas: canvas,
            x: x,
            y: y,
            textPainter: textPainter,
            fontSize: fontSize,
            valueTextYOffset: valueTextYOffset);

        textPainter.paint(
            canvas,
            Offset(
                x - textPainter.width * 0.5,
                y -
                    fontSize -
                    valueTextYOffset)); // Adjust the offset according to your needs
      }
      final lastValue = model.values.last;
      final double lastX =
          (model.values.length - 1) * stepX + datasExtensionSpace;
      final double lastRatio = lastValue / max;
      final double lastY = minY + lastRatio * rangeY;
      canvas.drawCircle(Offset(lastX, lastY), valuePointW, paint);

      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: lastValue.toStringAsFixed(fractionDigits),
          style: TextStyle(
              color: model.color,
              fontSize: fontSize,
              fontWeight: valueFontWeight),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      _drawShadow(
          canvas: canvas,
          x: lastX,
          y: lastY,
          textPainter: textPainter,
          fontSize: fontSize,
          valueTextYOffset: valueTextYOffset);

      textPainter.paint(
          canvas,
          Offset(lastX - textPainter.width * 0.5,
              lastY - fontSize - valueTextYOffset));
    }

    // Draw dates
    final double dateY = size.height - xbLineChartDateFontSize - 15;
    for (int i = 0; i < xTitles.length; i++) {
      final dateStr = xTitles[i];

      if (dateStr.isShow) {
        final double x = i * stepX + datasExtensionSpace;

        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: dateStr.text,
            style:
                xbLineChartDateStrStyle, // Change the color and font size to your preference
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - textPainter.width * 0.5, dateY));
      }
    }
    // 在手指触摸的位置画线
    if (touchX != null) {
      paint.color = touchLineColor;
      paint.strokeWidth = 1;
      canvas.drawLine(Offset(touchX!, maxY), Offset(touchX!, minY), paint);
    }
  }

  _drawShadow(
      {required Canvas canvas,
      required double x,
      required double y,
      required TextPainter textPainter,
      required double fontSize,
      required double valueTextYOffset}) {
    final offset =
        Offset(x - textPainter.width * 0.5, y - fontSize - valueTextYOffset);
    final rect = offset & textPainter.size;
    final path = Path()..addRect(rect);

    // 创建一个白色的画笔，应用模糊效果
    final tempPaint = Paint()
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    canvas.drawPath(path, tempPaint);
  }

  @override
  bool shouldRepaint(XBDataPainter oldDelegate) {
    final ret = oldDelegate.max != max ||
        oldDelegate.min != min ||
        oldDelegate.lineCount != lineCount ||
        oldDelegate.touchX != touchX ||
        oldDelegate.dayGap != dayGap ||
        oldDelegate.datasExtensionSpace != datasExtensionSpace ||
        oldDelegate.fractionDigits != fractionDigits ||
        oldDelegate.touchLineColor != touchLineColor ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.circleRadius != circleRadius ||
        oldDelegate.valueFontSize != valueFontSize ||
        oldDelegate.valueFontWeight != valueFontWeight;
    if (ret == true) {
      return ret;
    }
    if (oldDelegate.models.length != models.length ||
        oldDelegate.xTitles.length != xTitles.length) {
      return true;
    }

    for (int i = 0; i < models.length; i++) {
      if (oldDelegate.models[i] != models[i]) {
        return true;
      }
    }

    for (int i = 0; i < xTitles.length; i++) {
      if (oldDelegate.xTitles[i] != xTitles[i]) {
        return true;
      }
    }
    return false;
  }
}
