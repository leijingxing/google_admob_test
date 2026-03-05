/// 持久化存储的 key 常量，统一管理避免硬编码。
abstract class StorageConstants {
  /// 首次打开标记。
  static const firstOpen = 'first_open';

  /// 用户 token。
  static const token = 'token';

  /// 登录页是否记住密码。
  static const rememberLoginCredential = 'remember_login_credential';

  /// 登录页缓存用户名。
  static const loginUsername = 'login_username';

  /// 登录页缓存密码。
  static const loginPassword = 'login_password';
}
