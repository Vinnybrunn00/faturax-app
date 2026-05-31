import 'package:faturax/ui/widgets/input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputCompras extends StatelessWidget {
  final String title;
  final String hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  const InputCompras({
    super.key,
    this.onChanged,
    required this.title,
    required this.hintText,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: .start,
      children: [
        Text(title),
        InputText(
          onChanged: onChanged,
          hintText: hintText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
        ),
      ],
    );
  }
}
