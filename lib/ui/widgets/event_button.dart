import 'package:flutter/material.dart';

class EventButton extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final Color? color;
  final IconData? icon;

  const EventButton({
    super.key,
    this.onTap,
    required this.color,
    required this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Material(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          height: size.height * .06,
          width: size.width,
          decoration: BoxDecoration(
            color: color, //Color(0xff4150F7)
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            spacing: 5,
            mainAxisAlignment: .center,
            children: [
              icon != null ? Icon(icon, color: Colors.white) : Container(),
              Text(title, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
