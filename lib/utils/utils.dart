import 'dart:math' as math;
import 'package:faturax/constants/constants_color.dart';
import 'package:flutter/material.dart';

class Utils {
  Future<void> pushAndRemoveUntil(BuildContext context, Widget page) async {
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  void showMessageInfo(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        width: MediaQuery.of(context).size.width * .9,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          decoration: BoxDecoration(
            color: AppColor.backgroundColorBlack,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: AppColor.whiteColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  static int get randomNumber {
    int max = 999999999;
    int min = 100000000;
    final math.Random random = math.Random();
    final int randomNumber = random.nextInt(max - min);
    return randomNumber;
  }
}
