import 'package:material_ui/material_ui.dart';

class BoxStatusCompras extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color textColor;

  const BoxStatusCompras({
    super.key,
    required this.bgColor,
    required this.textColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: .w600,
          fontSize: 11,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
