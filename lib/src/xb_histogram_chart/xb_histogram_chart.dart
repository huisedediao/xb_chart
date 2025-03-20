// ignore_for_file: avoid_unnecessary_containers

import 'dart:math';
import 'package:flutter/material.dart';
import 'xb_histogram_chart_item.dart';
import 'xb_histogram_chart_y_model.dart';

typedef XBHistogramChartRightTextGetter<T, S, R> = T Function(S, R);

// ignore: must_be_immutable
class XBHistogramChart extends StatelessWidget {
  /// 数据
  final List<XBHistogramChartYModel> yModels;

  /// 除去0以外，底部文字的数量
  final int xAxisTitleCount;

  /// 每个柱子的高度
  final double itemHeigth;

  /// 柱子的间距
  final double itemGap;

  /// 左侧文字的宽度
  final double leftTitleWidth;

  /// 底部文字的最大宽度，默认100
  final double maxBottomTitleWidth;

  /// 左侧文字和图表的距离
  final double leftTitlePaddingRight;

  /// 是否需要右侧文字
  final bool isNeedRightText;

  /// 右侧文字
  /// 返回值、当前值、最大值
  final XBHistogramChartRightTextGetter<String, double, double>?
      rightTextGetter;

  /// 右侧文字左边距
  final double? rightTextLeftPadding;

  /// 右侧文字样式
  final TextStyle? rightTextStyle;

  /// 底部文字，会自动生成
  late List<String> xAxisTitlesList;

  /// 根据yModels中所有元素的value计算的最大值，用来计算柱子百分比
  late double maxValue;

  /// 底部文字的宽度，会自动计算
  late double bottomTitleWidth;

  final TextStyle? bottomTitleStyle;

  XBHistogramChart(
      {required this.yModels,
      this.xAxisTitleCount = 4,
      this.itemHeigth = 18,
      this.itemGap = 15,
      this.leftTitlePaddingRight = 10,
      this.leftTitleWidth = 50,
      this.maxBottomTitleWidth = 100,
      this.rightTextGetter,
      this.rightTextStyle,
      this.bottomTitleStyle,
      this.isNeedRightText = false,
      this.rightTextLeftPadding,
      super.key}) {
    if (yModels.isEmpty) {
      yModels.add(XBHistogramChartYModel(name: "暂无数据", value: 0));
    }
    xAxisTitlesList = caculateXAxisTitlesList();
    bottomTitleWidth = caculateMaxBottomTitleWidth();
  }

  double _rightTextFit = 0;

  caculateRightTextFit(double maxWidth) {
    double rightTextWidth = caculateMaxRightTextWidth();
    if (isNeedRightText) {
      double topUnderWidth = maxWidth - _bottomLeading;
      double histogramWidth = topUnderWidth - bottomTitleWidth;
      double maxValueW = 0;
      double maxValuePercent = 0;
      for (var element in yModels) {
        final tempW = histogramWidth * element.value / maxValue;
        if (tempW > maxValueW) {
          maxValueW = tempW;
          maxValuePercent = element.value / maxValue;
        }
      }
      if ((maxValueW + _rightTextLeftPadding + rightTextWidth) >
          histogramWidth + bottomTitleWidth * 0.5) {
        double newMaxValueW = maxValueW -
            (maxValueW +
                _rightTextLeftPadding +
                rightTextWidth -
                histogramWidth -
                bottomTitleWidth * 0.5);
        double newHistogramWidth = newMaxValueW / maxValuePercent;
        _rightTextFit = histogramWidth - newHistogramWidth;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      caculateRightTextFit(constraints.maxWidth);
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(children: [
            _topUnder(),
            _top(),
          ]),
          _bottom()
        ],
      );
    });
  }

  double get _bottomLeading =>
      leftTitleWidth + leftTitlePaddingRight - bottomTitleWidth * 0.5;

  _topUnder() {
    return Padding(
      padding: EdgeInsets.only(left: _bottomLeading),
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          // color: Colors.red.withAlpha(100),
          child: FractionallySizedBox(
              widthFactor: 1.0,
              child: Container(
                // color: Colors.amber,
                alignment: Alignment.topLeft,
                height: _topTotalHeight,
                child: Padding(
                  padding: EdgeInsets.only(
                      right: isNeedRightText ? _rightTextFit : 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(xAxisTitlesList.length, (index) {
                      return Visibility(
                        maintainAnimation: true,
                        maintainSize: true,
                        maintainState: true,
                        // visible: true,
                        visible: index != 0,
                        child: Container(
                          // color: Colors.purple,
                          width: bottomTitleWidth,
                          height: _topTotalHeight,
                          alignment: Alignment.center,
                          child: Container(
                            width: 1,
                            color: Colors.grey.withAlpha(30),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              )),
        );
      }),
    );
  }

  _top() {
    return Row(
      children: [_topLeft(), Expanded(child: _topRight())],
    );
  }

  double get _fontSize {
    if ((itemHeigth - 5) > 14) {
      return 14;
    }
    return itemHeigth - 5;
  }

  Widget _topLeft() {
    return Container(
      // color: Colors.red,
      child: Column(
        children: List.generate(yModels.length, (index) {
          XBHistogramChartYModel yModel = yModels[index];
          return Padding(
            padding: EdgeInsets.only(
                bottom: (index == yModels.length - 1) ? 0 : itemGap,
                right: leftTitlePaddingRight),
            child: Container(
                // color: Colors.orange,
                width: leftTitleWidth,
                alignment: Alignment.centerRight,
                height: itemHeigth,
                child: Text(
                  yModel.name,
                  overflow: TextOverflow.ellipsis,
                  style: _leftTitleStyle,
                )),
          );
        }),
      ),
    );
  }

  TextStyle get _leftTitleStyle => TextStyle(fontSize: _fontSize);

  TextStyle get _bottomTitleStyle =>
      bottomTitleStyle ?? const TextStyle(color: Colors.grey, fontSize: 14);

  double get _topTotalHeight {
    return yModels.length * itemHeigth + (yModels.length - 1) * itemGap;
  }

  Widget _topRight() {
    return Container(
        // color: Colors.green,
        child: Container(
      decoration: BoxDecoration(
        // color: Colors.orange,
        border: Border(
          left: BorderSide(
            color: Colors.grey.withAlpha(80), // 边框颜色
            width: 1.0, // 边框宽度
          ),
        ),
      ),
      // color: Colors.orange,
      child: Column(
        children: List.generate(yModels.length, (index) {
          XBHistogramChartYModel yModel = yModels[index];
          return Padding(
            padding: EdgeInsets.only(
                bottom: (index == yModels.length - 1) ? 0 : itemGap),
            child: XBHistogramChartItem(
                rightTextLeftPadding: _rightTextLeftPadding,
                paddingRight: bottomTitleWidth * 0.5 + _rightTextFit,
                value: yModel.value / maxValue,
                height: itemHeigth,
                text: isNeedRightText
                    ? rightTextGetter?.call(yModel.value, maxValue)
                    : "",
                textStyle: _rightTextStyle),
          );
        }),
      ),
    ));
  }

  TextStyle get _rightTextStyle =>
      rightTextStyle ?? const TextStyle(color: Colors.grey, fontSize: 10);

  _bottom() {
    final xAxisTitles = xAxisTitlesList;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          SizedBox(
            width: _bottomLeading,
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(xAxisTitlesList.length, (index) {
              return Container(
                // color: Colors.amber,
                width: bottomTitleWidth,
                alignment: Alignment.center,
                child: Text(
                  xAxisTitles[index],
                  style: _bottomTitleStyle,
                ),
              );
            }),
          )),
          SizedBox(
            width: isNeedRightText ? _rightTextFit : 0,
          )
        ],
      ),
    );
  }

  List<String> caculateXAxisTitlesList() {
    double max = 0;
    for (var element in yModels) {
      if (element.value > max) {
        max = element.value;
      }
    }

    int unit = 1;
    if (max != 0) {
      unit = (max / xAxisTitleCount).ceil();
    } else {
      unit = 1;
    }
    maxValue = (unit * xAxisTitleCount).toDouble();

    final ret =
        List.generate(xAxisTitleCount + 1, (index) => "${index * unit}");
    return ret;
  }

  double caculateMaxRightTextWidth() {
    if (!isNeedRightText) {
      return 0;
    }
    double max = 0;
    for (var element in yModels) {
      final tempW = caculateTitleWidth(
          rightTextGetter?.call(element.value, maxValue) ?? "",
          _rightTextStyle);
      if (tempW > max) {
        max = tempW;
      }
    }
    return max + _rightTextLeftPadding + 2;
  }

  double get _rightTextLeftPadding => rightTextLeftPadding ?? 4;

  double caculateMaxBottomTitleWidth() {
    double max = 0;
    for (var element in xAxisTitlesList) {
      final tempW = caculateTitleWidth(element, _bottomTitleStyle);
      if (tempW > max) {
        max = tempW;
      }
    }
    return min(max, maxBottomTitleWidth);
  }

  double caculateTitleWidth(String value, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: value, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final size = textPainter.size;
    final width = size.width;
    return width + 2;
  }
}
