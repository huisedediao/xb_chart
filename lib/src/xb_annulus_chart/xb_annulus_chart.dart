import 'package:flutter/material.dart';

import 'xb_annulus_chart_arrow.dart';
import 'xb_annulus_chart_config.dart';
import 'xb_annulus_chart_data.dart';
import 'xb_annulus_chart_hover_builder_ret.dart';
import 'xb_annulus_chart_model.dart';

class XBAnnulusChart extends StatefulWidget {
  /// 环形的半径，如果不传，则为控件宽度的四分之一
  final double? annulusRadius;

  /// 数据源
  final List<XBAnnulusChartModel> models;

  /// 底部的widget
  final XBAnnulusBottomWidgetBuilder? bottomWidgetBuilder;

  /// 点击以后展示的浮动标签
  final XBAnnulusChartHoverBuilder? hoverBuilder;

  /// hover箭头的颜色
  final Color? hoverColor;

  /// 环形的线宽
  final double? strokeWidth;

  /// 是否可以选中单独的部分
  final bool canSelected;

  const XBAnnulusChart(
      {required this.models,
      this.hoverBuilder,
      this.hoverColor,
      this.bottomWidgetBuilder,
      this.annulusRadius,
      this.strokeWidth,
      this.canSelected = true,
      super.key})
      : assert(
            (hoverBuilder == null && hoverColor == null) ||
                (hoverBuilder != null && hoverColor != null),
            "如果定制hover，需要全套定制");

  @override
  State<XBAnnulusChart> createState() => _XBAnnulusChartState();
}

class _XBAnnulusChartState extends State<XBAnnulusChart> {
  XBAnnulusChartModel? _selectedModel;
  Offset? _touchPosition;

  @override
  void didUpdateWidget(covariant XBAnnulusChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    XBAnnulusChartModel? temp;
    for (var element in widget.models) {
      if (element.isSelected) {
        temp = element;
        break;
      }
    }
    _selectedModel = temp;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [_datas(), _names()],
    );
  }

  late double _dataWidth;

  late XBAnnulusChartHoverBuilderRet builderRet;
  double _hoverTopPosition = 0;
  double _hoverLeftPosition = 0;
  double _arrowPaddingLeftPositon = 0;
  double _arrowPaddingRightPositon = 0;

  Widget _datas() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = widget.annulusRadius != null
            ? widget.annulusRadius! * 2
            : constraints.maxWidth * 0.5;
        _dataWidth = w;
        return Stack(
          alignment: Alignment.center,
          children: [
            XBAnnulusChartData(
              width: w,
              height: w,
              models: widget.models,
              strokeWidth: widget.strokeWidth ?? 40,
              selectedDistance: widget.canSelected ? 10 : 0,
              onSelected: (model, position) {
                setState(() {
                  _selectedModel = model;
                  _touchPosition = position;
                  if (_selectedModel != null) {
                    if (widget.hoverBuilder != null) {
                      builderRet = widget.hoverBuilder!(_selectedModel);
                    } else {
                      builderRet =
                          xbAnnulusChartDefHoverBuilder(_selectedModel);
                    }
                    _hoverTopPosition =
                        _hoverTop(_touchPosition?.dy ?? 0, builderRet.height);
                    _hoverLeftPosition =
                        _hoverLeft(_touchPosition?.dx ?? 0, builderRet.width);
                    _arrowPaddingLeftPositon = _arrowPaddingLeft(
                        _touchPosition?.dx ?? 0, builderRet.width);
                    _arrowPaddingRightPositon = _arrowPaddingRight(
                        _touchPosition?.dx ?? 0, builderRet.width);
                  }
                });
              },
            ),
            if (widget.canSelected && _selectedModel != null)
              AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  top: _hoverTopPosition,
                  left: _hoverLeftPosition,
                  child: IgnorePointer(
                      child: Column(
                    children: [
                      builderRet.hover,
                      Padding(
                        padding: EdgeInsets.only(
                            left: _arrowPaddingLeftPositon,
                            right: _arrowPaddingRightPositon),
                        child: XBAnnulusChartArrow(
                          color: _hoverColor(),
                        ),
                      )
                    ],
                  )))
            else
              Container(),
          ],
        );
      },
    );
  }

  Color _hoverColor() {
    if (widget.hoverColor != null) {
      return widget.hoverColor!;
    }
    return xbAnnulusChartDefHoverColor;
  }

  double _arrowPaddingLeft(double dx, double hoverWidth) {
    double center = dx - hoverWidth * 0.5;
    if (center + hoverWidth > _dataWidth) {
      return (center + hoverWidth - _dataWidth) * 2;
    }
    return 0;
  }

  double _arrowPaddingRight(double dx, double hoverWidth) {
    double ret = dx - hoverWidth * 0.5;
    if (ret < 0) {
      return ret.abs() * 2;
    }
    return 0;
  }

  double _hoverTop(double dy, double hoverHeight) {
    double ret = dy - hoverHeight;
    if (ret < 0) {
      ret = 0;
    }
    if (ret + hoverHeight > _dataWidth) {
      ret = _dataWidth - hoverHeight;
    }
    return ret;
  }

  double _hoverLeft(double dx, double hoverWidth) {
    double ret = dx - hoverWidth * 0.5;
    if (ret < 0) {
      ret = 0;
    }
    if (ret + hoverWidth > _dataWidth) {
      ret = _dataWidth - hoverWidth;
    }
    return ret;
  }

  Widget _names() {
    if (widget.bottomWidgetBuilder != null) {
      return widget.bottomWidgetBuilder!(widget.models);
    }
    return xbAnnulusChartDefBottomBuilder(widget.models);
  }
}
