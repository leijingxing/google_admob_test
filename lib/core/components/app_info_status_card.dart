import 'package:flutter/material.dart';

import '../constants/dimens.dart';
import 'app_standard_card.dart';

/// 通用信息状态卡片：标题 + 右上状态 + 内容区 + 可选右侧操作
class AppInfoStatusCard extends StatelessWidget {
  const AppInfoStatusCard({
    super.key,
    required this.title,
    required this.statusText,
    required this.statusStyle,
    required this.body,
    this.trailingAction,
  });

  final String title;
  final String statusText;
  final AppCardStatusStyle statusStyle;
  final Widget body;
  final Widget? trailingAction;

  @override
  Widget build(BuildContext context) {
    return AppStandardCard(
      padding: EdgeInsets.all(AppDimens.dp12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF2F3134),
                    fontSize: AppDimens.sp20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.dp8,
                  vertical: AppDimens.dp3,
                ),
                decoration: BoxDecoration(
                  color: statusStyle.backgroundColor,
                  border: Border.all(color: statusStyle.borderColor),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusStyle.textColor,
                    fontSize: AppDimens.sp12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp8),
          Container(height: 1, color: const Color(0xFFEFF3F8)),
          SizedBox(height: AppDimens.dp8),
          body,
          if (trailingAction != null) ...[
            SizedBox(height: AppDimens.dp8),
            Align(alignment: Alignment.centerRight, child: trailingAction),
          ],
        ],
      ),
    );
  }
}

class AppCardStatusStyle {
  const AppCardStatusStyle({
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
}
