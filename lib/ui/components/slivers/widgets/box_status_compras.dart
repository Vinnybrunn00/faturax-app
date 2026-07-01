import 'package:flutter/material.dart';

class BoxStatusCompras extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color textColor;

  const BoxStatusCompras({
    super.key,
    required this.bgColor,
    required this.textColor, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, .5, 10, .5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        title,
        style: TextStyle(color: textColor, fontWeight: .w500, fontSize: 12),
      ),
    );
  }
}
