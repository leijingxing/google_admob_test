import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/dimens.dart';
import '../../data/models/auth/login_entity.dart';
import '../../../core/utils/user_manager.dart';

/// 个人页控制器。
class ProfileController extends GetxController {
  Worker? _profileWorker;

  /// 当前登录用户信息。
  LoginEntity? get profile => UserManager.user;

  @override
  void onInit() {
    super.onInit();
    _profileWorker = ever<LoginEntity?>(
      UserManager.userProfileStream,
      (_) => update(),
    );
  }

  @override
  void onClose() {
    _profileWorker?.dispose();
    super.onClose();
  }

  /// 退出登录（带二次确认）。
  Future<void> logout() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp16)),
        title: Text(
          '温馨提示',
          style: TextStyle(fontSize: AppDimens.sp18, fontWeight: FontWeight.bold),
        ),
        content: Text(
          '确定要退出当前账号吗？',
          style: TextStyle(fontSize: AppDimens.sp15),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              '取消',
              style: TextStyle(color: const Color(0xFF6B7E9E), fontSize: AppDimens.sp14),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              '确认退出',
              style: TextStyle(color: const Color(0xFFE55252), fontSize: AppDimens.sp14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      await UserManager.logout();
    }
  }
}
