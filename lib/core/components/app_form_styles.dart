import 'package:flutter/material.dart';

import '../constants/dimens.dart';

/// 表单样式统一入口。
///
/// 用于沉淀项目内输入框、下拉框等表单组件的边框、颜色和装饰配置，
/// 避免业务页面重复定义样式，保证交互外观一致。
class AppFormStyles {
  /// 常规输入态边框颜色。
  static const Color borderColor = Color(0xFFD7DFEB);

  /// 聚焦态边框颜色。
  static const Color focusedBorderColor = Color(0xFF1F7BFF);

  /// 提示文案颜色。
  static const Color hintColor = Color(0xFF9AA6B2);

  /// 输入文案颜色。
  static const Color textColor = Color(0xFF2B3A4F);

  /// 可编辑态背景色。
  static const Color fillColor = Colors.white;

  /// 禁用态边框颜色。
  static const Color disabledBorderColor = Color(0xFFE3EAF4);

  /// 禁用态文本颜色。
  static const Color disabledTextColor = Color(0xFF7E8A9A);

  /// 禁用态提示文案颜色。
  static const Color disabledHintColor = Color(0xFFAEB9C7);

  /// 禁用态背景色。
  static const Color disabledFillColor = Color(0xFFF3F6FA);

  /// 下拉菜单背景色。
  static const Color dropdownBackgroundColor = Colors.white;

  /// 下拉菜单最大高度。
  static const double dropdownMenuMaxHeight = 320;

  /// 通用输入框圆角。
  static BorderRadius get borderRadius => BorderRadius.circular(AppDimens.dp10);

  /// 下拉菜单圆角。
  static BorderRadius get dropdownBorderRadius =>
      BorderRadius.circular(AppDimens.dp16);

  /// 构建统一描边边框。
  static OutlineInputBorder outlineBorder({Color? color, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: color ?? borderColor, width: width),
    );
  }

  /// 输入框文本样式。
  static TextStyle inputTextStyle({bool enabled = true}) {
    return TextStyle(
      fontSize: AppDimens.sp14,
      color: enabled ? textColor : disabledTextColor,
      fontWeight: FontWeight.w500,
    );
  }

  /// 输入框装饰配置。
  static InputDecoration inputDecoration({
    String? hintText,
    Widget? suffixIcon,
    Widget? prefixIcon,
    bool filled = true,
    bool enabled = true,
    bool isCollapsed = false,
    EdgeInsetsGeometry? contentPadding,
  }) {
    final effectiveBorderColor = enabled ? borderColor : disabledBorderColor;
    final effectiveHintColor = enabled ? hintColor : disabledHintColor;
    final effectiveFillColor = enabled ? fillColor : disabledFillColor;

    return InputDecoration(
      hintText: hintText,
      isCollapsed: isCollapsed,
      hintStyle: TextStyle(
        fontSize: AppDimens.sp13,
        color: effectiveHintColor,
        fontWeight: FontWeight.w500,
      ),
      filled: filled,
      fillColor: filled ? effectiveFillColor : null,
      contentPadding:
          contentPadding ??
          EdgeInsets.symmetric(
            horizontal: AppDimens.dp12,
            vertical: AppDimens.dp12,
          ),
      border: outlineBorder(color: effectiveBorderColor),
      enabledBorder: outlineBorder(color: effectiveBorderColor),
      focusedBorder: enabled
          ? outlineBorder(color: focusedBorderColor, width: 1.2)
          : outlineBorder(color: effectiveBorderColor),
      disabledBorder: outlineBorder(color: disabledBorderColor),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
    );
  }

  /// 可编辑输入框装饰。
  static InputDecoration editableInputDecoration({
    String? hintText,
    Widget? suffixIcon,
    Widget? prefixIcon,
    bool filled = true,
  }) {
    return inputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      filled: filled,
      enabled: true,
    );
  }

  /// 只读输入框装饰。
  static InputDecoration readOnlyInputDecoration({
    String? hintText,
    Widget? suffixIcon,
    Widget? prefixIcon,
    bool filled = true,
  }) {
    return inputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      filled: filled,
      enabled: false,
    );
  }

  /// 统一判断字段是否可编辑。
  static bool isEditable(bool? enabled, bool readOnly) {
    return (enabled ?? true) && !readOnly;
  }
}

class AppDropdownOptionLabel extends StatelessWidget {
  const AppDropdownOptionLabel({
    super.key,
    required this.text,
    this.textColor = const Color(0xFF223146),
    this.backgroundColor = const Color(0xFFF3F6FB),
    this.borderColor = const Color(0xFFE0E7F1),
  });

  final String text;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp10,
        vertical: AppDimens.dp6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: AppDimens.sp12,
          fontWeight: FontWeight.w700,
        ),
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
        style: TextStyle(
          color: const Color(0xFF223146),
          fontSize: AppDimens.sp13,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
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
      style: TextStyle(
        color: const Color(0xFF223146),
        fontSize: AppDimens.sp13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
