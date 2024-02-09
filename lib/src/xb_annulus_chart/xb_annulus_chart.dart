import 'package:flutter/material.dart';

import 'xb_annulus_chart_arrow.dart';
import 'xb_annulus_chart_config.dart';
import 'xb_annulus_chart_data.dart';
import 'xb_annulus_chart_model.dart';

class XBAnnulusChart extends StatefulWidget {
  /// 环形的半径，如果不传，则为控件宽度的四分之一
  final double? annulusRadius;
  final List<XBAnnulusChartModel> models;
  final XBAnnulusBottomWidgetBuilder? bottomWidgetBuilder;
  final XBAnnulusChartHoverBuilder? hoverBuilder;
  final XBAnnulusChartHoverWidthGetter? hoverWidthGetter;
  final XBAnnulusChartHoverHeightGetter? hoverHeightGetter;
  final Color? hoverColor;
  const XBAnnulusChart(
      {required this.models,
      this.hoverBuilder,
      this.hoverWidthGetter,
      this.hoverHeightGetter,
      this.hoverColor,
      this.bottomWidgetBuilder,
      this.annulusRadius,
      super.key})
      : assert(
            (hoverBuilder == null &&
                    hoverWidthGetter == null &&
                    hoverHeightGetter == null &&
                    hoverColor == null) ||
                (hoverBuilder != null &&
                    hoverWidthGetter != null &&
                    hoverHeightGetter != null &&
                    hoverColor != null),
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

  Widget _datas() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = widget.annulusRadius != null
            ? widget.annulusRadius! * 2
            : constraints.maxWidth * 0.5;
        _dataWidth = w;
        return Stack(
          children: [
            XBAnnulusChartData(
              width: w,
              height: w,
              models: widget.models,
              onSelected: (model, position) {
                setState(() {
                  _selectedModel = model;
                  _touchPosition = position;
                });
              },
            ),
            Visibility(
              visible: _selectedModel != null,
              child: Positioned(
                  top: _hoverTop(_touchPosition?.dy ?? 0, _hoverHeight()),
                  left: _hoverLeft(_touchPosition?.dx ?? 0, _hoverWidth()),
                  child: IgnorePointer(
                      child: Column(
                    children: [
                      _hover(),
                      Padding(
                        padding: EdgeInsets.only(
                            left: _arrowPaddingLeft(
                                _touchPosition?.dx ?? 0, _hoverWidth()),
                            right: _arrowPaddingRight(
                                _touchPosition?.dx ?? 0, _hoverWidth())),
                        child: XBAnnulusChartArrow(
                          color: _hoverColor(),
                        ),
                      )
                    ],
                  ))),
            )
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

  double _hoverWidth() {
    if (widget.hoverWidthGetter != null) {
      return widget.hoverWidthGetter!(_selectedModel);
    }
    return xbAnnulusChartDefHoverWidthGetter(_selectedModel);
  }

  double _hoverHeight() {
    if (widget.hoverHeightGetter != null) {
      return widget.hoverHeightGetter!(_selectedModel);
    }
    return xbAnnulusChartDefHoverHeightGetter(_selectedModel);
  }

  Widget _hover() {
    if (widget.hoverBuilder != null) {
      return widget.hoverBuilder!(_selectedModel);
    }
    return xbAnnulusChartDefHoverBuilder(_selectedModel);
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
