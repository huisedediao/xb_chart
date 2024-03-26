import 'dart:math';
import 'package:flutter/material.dart';

import 'xb_line_chart_config.dart';
import 'xb_line_chart_data.dart';
import 'xb_line_chart_hover_builder_ret.dart';
import 'xb_line_chart_model.dart';
import 'xb_line_chart_name_widget.dart';
import 'xb_line_chart_x_title.dart';

// ignore: must_be_immutable
class XBLineChart extends StatefulWidget {
  /// 左侧标题的数量，默认为8个
  final int yTitleCount;

  /// 左侧标题的宽度，默认为50
  final double yTitleWidth;

  /// x轴上的文字
  final List<XBLineChartXTitle> xTitles;

  /// 每页，横向要显示几个点，默认7个
  final int pointCountPerPage;

  /// 数据源
  List<XBLineChartModel> models;

  /// 悬浮窗的样式构建函数
  final XBLineChartHoverBuilder? hoverBuilder;

  /// 是否需要底部的名字部分
  final bool needNames;

  /// 最底部，名字的左边距
  final double? namesPaddingLeft;

  /// 最底部，名字的布局方式，默认为wrap
  final XBLineChartNameLayout? namesLayout;

  /// 左侧标题和图表的间距，默认10
  final double leftTitlePaddingRight;

  /// 折线图中的值，取几位小数，默认0
  final int fractionDigits;

  /// 触摸时展示的线条的颜色
  final Color touchLineColor;

  /// 折线的宽度
  final double lineWidth;

  /// 折线圆点的半径
  final double circleRadius;

  /// 折线中数值的字体大小
  final double valueFontSize;

  /// 折线中数值的字重
  final FontWeight valueFontWeight;

  XBLineChart(
      {this.yTitleCount = 8,
      this.yTitleWidth = 50,
      required this.xTitles,
      required this.models,
      this.pointCountPerPage = 7,
      this.hoverBuilder,
      this.namesPaddingLeft,
      this.leftTitlePaddingRight = 10,
      this.needNames = true,
      this.namesLayout = XBLineChartNameLayout.wrap,
      this.fractionDigits = 0,
      this.touchLineColor = Colors.grey,
      this.lineWidth = 2.5,
      this.circleRadius = 2.5,
      this.valueFontSize = 12,
      this.valueFontWeight = FontWeight.w600,
      super.key})
      : assert(yTitleCount > 1, "XBLineChart error：左侧标题数至少为2个") {
    if (models.isEmpty) {
      models = [
        XBLineChartModel(name: "暂无数据", color: Colors.transparent, values: [1])
      ];
    }
  }

  @override
  State<XBLineChart> createState() => _XBLineChartState();
}

class _XBLineChartState extends State<XBLineChart> {
  final ScrollController _controller = ScrollController();
  late double _maxDataWidth;
  double _hoverDx = 0;
  int? _hoverIndex;

  /// 每天的间隔，根据外部传入的数值进行计算
  double dayGap = 30;

  /// 数据点的横向扩展空间
  double datasExtensionSpace = 0;

  int get _maxCount => xbLineChartMaxValueCount(widget.models);

  double get _maxValue => xbLineChartMaxValue(widget.models);

  List<int> get leftTitleContents {
    if (widget.yTitleCount < 1) return [];
    int unit;
    if (_maxValue == 0) {
      unit = 1;
    } else {
      unit = (_maxValue / (widget.yTitleCount - 1)).ceil();
      if (unit == 0) {
        unit = 1;
      }
    }
    return List.generate(widget.yTitleCount, (index) {
      return unit * (widget.yTitleCount - 1 - index);
    });
  }

  double get _painterHeight {
    return widget.yTitleCount * xbLineChartLeftTitleHeight +
        xbLineChartLeftTitleExtensionSpace * 2 +
        xbLineChartBottomTitleFix;
  }

  double get _painterWidth {
    return (_maxCount - 1) * dayGap + datasExtensionSpace * 2;
  }

  @override
  void initState() {
    super.initState();

    /// 计算datasExtensionSpace
    for (var tempTitle in widget.xTitles) {
      final tempStrLenHalf = xbLineChartCaculateTextWidth(
              tempTitle.text, xbLineChartDateStrStyle) *
          0.5;
      if (datasExtensionSpace < tempStrLenHalf) {
        datasExtensionSpace = tempStrLenHalf;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.yellow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: _painterHeight,
            // color: Colors.purple,
            child: Row(
              children: [_leftTitles(), Expanded(child: _datas())],
            ),
          ),
          _names()
        ],
      ),
    );
  }

  Widget _leftTitles() {
    return Container(
      // color: Colors.amber,
      child: Padding(
        padding: EdgeInsets.only(
            top: xbLineChartLeftTitleExtensionSpace,
            right: widget.leftTitlePaddingRight),
        child: Container(
          width: widget.yTitleWidth,
          // color: Colors.red,
          child: Column(
            children: List.generate(leftTitleContents.length, (index) {
              return Container(
                  alignment: Alignment.centerRight,
                  height: xbLineChartLeftTitleHeight,
                  // color: colors.randColor,
                  child: Text(
                    '${leftTitleContents[index]}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ));
            }),
          ),
        ),
      ),
    );
  }

  Widget _datas() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        ///必须在最前面
        dayGap = (constraints.maxWidth - datasExtensionSpace * 2) /
            (widget.pointCountPerPage - 1);
        _maxDataWidth = constraints.maxWidth;
        // print("maxWidth:${constraints.maxWidth}");

        final double h = max(_painterHeight, constraints.maxHeight);
        final double w = max(_painterWidth, constraints.maxWidth);

        late XBLineChartHoverBuilderRet ret;
        if (_hoverIndex != null) {
          if (widget.hoverBuilder != null) {
            ret = widget.hoverBuilder!(
                _hoverIndex, _hoverDx, constraints.maxHeight);
          } else {
            ret = xbLineChartDefHoverBuilder(
                _hoverIndex,
                _hoverDx,
                constraints.maxHeight,
                widget.xTitles[_hoverIndex!].text,
                widget.models);
          }
        }

        return Stack(
          children: [
            Container(
              // color: Colors.blue.withAlpha(10),
              child: SingleChildScrollView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                child: Container(
                  // color: Colors.blue.withAlpha(10),
                  width: w,
                  height: h,
                  child: XBLineChartData(
                    leftTitleCount: widget.yTitleCount,
                    xTitles: widget.xTitles,
                    models: widget.models,
                    valueRangeMax: leftTitleContents.first,
                    valueRangeMin: leftTitleContents.last,
                    valueLineCount: leftTitleContents.length,
                    painterWidth: w,
                    painterHeight: h,
                    dayGap: dayGap,
                    fractionDigits: widget.fractionDigits,
                    datasExtensionSpace: datasExtensionSpace,
                    touchLineColor: widget.touchLineColor,
                    lineWidth: widget.lineWidth,
                    circleRadius: widget.circleRadius,
                    valueFontSize: widget.valueFontSize,
                    valueFontWeight: widget.valueFontWeight,
                    onHover: (int? hoverIndex, double dx) {
                      // print("globalDx:$dx,hoverIndex:$hoverIndex");
                      _hoverIndex = hoverIndex;
                      setState(() {
                        _hoverDx = dx - _controller.offset;
                      });
                    },
                  ),
                ),
              ),
            ),
            if (_hoverIndex != null)
              Positioned(
                top: 0,
                left: _hoverLeft(ret.width),
                child: ret.hover,
              )
            else
              const SizedBox()
          ],
        );
      },
    );
  }

  double _hoverLeft(hoverWidth) {
    double padding = 0;
    double ret = _hoverDx - hoverWidth * 0.5;
    if (ret < padding) {
      ret = padding;
    }
    if (ret + hoverWidth + padding > _maxDataWidth) {
      ret = _maxDataWidth - hoverWidth - padding;
    }
    return ret;
  }

  Widget _names() {
    if (widget.needNames == false) return Container();
    if (widget.namesLayout == XBLineChartNameLayout.wrap) {
      /// 换行显示
      return Padding(
        padding: EdgeInsets.only(left: widget.namesPaddingLeft ?? 0),
        child: Container(
          // alignment: Alignment.centerLeft,
          // color: Colors.blue,
          child: Container(
            // color: Colors.amber,
            // height: 30,
            alignment: Alignment.centerLeft,
            child: Wrap(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(widget.models.length, (index) {
                final model = widget.models[index];
                return Padding(
                  padding: EdgeInsets.only(
                      right: index == widget.models.length - 1 ? 0 : 10,
                      left: 5,
                      bottom: 5),
                  child: XBLineChartNameWidget(
                    color: model.color,
                    name: model.name,
                  ),
                );
              }),
            ),
          ),
        ),
      );
    } else {
      /// 横向滑动
      return Container(
        alignment: Alignment.centerLeft,
        // color: Colors.blue,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            // color: Colors.amber,
            height: 30,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(widget.models.length, (index) {
                final model = widget.models[index];
                return Padding(
                  padding: EdgeInsets.only(
                      right: index == widget.models.length - 1 ? 0 : 10,
                      left: 5),
                  child: XBLineChartNameWidget(
                    color: model.color,
                    name: model.name,
                  ),
                );
              }),
            ),
          ),
        ),
      );
    }
  }
}
