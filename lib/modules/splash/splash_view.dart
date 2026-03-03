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
            colors: [Color(0xFFF3F8FF), Color(0xFFEAF2FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimens.dp16),
                child: SizedBox(
                  width: AppDimens.dp92,
                  height: AppDimens.dp92,
                  child: Assets.appLogo.image(fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: AppDimens.dp18),
              Text(
                '正在初始化...',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppDimens.sp12,
                ),
              ),
              SizedBox(height: AppDimens.dp8),
              SizedBox(
                width: AppDimens.dp18,
                height: AppDimens.dp18,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1F5FAE)),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
