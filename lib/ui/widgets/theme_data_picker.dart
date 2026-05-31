import 'package:flutter/material.dart';

class ThemeDataPicker extends StatelessWidget {
  final Widget? child;
  const ThemeDataPicker({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: Color(0xff4150F7),
          onPrimary: Colors.white,
          onSurface: Colors.black87,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Color(0xff4150F7)),
        ),
      ),
      child: child!,
    );
  }
}
