import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../dashboard/dashboard_view.dart';
import '../profile/profile_view.dart';
import '../refresh_test/refresh_test_view.dart';
import 'home_controller.dart';

/// 首页：底部 Tab（主页 / 消息 / 个人）。
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (logic) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F8FC),
          body: IndexedStack(
            index: logic.currentIndex,
            children: const [DashboardView(), RefreshTestView(), ProfileView()],
          ),
          bottomNavigationBar: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF103A6F).withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: BottomNavigationBar(
                currentIndex: logic.currentIndex,
                onTap: logic.switchTab,
                backgroundColor: Colors.white,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: const Color(0xFF8191A8),
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled),
                    activeIcon: Icon(Icons.home_filled),
                    label: '主页',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.forum_rounded),
                    activeIcon: Icon(Icons.forum_rounded),
                    label: '消息',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_rounded),
                    activeIcon: Icon(Icons.account_circle_rounded),
                    label: '个人',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
