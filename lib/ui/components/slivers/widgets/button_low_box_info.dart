import 'package:faturax_app/constants/constants_color.dart';
import 'package:flutter/material.dart';

class ButtonLowBoxInfo extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final double? size;
  final void Function()? onTap;

  const ButtonLowBoxInfo({
    super.key,
    this.icon,
    this.iconColor,
    this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppColor.pupleColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: size),
        ),
      ),
    );
  }
}
