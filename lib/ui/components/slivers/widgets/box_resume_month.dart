import 'package:faturax/constants/constants_color.dart';
import 'package:flutter/material.dart';

class BoxResumeMonth extends StatelessWidget {
  final String month;

  const BoxResumeMonth({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 650),
      padding: EdgeInsets.fromLTRB(18, 3, 18, 3),
      decoration: BoxDecoration(
        color: AppColor.greenColor.withAlpha(55),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        'Resumo de $month',
        style: TextStyle(color: AppColor.greenColor, fontSize: 12),
      ),
    );
  }
}
