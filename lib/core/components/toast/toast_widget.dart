// ignore_for_file: implementation_imports

import 'package:bot_toast/bot_toast.dart';
import 'package:bot_toast/src/toast_widget/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/dimens.dart';

/// @Description: 封装 toast，方便后期统一修改样式
///
/// 提供 [show], [showInfo], [showSuccess], [showError], [showWarning] 等方法。
class AppToast extends StatelessWidget {
  /// AppToast 构造函数
  const AppToast({
    required this.text,
    required this.cancelFunc,
    super.key,
    this.title,
    this.icon,
    this.iconColor,
    this.actionText,
    this.onActionClick,
  });

  /// 图标
  final IconData? icon;

  /// 图标颜色
  final Color? iconColor;

  /// 提示内容
  final String text;

  /// 提示标题
  final String? title;

  /// 可操作按钮文案
  final String? actionText;

  /// 可操作按钮点击回调
  final VoidCallback? onActionClick;

  /// BotToast 关闭函数
  final void Function() cancelFunc;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.dp10),
      ),
      margin: EdgeInsets.symmetric(horizontal: AppDimens.dp8),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: AppDimens.dp56),
        child: Padding(
          padding: EdgeInsets.all(AppDimens.dp18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildIcon(),
              _buildTitleContent(),
              _buildAction(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (icon == null) {
      return const SizedBox.shrink();
    }
    return Icon(
      icon,
      size: AppDimens.dp24,
      color: iconColor ?? AppColors.primary,
    ).marginOnly(right: AppDimens.dp8);
  }

  Widget _buildTitleContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (title != null)
            Padding(
              padding: EdgeInsets.only(bottom: AppDimens.dp2),
              child: Text(
                title!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction() {
    if (actionText == null) {
      return const SizedBox.shrink();
    }
    return TextButton(
      onPressed: () {
        cancelFunc.call();
        onActionClick?.call();
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: AppDimens.dp8,
          horizontal: AppDimens.dp16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.dp8),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      child: Text(
        actionText!,
        style: const TextStyle(fontSize: 14, color: AppColors.primary),
      ),
    ).marginOnly(left: AppDimens.dp8);
  }

  /// 显示一个自定义 Toast
  static void show(
    String text, {
    String? title,
    Duration? duration = const Duration(seconds: 2),
    IconData? icon,
    Color? iconColor,
    String? actionText,
    VoidCallback? onActionClick,
    VoidCallback? onClose,
    bool crossPage = true,
    Alignment alignment = const Alignment(0, -0.9),
  }) {
    if (text.isEmpty) return;
    BotToast.showCustomNotification(
      crossPage: crossPage,
      onClose: onClose,
      dismissDirections: const [
        DismissDirection.horizontal,
        DismissDirection.down,
      ],
      duration: duration,
      wrapToastAnimation: textAnimation,
      align: alignment,
      toastBuilder: (void Function() cancelFunc) {
        return AppToast(
          text: text,
          title: title,
          icon: icon,
          iconColor: iconColor,
          actionText: actionText,
          onActionClick: onActionClick,
          cancelFunc: cancelFunc,
        );
      },
    );
  }

  /// 显示信息类型 Toast
  static void showInfo(
    String text, {
    String? title,
    Duration? duration = const Duration(seconds: 2),
    String? actionText,
    VoidCallback? onActionClick,
    VoidCallback? onClose,
    bool crossPage = true,
    Alignment alignment = const Alignment(0, -0.9),
  }) {
    return show(
      text,
      title: title,
      duration: duration,
      icon: Icons.info_outline,
      iconColor: AppColors.meaning_color_info,
      actionText: actionText,
      onActionClick: onActionClick,
      onClose: onClose,
      crossPage: crossPage,
      alignment: alignment,
    );
  }

  /// 显示错误类型 Toast
  static void showError(
    String text, {
    String? title,
    Duration? duration = const Duration(seconds: 2),
    String? actionText,
    VoidCallback? onActionClick,
    VoidCallback? onClose,
    bool crossPage = true,
    Alignment alignment = const Alignment(0, -0.9),
  }) {
    return show(
      text,
      title: title,
      duration: duration,
      icon: Icons.error_outline,
      iconColor: AppColors.meaning_color_danger,
      actionText: actionText,
      onActionClick: onActionClick,
      onClose: onClose,
      crossPage: crossPage,
      alignment: alignment,
    );
  }

  /// 显示成功类型 Toast
  static void showSuccess(
    String text, {
    String? title,
    Duration? duration = const Duration(seconds: 2),
    String? actionText,
    VoidCallback? onActionClick,
    VoidCallback? onClose,
    bool crossPage = true,
    Alignment alignment = const Alignment(0, -0.9),
  }) {
    return show(
      text,
      title: title,
      duration: duration,
      icon: Icons.check_circle_outline,
      iconColor: AppColors.meaning_color_success,
      actionText: actionText,
      onActionClick: onActionClick,
      onClose: onClose,
      crossPage: crossPage,
      alignment: alignment,
    );
  }

  /// 显示警告类型 Toast
  static void showWarning(
    String text, {
    String? title,
    Duration? duration = const Duration(seconds: 2),
    String? actionText,
    VoidCallback? onActionClick,
    VoidCallback? onClose,
    bool crossPage = true,
    Alignment alignment = const Alignment(0, -0.9),
  }) {
    return show(
      text,
      title: title,
      duration: duration,
      icon: Icons.warning_amber_rounded,
      iconColor: AppColors.meaning_color_warning,
      actionText: actionText,
      onActionClick: onActionClick,
      onClose: onClose,
      crossPage: crossPage,
      alignment: alignment,
    );
  }
}
