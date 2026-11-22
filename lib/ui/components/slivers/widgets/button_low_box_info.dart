import 'package:faturax_app/constants/constants_color.dart';
import 'package:material_ui/material_ui.dart';

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
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColor.whiteColor.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: size),
        ),
      ),
    );
  }
}
