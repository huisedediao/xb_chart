import 'package:example/annulus_chart/annulus_chart.dart';
import 'package:example/histogram_chart/histogram_chart.dart';
import 'package:example/line_chart/line_chart.dart';
import 'package:example/wrap_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:xb_scaffold/xb_scaffold.dart';

class Home extends XBPage<HomeVM> {
  const Home({super.key});

  @override
  generateVM(BuildContext context) {
    return HomeVM(context: context);
  }

  @override
  String setTitle(HomeVM vm) {
    return "Home";
  }

  @override
  Widget? leading(HomeVM vm) {
    return Container();
  }

  @override
  Widget buildPage(vm, BuildContext context) {
    return WrapItemWidget(children: [
      XBButton(
          onTap: () {
            push(const LineChart());
          },
          child: Container(
              color: Colors.red,
              height: 100,
              alignment: Alignment.center,
              child: const Text(
                "折线图",
                style: TextStyle(color: Colors.white),
              ))),
      XBButton(
          onTap: () {
            push(const AnnulusChart());
          },
          child: Container(
              color: Colors.red,
              height: 100,
              alignment: Alignment.center,
              child: const Text(
                "环形图",
                style: TextStyle(color: Colors.white),
              ))),
      XBButton(
          onTap: () {
            push(const HistogramChart());
          },
          child: Container(
              color: Colors.red,
              height: 100,
              alignment: Alignment.center,
              child: const Text(
                "柱状图",
                style: TextStyle(color: Colors.white),
              )))
    ]);
  }
}

class HomeVM extends XBPageVM<Home> {
  HomeVM({required super.context});
}
