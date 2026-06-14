

import 'package:faturax_app/constants/constants_color.dart';
import 'package:flutter/material.dart';

class BoxCircularProgress extends StatelessWidget {
  const BoxCircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.pupleColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CircularProgressIndicator(color: AppColor.whiteColor),
        ),
      ),
    );
  }
}