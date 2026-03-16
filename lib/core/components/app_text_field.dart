import 'package:flutter/material.dart';

import '../constants/dimens.dart';
import 'app_form_styles.dart';

/// 项目统一输入框。
///
/// 当前先提供通用构建能力和紧凑搜索态，便于业务页面逐步收口样式。
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.height,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.style,
    this.decoration,
  }) : _useSearchStyle = false,
       _onSearch = null;

  AppTextField.search({
    super.key,
    this.controller,
    this.hintText,
    this.textInputAction = TextInputAction.search,
    this.onSubmitted,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    VoidCallback? onSearch,
  }) : height = AppDimens.dp34,
       maxLines = 1,
       style = null,
       decoration = null,
       _useSearchStyle = true,
       _onSearch = onSearch;

  final TextEditingController? controller;
  final String? hintText;
  final double? height;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int maxLines;
  final TextStyle? style;
  final InputDecoration? decoration;
  final bool _useSearchStyle;
  final VoidCallback? _onSearch;

  @override
  Widget build(BuildContext context) {
    final Widget field = TextField(
      controller: controller,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      maxLines: maxLines,
      style: style ?? AppFormStyles.inputTextStyle(enabled: enabled),
      decoration: decoration ?? _buildDecoration(),
    );

    if (height == null) {
      return field;
    }

    return SizedBox(height: height, child: field);
  }

  InputDecoration _buildDecoration() {
    if (!_useSearchStyle) {
      return AppFormStyles.inputDecoration(hintText: hintText);
    }

    return AppFormStyles.inputDecoration(
      hintText: hintText,
      filled: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp10,
        vertical: AppDimens.dp8,
      ),
      suffixIcon: _SearchActionButton(onPressed: _onSearch),
    ).copyWith(
      hintStyle: TextStyle(
        color: const Color(0xFF9AA2AE),
        fontSize: AppDimens.sp12,
        fontWeight: FontWeight.w500,
      ),
      fillColor: const Color(0xFFF6F8FC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.dp4),
        borderSide: const BorderSide(color: Color(0xFFDADDE3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.dp4),
        borderSide: const BorderSide(color: Color(0xFFDADDE3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.dp4),
        borderSide: const BorderSide(color: Color(0xFF1F7BFF)),
      ),
      suffixIconConstraints: BoxConstraints(
        minWidth: AppDimens.dp40,
        minHeight: AppDimens.dp34,
      ),
    );
  }
}

class _SearchActionButton extends StatelessWidget {
  const _SearchActionButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: AppDimens.dp4,
        right: AppDimens.dp4,
        bottom: AppDimens.dp4,
      ),
      child: Material(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(AppDimens.dp24),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimens.dp8),
          onTap: onPressed,
          child: SizedBox(
            width: AppDimens.dp26,
            child: const Icon(
              Icons.search_rounded,
              size: 18,
              color: Color(0xFF2D6AE3),
            ),
          ),
        ),
      ),
    );
  }
}
