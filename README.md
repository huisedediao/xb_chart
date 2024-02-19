# xb_line_chart
折线图

![image.png](https://raw.githubusercontent.com/huisedediao/xb_chart/main/line_chart.png)


```
import 'package:example/line_chart/line_chart_vm.dart';
import 'package:flutter/material.dart';
import 'package:xb_scaffold/xb_scaffold.dart';
import 'package:xb_chart/xb_chart.dart';

class LineChart extends XBPage<LineChartVM> {
  const LineChart({super.key});

  @override
  generateVM(BuildContext context) {
    return LineChartVM(context: context);
  }

  @override
  String setTitle(LineChartVM vm) {
    return "折线图demo";
  }

  String dateStr(DateTime beginDate, int offset) {
    final date = beginDate.add(Duration(days: offset));
    final dateStr = xbLineChartConvertDateToString(date);
    return dateStr;
  }

  @override
  Widget buildPage(vm, BuildContext context) {
    final beginDate = DateTime.now();
    final models = [
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
    int maxValuesCount = 0;
    for (var element in models) {
      final tempLen = element.values.length;
      if (tempLen > maxValuesCount) {
        maxValuesCount = tempLen;
      }
    }
    List<XBLineChartXTitle> xTitles = [];
    for (int i = 0; i < maxValuesCount; i++) {
      xTitles.add(
          XBLineChartXTitle(text: dateStr(beginDate, i), isShow: i % 2 == 0));
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: XBLineChart(
                yTitleCount: 8,
                xTitles: xTitles,
                models: models,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


```

# xb_annulus_chart
环形图


![image.png](https://raw.githubusercontent.com/huisedediao/xb_chart/main/annulus_chart.png)


```
import 'package:flutter/material.dart';
import 'package:xb_custom_widget_cabin/annulus_chart/annulus_chart_vm.dart';
import 'package:xb_custom_widget_cabin/annulus_chart/xb_annulus_chart/xb_annulus_chart.dart';
import 'package:xb_custom_widget_cabin/annulus_chart/xb_annulus_chart/xb_annulus_chart_model.dart';
import 'package:xb_scaffold/xb_scaffold.dart';

class AnnulusChart extends XBPage<AnnulusChartVM> {
  const AnnulusChart({super.key});

  @override
  generateVM(BuildContext context) {
    return AnnulusChartVM(context: context);
  }

  @override
  String setTitle(AnnulusChartVM vm) {
    return "环形图demo";
  }

  @override
  Widget buildPage(vm, BuildContext context) {
    final models = [
      XBAnnulusChartModel(name: '张益达', color: Colors.orange, value: 10),
      XBAnnulusChartModel(name: 'snack', color: Colors.purple, value: 10),
      XBAnnulusChartModel(name: '吕小布', color: Colors.green, value: 10),
      XBAnnulusChartModel(name: '曾小贤', color: Colors.blue, value: 10),
      XBAnnulusChartModel(name: '吴彦祖', color: Colors.greenAccent, value: 10),
      XBAnnulusChartModel(name: '张震', color: Colors.red, value: 10)
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: XBAnnulusChart(
                annulusRadius: 100,
                models: models,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

```

# xb_histogram_chart
柱状图

![image.png](https://raw.githubusercontent.com/huisedediao/xb_chart/main/histogram_chart.png)


```
import 'package:flutter/material.dart';
import 'package:xb_custom_widget_cabin/histogram_chart/histogram_chart_vm.dart';
import 'package:xb_custom_widget_cabin/histogram_chart/xb_histogram_chart/xb_histogram_chart.dart';
import 'package:xb_custom_widget_cabin/histogram_chart/xb_histogram_chart/xb_histogram_chart_y_model.dart';
import 'package:xb_scaffold/xb_scaffold.dart';

class HistogramChart extends XBPage<HistogramChartVM> {
  const HistogramChart({super.key});

  @override
  generateVM(BuildContext context) {
    return HistogramChartVM(context: context);
  }

  @override
  String setTitle(HistogramChartVM vm) {
    return "柱状图demo";
  }

  @override
  Widget buildPage(vm, BuildContext context) {
    final models = [
      XBHistogramYModel(name: '张益达', value: 10),
      XBHistogramYModel(name: 'snack', value: 9),
      XBHistogramYModel(name: '吕小布', value: 8),
      XBHistogramYModel(name: '曾小贤', value: 7),
      XBHistogramYModel(name: '吴彦祖', value: 6),
      XBHistogramYModel(name: '张震', value: 5)
    ];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: XBHistogram(yModels: models),
            ),
          ),
        ),
      ),
    );
  }
}

```