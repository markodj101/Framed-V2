import 'package:flutter/material.dart';
import 'package:framed_v2/ui/newtons_cradle_loader.dart';

class NotReady extends StatelessWidget {
  const NotReady({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: NewtonsCradleLoader(),
    );
  }
}

