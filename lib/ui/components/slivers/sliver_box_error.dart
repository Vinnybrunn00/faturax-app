import 'package:flutter/material.dart';

class SliverBoxError extends StatelessWidget {
  final Widget? widget;

  const SliverBoxError({super.key, this.widget});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(height: 100, child: Center(child: widget)),
    );
  }
}
