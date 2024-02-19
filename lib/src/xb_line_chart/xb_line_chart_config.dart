// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'xb_line_chart_hover_builder_ret.dart';
import 'xb_line_chart_model.dart';
import 'xb_line_chart_name_widget.dart';

typedef XBLineChartOnHover = void Function(int? hoverIndex, double hoverDx);
typedef XBLineChartHoverBuilder = XBLineChartHoverBuilderRet Function(
    int? hoverIndex, double hoverDx, double maxHeight);

enum XBLineChartNameLayout { scroll, wrap }

/// 底部标题位置调整的参数
const double xbLineChartBottomTitleFix = 10;

/// 左侧标题的高度
const double xbLineChartLeftTitleHeight = 30;

/// 标记点的大小
const double xbLineChartNameMarkWidth = 5;

/// 标记点和名字之间的间距
const double xbLineChartNameMarkGap = 5;

/// 左边标题纵向的扩展空间
const double xbLineChartLeftTitleExtensionSpace = 15;

/// hover item 名字和数值之间的间距
const double xbLineChartDefHoverItemGap = 10;

/// 日期的字体大小
const double xbLineChartDateFontSize = 10;

/// 名字的字体大小
TextStyle xbLineChartNameWidgetTextStyle = const TextStyle(fontSize: 12);

TextStyle xbLineChartDateStrStyle = const TextStyle(
    color: Color.fromARGB(255, 148, 146, 146),
    fontSize: xbLineChartDateFontSize);

String xbLineChartConvertDateToString(DateTime date) {
  String year = xbLineChartFixZeroStr(date.year);
  String month = xbLineChartFixZeroStr(date.month);
  String day = xbLineChartFixZeroStr(date.day);

  return "$year-$month-$day";
}

String xbLineChartFixZeroStr(int value) {
  if (value < 10) {
    return '0$value';
  } else {
    return '$value';
  }
}

int xbLineChartMaxValueCount(List<XBLineChartModel> models) {
  int ret = 0;
  for (var element in models) {
    if (element.values.length > ret) {
      ret = element.values.length;
    }
  }
  return ret;
}

double xbLineChartMaxValue(List<XBLineChartModel> models) {
  double ret = 0;
  for (var element in models) {
    for (var value in element.values) {
      if (value > ret) {
        ret = value;
      }
    }
  }
  return ret;
}

String xbLineChartDateStr(DateTime beginDate, int offset) {
  final date = beginDate.add(Duration(days: offset));
  final dateStr = xbLineChartConvertDateToString(date);
  return dateStr;
}

XBLineChartHoverBuilderRet xbLineChartDefHoverBuilder(
    int? hoverIndex,
    double hoverDx,
    double maxHeight,
    String dateStr,
    List<XBLineChartModel> models) {
  if (hoverIndex == null) {
    return XBLineChartHoverBuilderRet(hover: Container(), width: 0);
  }
  double dateStrHeight = 20;
  double padding = 8;
  TextStyle dateStrStyle = const TextStyle(color: Colors.white, fontSize: 16);
  double maxWidth = xbLineChartCaculateTextWidth(dateStr, dateStrStyle);
  for (var model in models) {
    double tempWidth =
        _hoverItemWidth(name: model.name, value: model.values[hoverIndex]);
    if (tempWidth > maxWidth) {
      maxWidth = tempWidth;
    }
  }
  maxWidth = maxWidth + padding * 2;
  return XBLineChartHoverBuilderRet(
      hover: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: maxWidth,
          color: Colors.black,
          child: Padding(
            padding:
                EdgeInsets.only(top: padding, bottom: padding, left: padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: dateStrHeight,
                  child: Text(
                    dateStr,
                    style: dateStrStyle,
                  ),
                ),
                Container(
                  constraints:
                      BoxConstraints(maxHeight: maxHeight - dateStrHeight),
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(models.length, (index) {
                        final model = models[index];
                        final value = model.values[hoverIndex];
                        return _hoverItem(
                            color: model.color, name: model.name, value: value);
                      }),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      width: maxWidth);
}

double _hoverItemWidth({required String name, required double value}) {
  return xbLineChartNameMarkWidth +
      xbLineChartNameMarkGap +
      xbLineChartCaculateTextWidth(name, xbLineChartNameWidgetTextStyle) +
      xbLineChartDefHoverItemGap +
      xbLineChartCaculateTextWidth(
          value.toStringAsFixed(0), xbLineChartNameWidgetTextStyle);
}

Widget _hoverItem(
    {required Color color, required String name, required double value}) {
  return Row(
    children: [
      XBLineChartNameWidget(
        color: color,
        textColor: Colors.white,
        name: name,
      ),
      const SizedBox(
        width: xbLineChartDefHoverItemGap,
      ),
      Text(
        value.toStringAsFixed(0),
        style: TextStyle(
            color: Colors.white,
            fontSize: xbLineChartNameWidgetTextStyle.fontSize),
      ),
    ],
  );
}

double xbLineChartCaculateTextWidth(String value, TextStyle? style) {
  final textPainter = TextPainter(
    text: TextSpan(text: value, style: style),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();

  final size = textPainter.size;
  final width = size.width;
  return width + 2;
}
