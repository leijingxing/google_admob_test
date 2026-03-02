import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/dimens.dart';

/// 显示加载状态的 Widget，用于提示用户当前操作正在进行中。
///
/// [title] 用于提供加载时的描述文本；[fullPage] 决定是否覆盖整屏，[height] 仅在全屏模式下生效。
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    required this.title,
    super.key,
    this.fullPage = true,
    this.height,
  });

  /// 显示的标题
  final String title;

  /// 是否覆盖整页
  final bool fullPage;

  /// 设置高度
  final double? height;

  @override
  Widget build(BuildContext context) {
    final Widget widget = SizedBox(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: AppDimens.dp14,
              ),
            ),
            SizedBox(height: AppDimens.dp20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );

    return fullPage
        ? Container(
            constraints: BoxConstraints.expand(height: height),
            child: Center(child: widget),
          )
        : Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.dp20),
            ),
            color: AppColors.textPrimary,
            child: Container(
              alignment: Alignment.center,
              width: AppDimens.dp200,
              height: AppDimens.dp200,
              child: widget,
            ),
          );
  }
}
