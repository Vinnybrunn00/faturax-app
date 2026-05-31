import 'package:faturax/constants/constants_color.dart';
import 'package:flutter/material.dart';

class ButtonLowBoxInfo extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final Widget Function(BuildContext) builder;
  final bool? isOwner;

  const ButtonLowBoxInfo({
    super.key,
    this.icon,
    this.iconColor,
    required this.builder,
    this.isOwner,
  });

  bool get _isOwner {
    if (isOwner == null) return true;
    if (isOwner!) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _isOwner
            ? () {
                Navigator.of(context).push(MaterialPageRoute(builder: builder));
              }
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppColor.pupleColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor),
        ),
      ),
    );
  }
}
