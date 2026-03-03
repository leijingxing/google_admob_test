import 'package:get/get.dart';

import '../../../core/utils/user_manager.dart';

/// 个人页控制器。
class ProfileController extends GetxController {
  final UserProfile profile = const UserProfile(
    name: '张三',
    account: 'zhangsan',
    phone: '138****1234',
    email: 'zhangsan@example.com',
    dept: '研发中心',
    role: 'Flutter 开发工程师',
  );

  /// 退出登录。
  Future<void> logout() async {
    await UserManager.logout();
  }
}

/// 个人信息展示模型（静态假数据）。
class UserProfile {
  final String name;
  final String account;
  final String phone;
  final String email;
  final String dept;
  final String role;

  const UserProfile({
    required this.name,
    required this.account,
    required this.phone,
    required this.email,
    required this.dept,
    required this.role,
  });
}
