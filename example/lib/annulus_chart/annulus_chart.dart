import 'package:example/annulus_chart/annulus_chart_vm.dart';
import 'package:flutter/material.dart';
import 'package:xb_chart/xb_chart.dart';
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
      XBAnnulusChartModel(
          name: '张益达张益达张益达张益达张益达张益达张益达 10 次', color: Colors.orange, value: 10),
      XBAnnulusChartModel(name: 'snack ', color: Colors.purple, value: 10),
      XBAnnulusChartModel(name: '吕小布 10 次', color: Colors.green, value: 10),
      XBAnnulusChartModel(name: '曾小贤 10 次', color: Colors.blue, value: 10),
      XBAnnulusChartModel(
          name: '吴彦祖 10 次', color: Colors.greenAccent, value: 10),
      XBAnnulusChartModel(name: '张震 10 次', color: Colors.red, value: 10)
    ];

    return Center(
      child: Column(
        children: [
          Padding(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.withAlpha(100), width: 1),
                            borderRadius: BorderRadius.circular(80)),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: XBAnnulusChart(
                            annulusRadius: 70,
                            strokeWidth: 10,
                            models: models,
                            bottomWidgetBuilder: (models) {
                              return Container();
                            },
                            canSelected: false,
                            // hoverBuilder: (model) {
                            //   return XBAnnulusChartHoverBuilderRet(
                            //       hover: Container(), width: 0, height: 0);
                            // },
                            // hoverColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      color: Colors.redAccent,
                      child: Column(
                        children: [Text("1"), Text("1"), Text("1")],
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
