import 'package:flutter/material.dart';

class XBHistogramChartItem extends StatelessWidget {
  /// 0 - 1
  final double value;
  final double height;
  final Color? beginColor;
  final Color? endColor;
  const XBHistogramChartItem(
      {required this.value,
      required this.height,
      this.beginColor,
      this.endColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: height,
          color: const Color(0xFF4C84FF).withAlpha(20),
        ),
        FractionallySizedBox(
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
        )
      ],
    );
  }
}
