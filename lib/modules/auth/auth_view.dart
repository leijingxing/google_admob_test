import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import 'auth_controller.dart';

/// 登录页视图。
class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  /// 构建账号密码登录表单。
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _AtmosphereBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: GetBuilder<AuthController>(
                  builder: (logic) {
                    return Container(
                      constraints: BoxConstraints(maxWidth: 300),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.96),
                            Colors.white.withValues(alpha: 0.9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF1C3760,
                            ).withValues(alpha: 0.2),
                            blurRadius: 36,
                            spreadRadius: -2,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Form(
                        key: logic.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBrandHeader(),
                            SizedBox(height: 18),
                            TextFormField(
                              enabled: !logic.isLoading,
                              controller: logic.usernameController,
                              textInputAction: TextInputAction.next,
                              validator: logic.validateUsername,
                              decoration: _inputDecoration(
                                label: '用户名',
                                hint: '请输入账号',
                                prefixIcon: Icons.person_outline,
                              ),
                            ),
                            SizedBox(height: 14),
                            TextFormField(
                              enabled: !logic.isLoading,
                              controller: logic.passwordController,
                              obscureText: !logic.passwordVisible,
                              textInputAction: TextInputAction.done,
                              validator: logic.validatePassword,
                              onFieldSubmitted: (_) => logic.onLogin(),
                              decoration: _inputDecoration(
                                label: '密码',
                                hint: '请输入密码',
                                prefixIcon: Icons.lock_outline,
                                suffixIcon: IconButton(
                                  onPressed: logic.togglePasswordVisible,
                                  icon: Icon(
                                    logic.passwordVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 22),
                            SizedBox(
                              width: double.infinity,
                              child: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 180),
                                tween: Tween<double>(
                                  begin: 1,
                                  end: logic.isLoading ? 0.985 : 1,
                                ),
                                builder: (context, scale, child) {
                                  return Transform.scale(
                                    scale: scale,
                                    child: child,
                                  );
                                },
                                child: FilledButton(
                                  onPressed: logic.isLoading
                                      ? null
                                      : logic.onLogin,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    disabledBackgroundColor: AppColors.primary
                                        .withValues(alpha: 0.7),
                                    elevation: 0,
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 220),
                                    switchInCurve: Curves.easeOut,
                                    switchOutCurve: Curves.easeIn,
                                    child: logic.isLoading
                                        ? Row(
                                            key: const ValueKey('loading'),
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    const CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                '登录中...',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            '进入系统',
                                            key: const ValueKey('idle'),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '提示：这是基础模板登录页，可直接替换为真实接口。',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.22),
                AppColors.primary.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.workspace_premium_outlined,
            color: AppColors.primary,
            size: 26,
          ),
        ),
        SizedBox(height: 14),
        Text(
          '欢迎登录',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Flutter 基础脚手架',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.75)),
    );
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(prefixIcon, size: 20),
      suffixIcon: suffixIcon,
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
      filled: true,
      fillColor: const Color(0xFFF9FBFF),
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    );
  }
}

class _AtmosphereBackground extends StatelessWidget {
  const _AtmosphereBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF113057), Color(0xFF1D4A85), Color(0xFF5A8BC8)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -50,
            child: _GlowCircle(
              size: 220,
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            bottom: -112,
            right: -80,
            child: _GlowCircle(
              size: 256,
              color: const Color(0xFF92C1FF).withValues(alpha: 0.24),
            ),
          ),
          Positioned(
            top: 128,
            right: 30,
            child: _GlowCircle(
              size: 100,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
