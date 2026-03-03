import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/dimens.dart';
import '../../generated/assets.gen.dart';
import 'splash_controller.dart';

/// 启动页视图。
class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3F8FF), Color(0xFFE7F0FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              SizedBox(
                width: AppDimens.dp92,
                height: AppDimens.dp92,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimens.dp16),
                  child: Assets.appLogo.image(fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: AppDimens.dp10),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.dp10,
                  vertical: AppDimens.dp6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppDimens.dp20),
                ),
                child: Text(
                  'Flutter Base',
                  style: TextStyle(
                    color: const Color(0xFF1F5FAE),
                    fontSize: AppDimens.sp12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                margin: EdgeInsets.only(bottom: AppDimens.dp24),
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.dp14,
                  vertical: AppDimens.dp10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppDimens.dp24),
                  border: Border.all(color: const Color(0xFFDDE7F6)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1F5FAE).withValues(alpha: 0.08),
                      blurRadius: AppDimens.dp10,
                      offset: Offset(0, AppDimens.dp4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: AppDimens.dp14,
                      height: AppDimens.dp14,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF1F5FAE),
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimens.dp8),
                    Text(
                      '正在初始化...',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppDimens.sp12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
