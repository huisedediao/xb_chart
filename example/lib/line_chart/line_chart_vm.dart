import 'package:example/line_chart/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:xb_chart/xb_chart.dart';
import 'package:xb_scaffold/xb_scaffold.dart';

class LineChartVM extends XBPageVM<LineChart> {
  LineChartVM({required super.context}) {
    final beginDate = DateTime.now();
    models1 = [
      XBLineChartModel(
          name: '张益达',
          color: Colors.orange,
          values: [10, 20, 1, 95, 38, 109, 127, 18, 98]),
      XBLineChartModel(
          name: '吕小布',
          color: Colors.green,
          values: [11, 26, 21, 35, 78, 19, 172, 22, 31]),
      XBLineChartModel(
          name: '曾小贤',
          color: Colors.blue,
          values: [57, 46, 100, 139, 88, 49, 72, 112, 21]),
      XBLineChartModel(
          name: '吴彦祖',
          color: Colors.greenAccent,
          values: [75, 64, 103, 39, 198, 219, 28, 122, 88]),
      XBLineChartModel(
          name: '张震',
          color: Colors.deepPurple,
          values: [35, 74, 93, 31, 34, 19, 18, 133, 188]),
      XBLineChartModel(
          name: '金城武',
          color: Color.fromARGB(255, 156, 154, 157),
          values: [78, 49, 27, 67, 36, 87, 103, 135, 75]),
      XBLineChartModel(
          name: '程冠希',
          color: Color.fromARGB(255, 26, 121, 76),
          values: [82, 120, 101, 56, 109, 187, 113, 235, 175])
    ];
    int maxValuesCount1 = 0;
    for (var element in models1) {
      final tempLen = element.values.length;
      if (tempLen > maxValuesCount1) {
        maxValuesCount1 = tempLen;
      }
    }
    for (int i = 0; i < maxValuesCount1; i++) {
      xTitles1.add(
          XBLineChartXTitle(text: dateStr(beginDate, i), isShow: i % 2 == 0));
    }

    models2 = [
      XBLineChartModel(
          name: '张益达',
          color: Colors.orange,
          values: [101, 20, 1, 95, 38, 109, 127, 18, 98]),
      XBLineChartModel(
          name: '吕小布',
          color: Colors.green,
          values: [11, 26, 21, 35, 78, 19, 172, 22, 31]),
      XBLineChartModel(
          name: '曾小贤',
          color: Colors.blue,
          values: [57, 46, 100, 139, 88, 49, 72, 112, 21]),
      XBLineChartModel(
          name: '吴彦祖',
          color: Colors.greenAccent,
          values: [75, 64, 103, 39, 198, 219, 28, 122, 88]),
      XBLineChartModel(
          name: '张震',
          color: Colors.deepPurple,
          values: [35, 74, 93, 31, 34, 19, 18, 133, 188]),
      XBLineChartModel(
          name: '金城武',
          color: Color.fromARGB(255, 156, 154, 157),
          values: [78, 49, 27, 67, 36, 87, 103, 135, 75]),
      XBLineChartModel(
          name: '程冠希',
          color: Color.fromARGB(255, 26, 121, 76),
          values: [82, 120, 101, 56, 109, 187, 113, 235, 175])
    ];
    int maxValuesCount2 = 0;
    for (var element in models2) {
      final tempLen = element.values.length;
      if (tempLen > maxValuesCount2) {
        maxValuesCount2 = tempLen;
      }
    }
    for (int i = 0; i < maxValuesCount2; i++) {
      xTitles2.add(
          XBLineChartXTitle(text: dateStr(beginDate, i), isShow: i % 2 == 0));
    }
  }

  int selectedIndex = 0;
  List<XBLineChartXTitle> get xTitles =>
      selectedIndex == 0 ? xTitles1 : xTitles2;
  List<XBLineChartModel> get models => selectedIndex == 0 ? models1 : models2;

  late List<XBLineChartModel> models1;
  List<XBLineChartXTitle> xTitles1 = [];

  late List<XBLineChartModel> models2;
  List<XBLineChartXTitle> xTitles2 = [];

  String dateStr(DateTime beginDate, int offset) {
    final date = beginDate.add(Duration(days: offset));
    final dateStr = xbLineChartConvertDateToString(date);
    return dateStr;
  }
}
