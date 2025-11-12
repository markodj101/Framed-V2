import 'package:flutter/material.dart';
import 'package:framed_v2/utils/utils.dart';

class TextIcon extends StatelessWidget {
  final Text text;
  final IconButton icon;

  TextIcon({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [icon, addVerticalSpace(4), text],
    );
  }
}
