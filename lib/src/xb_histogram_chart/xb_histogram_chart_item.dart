import 'package:flutter/material.dart';

class XBHistogramChartItem extends StatelessWidget {
  /// 0 - 1
  final double value;
  final double height;
  final Color? beginColor;
  final Color? endColor;
  final double paddingRight;
  final String? text;
  final TextStyle? textStyle;
  const XBHistogramChartItem(
      {required this.value,
      required this.height,
      this.beginColor,
      this.endColor,
      required this.paddingRight,
      this.text,
      this.textStyle,
      super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return Stack(
        alignment: Alignment.centerLeft,
        children: [
          Padding(
            padding: EdgeInsets.only(right: paddingRight),
            child: Container(
              height: height,
              color: const Color(0xFF4C84FF).withAlpha(20),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: paddingRight),
            child: FractionallySizedBox(
              widthFactor: value,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(height * 0.5),
                    bottomRight: Radius.circular(height * 0.5)),
                child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        beginColor ?? const Color.fromRGBO(225, 255, 237, 1),
                        endColor ?? const Color.fromRGBO(63, 85, 249, 1)
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: (width - paddingRight) * value,
              child: Container(
                // color: Colors.green,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    text ?? "${value * 100}%",
                    style: textStyle ??
                        const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ),
              ))
        ],
      );
    });
  }
}
