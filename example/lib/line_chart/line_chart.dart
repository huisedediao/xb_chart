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

  @override
  Widget buildPage(vm, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: XBLineChart(
                      yTitleCount: 8,
                      xTitles: vm.xTitles,
                      models: vm.models,
                      pointTextGetter: (value) =>
                          "${value.toStringAsFixed(2)}%",
                      pointTextStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                      ),
                      // hoverValueTextGetter: (value) =>
                      //     "${value.toStringAsFixed(2)}%",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: XBLineChart(
                      yTitleCount: 8,
                      xTitles: vm.xTitles,
                      models: vm.models,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: XBLineChart(
                      yTitleCount: 8,
                      xTitles: vm.xTitles,
                      models: vm.models,
                    ),
                  ),
                  XBButton(
                      onTap: () {
                        vm.selectedIndex = vm.selectedIndex == 0 ? 1 : 0;
                        vm.notify();
                      },
                      child: Container(
                        color: Colors.red,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("切换数据"),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
