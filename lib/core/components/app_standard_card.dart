import 'package:flutter/material.dart';

import '../constants/dimens.dart';

/// 统一业务卡片容器，供各页面复用。
class AppStandardCard extends StatelessWidget {
  const AppStandardCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor = Colors.white,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? EdgeInsets.all(AppDimens.dp12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: const Color(0xFFE3E9F2), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120E1A2B),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
          BoxShadow(
            color: Color(0x0D0E1A2B),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}
