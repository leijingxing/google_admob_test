import 'package:flutter/material.dart';

import '../constants/dimens.dart';

class AppFormStyles {
  static const Color borderColor = Color(0xFFD7DFEB);
  static const Color focusedBorderColor = Color(0xFF1F7BFF);
  static const Color hintColor = Color(0xFF9AA6B2);
  static const Color textColor = Color(0xFF2B3A4F);
  static const Color fillColor = Colors.white;
  static const Color disabledBorderColor = Color(0xFFE3EAF4);
  static const Color disabledTextColor = Color(0xFF7E8A9A);
  static const Color disabledHintColor = Color(0xFFAEB9C7);
  static const Color disabledFillColor = Color(0xFFF3F6FA);
  static const Color dropdownBackgroundColor = Colors.white;
  static const double dropdownMenuMaxHeight = 320;

  static BorderRadius get borderRadius => BorderRadius.circular(AppDimens.dp10);

  static BorderRadius get dropdownBorderRadius => BorderRadius.circular(AppDimens.dp16);

  static OutlineInputBorder outlineBorder({Color? color, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: color ?? borderColor, width: width),
    );
  }

  static TextStyle inputTextStyle({bool enabled = true}) {
    return TextStyle(fontSize: AppDimens.sp14, color: enabled ? textColor : disabledTextColor, fontWeight: FontWeight.w500);
  }

  static InputDecoration inputDecoration({String? hintText, Widget? suffixIcon, Widget? prefixIcon, bool filled = true, bool enabled = true}) {
    final effectiveBorderColor = enabled ? borderColor : disabledBorderColor;
    final effectiveHintColor = enabled ? hintColor : disabledHintColor;
    final effectiveFillColor = enabled ? fillColor : disabledFillColor;

    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(fontSize: AppDimens.sp13, color: effectiveHintColor, fontWeight: FontWeight.w500),
      filled: filled,
      fillColor: filled ? effectiveFillColor : null,
      contentPadding: EdgeInsets.symmetric(horizontal: AppDimens.dp12, vertical: AppDimens.dp12),
      border: outlineBorder(color: effectiveBorderColor),
      enabledBorder: outlineBorder(color: effectiveBorderColor),
      focusedBorder: enabled ? outlineBorder(color: focusedBorderColor, width: 1.2) : outlineBorder(color: effectiveBorderColor),
      disabledBorder: outlineBorder(color: disabledBorderColor),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
    );
  }

  static InputDecoration editableInputDecoration({String? hintText, Widget? suffixIcon, Widget? prefixIcon, bool filled = true}) {
    return inputDecoration(hintText: hintText, suffixIcon: suffixIcon, prefixIcon: prefixIcon, filled: filled, enabled: true);
  }

  static InputDecoration readOnlyInputDecoration({String? hintText, Widget? suffixIcon, Widget? prefixIcon, bool filled = true}) {
    return inputDecoration(hintText: hintText, suffixIcon: suffixIcon, prefixIcon: prefixIcon, filled: filled, enabled: false);
  }

  static bool isEditable(bool? enabled, bool readOnly) {
    return (enabled ?? true) && !readOnly;
  }
}

class AppDropdownOptionLabel extends StatelessWidget {
  const AppDropdownOptionLabel({super.key, required this.text, this.textColor = const Color(0xFF223146), this.backgroundColor = const Color(0xFFF3F6FB), this.borderColor = const Color(0xFFE0E7F1)});

  final String text;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp10, vertical: AppDimens.dp6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: AppDimens.sp12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class AppDropdownMenuText extends StatelessWidget {
  const AppDropdownMenuText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.dp6),
      child: Text(
        text,
        softWrap: true,
        style: TextStyle(color: const Color(0xFF223146), fontSize: AppDimens.sp13, fontWeight: FontWeight.w600, height: 1.4),
      ),
    );
  }
}

class AppDropdownSelectedText extends StatelessWidget {
  const AppDropdownSelectedText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: const Color(0xFF223146), fontSize: AppDimens.sp13, fontWeight: FontWeight.w600),
    );
  }
}
