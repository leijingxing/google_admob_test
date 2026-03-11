import 'dart:convert';

import 'package:get/get.dart';

import '../../data/models/auth/login_entity.dart';
import '../../router/module_routes/auth_routes.dart';
import '../constants/storage.dart';
import 'storage_util.dart';

/// [功能]: 管理用户登录态（token）与用户信息缓存。
class UserManager {
  UserManager._();

  static final Rxn<LoginEntity> _userProfile = Rxn<LoginEntity>();
  static String? _token;
  static String? _identityType;

  /// 当前 token。
  static String? get token => _token;

  /// 当前用户信息。
  static LoginEntity? get user => _userProfile.value;

  /// 当前登录人身份类型。
  static String? get identityType => _identityType;

  /// 是否园区用户。
  static bool get isParkUser => (_identityType ?? '').trim() == 'park';

  /// 是否企业用户。
  static bool get isCompanyUser => (_identityType ?? '').trim() == 'company';

  /// 用户信息响应式流。
  static Rxn<LoginEntity> get userProfileStream => _userProfile;

  /// 是否已登录（兼容现有逻辑：仅依据 token）。
  static bool get isLogin => (_token ?? '').isNotEmpty;

  /// 更严格的登录态判断（token + 用户信息）。
  static bool get isLoggedIn =>
      (_token ?? '').isNotEmpty && _userProfile.value != null;

  /// 启动时恢复本地登录态。
  static Future<void> init() async {
    _token = StorageUtil.getString(StorageConstants.token);
    _identityType = StorageUtil.getString(StorageConstants.identityType);
    final profileJson = StorageUtil.getString(StorageConstants.userProfile);
    if (profileJson == null || profileJson.isEmpty) return;
    try {
      final decoded = jsonDecode(profileJson);
      if (decoded is Map<String, dynamic>) {
        _userProfile.value = LoginEntity.fromJson(decoded);
      } else if (decoded is Map) {
        _userProfile.value = LoginEntity.fromJson(
          Map<String, dynamic>.from(decoded),
        );
      }
    } catch (_) {
      await clearAll();
    }
  }

  /// 保存 token 到内存与本地存储。
  static Future<void> saveToken(String value, {bool isSave = true}) async {
    _token = value;
    if (!isSave) return;
    await StorageUtil.setString(StorageConstants.token, value);
  }

  /// 保存用户身份类型到内存与本地存储。
  static Future<void> saveIdentityType(
    String? value, {
    bool isSave = true,
  }) async {
    _identityType = value?.trim();
    if (!isSave) return;
    if ((_identityType ?? '').isEmpty) {
      await StorageUtil.remove(StorageConstants.identityType);
      return;
    }
    await StorageUtil.setString(StorageConstants.identityType, _identityType!);
  }

  /// 保存用户信息到内存与本地存储。
  static Future<void> saveUser(LoginEntity value, {bool isSave = true}) async {
    _userProfile.value = value;
    if (!isSave) return;
    await StorageUtil.setString(
      StorageConstants.userProfile,
      jsonEncode(value.toJson()),
    );
  }

  /// 仅清除 token。
  static Future<void> removeToken() async {
    _token = null;
    await StorageUtil.remove(StorageConstants.token);
  }

  /// 清除所有用户态数据。
  static Future<void> clearAll() async {
    _token = null;
    _identityType = null;
    _userProfile.value = null;
    await StorageUtil.remove(StorageConstants.token);
    await StorageUtil.remove(StorageConstants.userProfile);
    await StorageUtil.remove(StorageConstants.identityType);
  }

  /// 清理登录态并回到登录页。
  static Future<void> logout() async {
    await clearAll();
    await AuthRoutes.offAll();
  }
}
