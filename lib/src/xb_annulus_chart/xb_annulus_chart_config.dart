import 'package:flutter/material.dart';
import 'xb_annulus_chart_hover_builder_ret.dart';
import 'xb_annulus_chart_model.dart';
import 'xb_annulus_chart_name_widget.dart';

typedef XBAnnulusBottomWidgetBuilder = Widget Function(
    List<XBAnnulusChartModel> models);
typedef XBAnnulusOnSelected = void Function(
    XBAnnulusChartModel? model, Offset position);

typedef XBAnnulusChartHoverBuilder = XBAnnulusChartHoverBuilderRet Function(
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

Size xbAnnulusChartTextSize(String text, TextStyle? style) {
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

XBAnnulusChartHoverBuilderRet xbAnnulusChartDefHoverBuilder(
    XBAnnulusChartModel? model) {
  final content = xbAnnulusChartHoverContent(model);
  final contentSize =
      xbAnnulusChartTextSize(content, xbAnnulusChartDefHoverContentStyle);
  final width = contentSize.width + xbAnnulusChartDefHoverPaddingH * 2;
  final height = contentSize.height + xbAnnulusChartDefHoverPaddingV * 2;
  return XBAnnulusChartHoverBuilderRet(
      hover: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          alignment: Alignment.center,
          width: width,
          height: height,
          color: xbAnnulusChartDefHoverColor,
          child: Text(
            content,
            style: xbAnnulusChartDefHoverContentStyle,
          ),
        ),
      ),
      width: width,
      height: height);
}
