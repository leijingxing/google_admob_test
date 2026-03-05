import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/components/toast/toast_widget.dart';
import '../../core/constants/storage.dart';
import '../../core/http/result.dart';
import '../../core/utils/storage_util.dart';
import '../../core/utils/user_manager.dart';
import '../../data/repository/auth_repository.dart';
import '../../router/module_routes/home_routes.dart';

/// 登录页控制器，负责验证码与登录流程编排。
class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  static const _emptyCaptchaBase64 =
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=';

  /// [lastPressedAt] 用于处理返回键二次确认退出。
  DateTime? lastPressedAt;

  /// 用户名输入控制器。
  final TextEditingController usernameController = TextEditingController();

  /// 密码输入控制器。
  final TextEditingController passwordController = TextEditingController();

  /// 验证码输入控制器。
  final TextEditingController verifyCodeController = TextEditingController();

  /// 用户名焦点。
  final FocusNode usernameNode = FocusNode();

  /// 密码焦点。
  final FocusNode passwordNode = FocusNode();

  /// 验证码焦点。
  final FocusNode verifyCodeNode = FocusNode();

  /// 用户名是否聚焦。
  final userNameHasFocus = false.obs;

  /// 密码是否隐藏。
  final passwordObscure = true.obs;

  /// 是否记住密码。
  final rememberPwd = false.obs;

  /// 验证码图片 Base64（不含前缀）。
  final verifyCodeBase64 = _emptyCaptchaBase64.obs;

  /// 登录按钮加载态。
  final isClick = false.obs;

  String _state = '';
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    usernameController.text =
        StorageUtil.getString(StorageConstants.loginUsername) ?? '';
    passwordController.text =
        StorageUtil.getString(StorageConstants.loginPassword) ?? '';
    rememberPwd.value =
        StorageUtil.getBool(StorageConstants.rememberLoginCredential) ?? false;
    if (!rememberPwd.value) {
      usernameController.clear();
      passwordController.clear();
    }
    usernameNode.addListener(_focusUserNameListener);
  }

  @override
  void onReady() {
    super.onReady();
    if (UserManager.isLogin) {
      goHome();
      return;
    }
    getVerifyCode();
  }

  @override
  void onClose() {
    _isDisposed = true;
    usernameNode.removeListener(_focusUserNameListener);
    usernameController.dispose();
    passwordController.dispose();
    verifyCodeController.dispose();
    usernameNode.dispose();
    passwordNode.dispose();
    verifyCodeNode.dispose();
    super.onClose();
  }

  void _focusUserNameListener() {
    if (_isDisposed || isClosed) return;
    userNameHasFocus.value = usernameNode.hasFocus;
  }

  /// 切换密码显示状态。
  void togglePasswordVisible() {
    passwordObscure.value = !passwordObscure.value;
  }

  /// 记住密码开关。
  Future<void> onRememberPwdChanged(bool value) async {
    rememberPwd.value = value;
    await StorageUtil.setBool(StorageConstants.rememberLoginCredential, value);
    if (!value) {
      await StorageUtil.remove(StorageConstants.loginUsername);
      await StorageUtil.remove(StorageConstants.loginPassword);
    }
  }

  /// 判断是否允许退出页面（双击返回退出）。
  bool isPopPage() {
    if (lastPressedAt == null) return false;
    return DateTime.now().difference(lastPressedAt!) <=
        const Duration(seconds: 1);
  }

  /// 获取验证码。
  Future<void> getVerifyCode() async {
    final result = await _authRepository.getVerifyCode();
    result.when(
      success: (verifyData) {
        final base64 = verifyData['captcha']?.toString() ?? '';
        verifyCodeBase64.value = base64.contains(',')
            ? base64.split(',').last
            : (base64.isEmpty ? _emptyCaptchaBase64 : base64);
        _state = verifyData['state']?.toString() ?? '';
      },
      failure: (error) {
        verifyCodeBase64.value = _emptyCaptchaBase64;
        AppToast.showError(error.message);
      },
    );
  }

  /// 刷新验证码。
  void refreshVerifyCode() {
    verifyCodeController.clear();
    getVerifyCode();
  }

  /// 执行登录链路。
  Future<void> loginDo() async {
    if (isClick.value) {
      AppToast.showWarning('登录处理中，请勿重复提交');
      return;
    }

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final verifyCode = verifyCodeController.text.trim();
    if (username.isEmpty) {
      AppToast.showError('请输入用户名');
      return;
    }
    if (password.isEmpty) {
      AppToast.showError('请输入密码');
      return;
    }
    if (verifyCode.isEmpty) {
      AppToast.showError('请输入验证码');
      return;
    }

    isClick.value = true;
    try {
      final authorizationUrl = await _authRepository.getAuthorizationUrl();
      final code = await _authRepository.proxyLogin(
        state: _state,
        authorizationUrl: authorizationUrl,
        captcha: verifyCode,
        username: username,
        password: password,
      );
      final token = await _authRepository.getAccessToken(code);
      await UserManager.saveToken('Bearer $token');

      if (rememberPwd.value) {
        await StorageUtil.setString(StorageConstants.loginUsername, username);
        await StorageUtil.setString(StorageConstants.loginPassword, password);
      } else {
        await StorageUtil.remove(StorageConstants.loginUsername);
        await StorageUtil.remove(StorageConstants.loginPassword);
      }
      if (_isDisposed || isClosed) return;
      await HomeRoutes.offAll();
    } catch (error) {
      refreshVerifyCode();
      AppToast.showError(_mapLoginError(error).message);
    } finally {
      if (!_isDisposed && !isClosed) {
        isClick.value = false;
      }
    }
  }

  /// 登录后跳转首页。
  void goHome() {
    HomeRoutes.offAll();
  }

  /// 统一映射登录链路中的异常为 [AppError]。
  AppError _mapLoginError(Object error) {
    if (error is AppError) return error;
    return AppError(
      code: -1,
      message: error.toString().replaceFirst('Exception: ', ''),
    );
  }
}
