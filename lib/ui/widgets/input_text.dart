import 'package:faturax_app/constants/constants_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputText extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? hintText;
  final Color? color;
  final Color? styleTextColor;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool? enabled;
  final int? maxLength;
  final String? errorText;
  final Widget? prefixIcon;
  final BorderRadius borderRadius;
  final bool obscureText;
  final Widget? suffixIcon;

  const InputText({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText,
    this.color,
    this.styleTextColor,
    this.keyboardType,
    this.inputFormatters,
    this.readOnly = false,
    this.enabled,
    this.maxLength,
    this.errorText,
    this.prefixIcon,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: errorText != null ? 65 : 43,
      child: TextField(
        readOnly: readOnly,
        enabled: enabled,
        maxLength: maxLength,
        autofocus: false,
        controller: controller,
        onChanged: onChanged,
        cursorHeight: 20,
        cursorWidth: 1,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        style: TextStyle(color: styleTextColor),
        cursorErrorColor: Colors.black,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          errorText: errorText,
          errorStyle: TextStyle(
            color: Color(0xFFFF9500),
            fontSize: 12,
            fontWeight: .w600,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: color ?? AppColor.blackColorAlpha55),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: color ?? AppColor.blackColorAlpha55),
          ),
          counterText: '',
          hintText: hintText,
          hintStyle: TextStyle(
            color: color ?? AppColor.blackColorAlpha55,
            fontSize: 12.5,
          ),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: color ?? AppColor.blackColorAlpha55),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: AppColor.purpleColor),
          ),
          contentPadding: EdgeInsets.all(10),
          suffixIcon: suffixIcon,
        ),
        obscureText: obscureText,
      ),
    );
  }
}
