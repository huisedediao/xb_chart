import 'package:flutter/material.dart';
import 'package:xb_scaffold/xb_scaffold.dart';

class WrapItemWidget extends StatelessWidget {
  final List<Widget> children;
  final int columnCount;
  const WrapItemWidget(
      {required this.children, this.columnCount = 3, super.key});

  double get itemW => (screenW - itemGap * (columnCount - 1)) / columnCount;

  double get itemGap {
    return 10;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(children.length, (index) {
        bool needLeftPadding = index % columnCount != 0;
        return Padding(
          padding: EdgeInsets.only(
              left: needLeftPadding ? itemGap : 0, bottom: itemGap),
          child: SizedBox(
            width: itemW,
            child: children[index],
          ),
        );
      }),
    );
  }
}
