import 'package:flutter/material.dart';

import 'xb_line_chart_config.dart';

class XBLineChartNameWidget extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String name;
  const XBLineChartNameWidget(
      {required this.color,
      required this.name,
      this.textColor = Colors.black,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: xbLineChartNameMarkWidth,
          height: xbLineChartNameMarkWidth,
          color: color,
        ),
        const SizedBox(
          width: xbLineChartNameMarkGap,
        ),
        Text(
          name,
          style: TextStyle(
              color: textColor,
              fontSize: xbLineChartNameWidgetTextStyle.fontSize),
        )
      ],
    );
  }
}
