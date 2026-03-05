import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/components/toast/toast_widget.dart';
import '../../core/constants/app_colors.dart';
import 'auth_controller.dart';

/// 登录页面。
class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: controller.isPopPage(),
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          controller.lastPressedAt = DateTime.now();
          AppToast.showWarning('再次点击，立即退出App');
          controller.update();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            _buildBackgroundDecor(),
            Positioned(
              left: 28.w,
              top: 70.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '欢迎使用',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Flutter 基础模板',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              top: 178.h,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFDFDFE), Color(0xFFEFF4FF)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.w),
                    topRight: Radius.circular(18.w),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D1B2A).withValues(alpha: 0.06),
                      blurRadius: 20.w,
                      offset: Offset(0, -6.w),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 24.h,
                  ),
                  child: Column(
                    children: [
                      _userNameInput(),
                      SizedBox(height: 20.h),
                      _passwordInput(),
                      SizedBox(height: 20.h),
                      _verifyCodeInput(),
                      SizedBox(height: 14.h),
                      _rememberPwd(),
                      SizedBox(height: 30.h),
                      _loginButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundDecor() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, Color(0xFF0AB6F5)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -60.w,
              left: -40.w,
              child: _softCircle(
                color: Colors.white.withValues(alpha: 0.15),
                size: 220.w,
              ),
            ),
            Positioned(
              bottom: -80.w,
              right: -30.w,
              child: _softCircle(
                color: Colors.white.withValues(alpha: 0.1),
                size: 190.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _softCircle({required Color color, required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: size * 0.35,
            spreadRadius: size * 0.08,
          ),
        ],
      ),
    );
  }

  Widget _userNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '用户名',
          style: TextStyle(
            color: const Color(0xFF000000),
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 10.h),
        Obx(
          () => TextField(
            focusNode: controller.usernameNode,
            controller: controller.usernameController,
            keyboardType: TextInputType.name,
            decoration: _inputDecoration(
              hintText: '请输入用户名',
              suffixIcon: controller.userNameHasFocus.value
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: controller.usernameController.clear,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '密码',
          style: TextStyle(
            color: const Color(0xFF000000),
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 10.h),
        Obx(
          () => TextField(
            focusNode: controller.passwordNode,
            controller: controller.passwordController,
            obscureText: controller.passwordObscure.value,
            keyboardType: TextInputType.visiblePassword,
            decoration: _inputDecoration(
              hintText: '请输入登录密码',
              suffixIcon: IconButton(
                icon: controller.passwordObscure.value
                    ? const Icon(Icons.visibility_off_outlined)
                    : const Icon(Icons.visibility_outlined),
                onPressed: controller.togglePasswordVisible,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _verifyCodeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '验证码',
          style: TextStyle(
            color: const Color(0xFF000000),
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 10.h),
        TextField(
          focusNode: controller.verifyCodeNode,
          controller: controller.verifyCodeController,
          keyboardType: TextInputType.number,
          decoration: _inputDecoration(
            hintText: '请输入验证码',
            suffixIcon: Obx(() {
              final code = controller.verifyCodeBase64.value;
              return GestureDetector(
                onTap: controller.refreshVerifyCode,
                child: Container(
                  width: 100.w,
                  height: 40.w,
                  margin: EdgeInsets.only(right: 10.w),
                  color: Colors.white,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Image.memory(
                      base64Decode(code),
                      key: ValueKey(code),
                      width: 100.w,
                      height: 40.w,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _rememberPwd() {
    return Row(
      children: [
        Obx(
          () => Checkbox(
            value: controller.rememberPwd.value,
            onChanged: (value) {
              controller.onRememberPwdChanged(value ?? false);
            },
            activeColor: const Color(0xFF3A78F2),
            checkColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.onRememberPwdChanged(!controller.rememberPwd.value);
          },
          child: Text(
            '记住密码',
            style: TextStyle(
              height: 1.2,
              color: const Color(0xFF4D5956),
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _loginButton() {
    return GestureDetector(
      onTap: controller.loginDo,
      child: RepaintBoundary(
        child: Obx(() {
          final loading = controller.isClick.value;
          return Container(
            width: double.infinity,
            height: 44.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF3A78F2),
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              child: loading
                  ? SizedBox(
                      key: const ValueKey('spinner'),
                      width: 24.w,
                      height: 24.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Color(0xFFF5F5F5)),
                      ),
                    )
                  : Text(
                      '登录',
                      key: const ValueKey('label'),
                      style: TextStyle(
                        color: const Color(0xFFF5F5F5),
                        fontSize: 17.sp,
                      ),
                    ),
            ),
          );
        }),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFC6CFE0), width: 1),
    );
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: const Color(0xFFA5BCDD),
        fontWeight: FontWeight.w400,
        fontSize: 14.sp,
      ),
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: Colors.blue, width: 1),
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
    );
  }
}
