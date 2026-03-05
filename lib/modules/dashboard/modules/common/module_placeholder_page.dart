import 'package:flutter/material.dart';

import '../../../../core/constants/dimens.dart';

/// 模块页面占位组件（等待接入真实数据）。
class ModulePlaceholderPage extends StatelessWidget {
  const ModulePlaceholderPage({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppDimens.dp16),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDimens.dp16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimens.dp16),
              border: Border.all(color: const Color(0xFFE2EAF6)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.inbox_rounded,
                  size: AppDimens.dp40,
                  color: const Color(0xFF6D8098),
                ),
                SizedBox(height: AppDimens.dp12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppDimens.sp16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF23364D),
                  ),
                ),
                SizedBox(height: AppDimens.dp6),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDimens.sp12,
                    color: const Color(0xFF6D8098),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
