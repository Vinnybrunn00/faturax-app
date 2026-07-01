import 'package:faturax_app/ui/widgets/input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputCompras extends StatelessWidget {
  final String title;
  final String hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final bool? enabled;
  final bool readOnly;
  final String? errorText;
  final int? maxLength;

  const InputCompras({
    super.key,
    this.onChanged,
    required this.title,
    required this.hintText,
    this.keyboardType,
    this.inputFormatters,
    this.enabled,
    this.readOnly = false, this.errorText, this.maxLength,
    
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: .start,
      children: [
        Text(title, style: TextStyle(fontSize: 14, fontWeight: .w600)),
        InputText(
          enabled: enabled,
          onChanged: onChanged,
          hintText: hintText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          errorText: errorText,
          maxLength: maxLength,
        ),
      ],
    );
  }
}
