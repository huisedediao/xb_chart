import 'package:example/histogram_chart/histogram_chart_vm.dart';
import 'package:flutter/material.dart';
import 'package:xb_chart/xb_chart.dart';
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
      XBHistogramYModel(name: '张益达', value: 9999),
      XBHistogramYModel(name: 'snack', value: 9000),
      XBHistogramYModel(name: '吕小布', value: 8000),
      XBHistogramYModel(name: '曾小贤', value: 7000),
      XBHistogramYModel(name: '吴彦祖', value: 6000),
      XBHistogramYModel(name: '张震', value: 5000)
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
