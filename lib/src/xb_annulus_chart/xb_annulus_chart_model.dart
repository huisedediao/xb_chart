import 'package:flutter/material.dart';

class XBAnnulusChartModel {
  final String name;
  final double value;
  final Color color;
  bool isSelected;

  XBAnnulusChartModel(
      {required this.name,
      required this.value,
      required this.color,
      this.isSelected = false});
}
