import 'package:flutter/material.dart';

import 'xb_annulus_chart_config.dart';

class XBAnnulusChartNameWidget extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String name;
  final String value;
  final String scale;
  const XBAnnulusChartNameWidget(
      {required this.color,
      required this.name,
      required this.value,
      required this.scale,
      this.textColor = Colors.black,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: xbAnnulusChartNameMarkWidth,
          height: xbAnnulusChartNameMarkWidth,
          color: color,
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: textColor),
          ),
        ),
        Text(value, style: TextStyle(fontSize: 12, color: textColor)),
        Container(
            width: 60,
            alignment: Alignment.bottomRight,
            child:
                Text(scale, style: TextStyle(fontSize: 12, color: textColor))),
      ],
    );
  }
}
