import 'package:flutter/material.dart';

import 'xb_annulus_chart_model.dart';
import 'xb_annulus_chart_name_widget.dart';

typedef XBAnnulusBottomWidgetBuilder = Widget Function(
    List<XBAnnulusChartModel> models);
typedef XBAnnulusOnSelected = void Function(
    XBAnnulusChartModel? model, Offset position);

typedef XBAnnulusChartHoverBuilder = Widget Function(
    XBAnnulusChartModel? model);
typedef XBAnnulusChartHoverWidthGetter = double Function(
    XBAnnulusChartModel? model);
typedef XBAnnulusChartHoverHeightGetter = double Function(
    XBAnnulusChartModel? model);

const double xbAnnulusChartNameMarkWidth = 5;

const double xbAnnulusChartDefHoverPaddingH = 8;
const double xbAnnulusChartDefHoverPaddingV = 3;

const Color xbAnnulusChartDefHoverColor = Colors.black;

double xbAnnulusChartTotal(List<XBAnnulusChartModel> models) {
  double ret = 0;
  for (var element in models) {
    ret += element.value;
  }
  return ret;
}

Size xbAnnulusChartTextWidth(String text, TextStyle? style) {
  final textSpan = TextSpan(
    text: text,
    style: style,
  );
  final textPainter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  return Size(textPainter.width + 2, textPainter.height + 2);
}

String xbAnnulusChartHoverContent(XBAnnulusChartModel? model) {
  return "${model?.name ?? ""} ${(model?.value ?? 0).toStringAsFixed(0)}";
}

TextStyle xbAnnulusChartDefHoverContentStyle = const TextStyle(
  color: Colors.white,
  fontSize: 12,
);

Widget xbAnnulusChartDefBottomBuilder(List<XBAnnulusChartModel> models) {
  final total = xbAnnulusChartTotal(models);
  return LayoutBuilder(
    builder: (context, constraints) {
      double gap = 15;
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Wrap(
          children: List.generate(models.length, (index) {
            final model = models[index];
            return SizedBox(
              width: constraints.maxWidth * 0.5,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: 5,
                    right: index % 2 == 0 ? gap * 0.5 : 0,
                    left: index % 2 != 0 ? gap * 0.5 : 0),
                child: XBAnnulusChartNameWidget(
                  color: model.color,
                  name: model.name,
                  textColor: model.isSelected ? model.color : Colors.black,
                  value: '${model.value.toStringAsFixed(0)}次',
                  scale: '${(model.value / total * 100).toStringAsFixed(2)}%',
                ),
              ),
            );
          }),
        ),
      );
    },
  );
}

Widget xbAnnulusChartDefHoverBuilder(XBAnnulusChartModel? model) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(5),
    child: Container(
      alignment: Alignment.center,
      width: xbAnnulusChartTextWidth(xbAnnulusChartHoverContent(model),
                  xbAnnulusChartDefHoverContentStyle)
              .width +
          xbAnnulusChartDefHoverPaddingH * 2,
      height: xbAnnulusChartTextWidth(xbAnnulusChartHoverContent(model),
                  xbAnnulusChartDefHoverContentStyle)
              .height +
          xbAnnulusChartDefHoverPaddingV * 2,
      color: xbAnnulusChartDefHoverColor,
      child: Text(
        xbAnnulusChartHoverContent(model),
        style: xbAnnulusChartDefHoverContentStyle,
      ),
    ),
  );
}

double xbAnnulusChartDefHoverHeightGetter(XBAnnulusChartModel? model) {
  return xbAnnulusChartTextWidth(xbAnnulusChartHoverContent(model),
              xbAnnulusChartDefHoverContentStyle)
          .height +
      xbAnnulusChartDefHoverPaddingV * 2;
}

double xbAnnulusChartDefHoverWidthGetter(XBAnnulusChartModel? model) {
  return xbAnnulusChartTextWidth(xbAnnulusChartHoverContent(model),
              xbAnnulusChartDefHoverContentStyle)
          .width +
      xbAnnulusChartDefHoverPaddingH * 2;
}
