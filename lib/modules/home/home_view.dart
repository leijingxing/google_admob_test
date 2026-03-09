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
          backgroundColor: AppColors.background,
          body: IndexedStack(
            index: logic.currentIndex,
            children: const [DashboardView(), MessageView(), ProfileView()],
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.navShadow,
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: NavigationBarTheme(
                    data: NavigationBarThemeData(
                      height: 64,
                      backgroundColor: AppColors.surface,
                      indicatorColor: AppColors.primary.withValues(alpha: 0.14),
                      labelTextStyle: WidgetStateProperty.resolveWith((states) {
                        final isSelected = states.contains(WidgetState.selected);
                        return TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? AppColors.primary : AppColors.navUnselected,
                        );
                      }),
                      iconTheme: WidgetStateProperty.resolveWith((states) {
                        final isSelected = states.contains(WidgetState.selected);
                        return IconThemeData(
                          size: 24,
                          color: isSelected ? AppColors.primary : AppColors.navUnselected,
                        );
                      }),
                    ),
                    child: NavigationBar(
                      selectedIndex: logic.currentIndex,
                      onDestinationSelected: logic.switchTab,
                      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(Icons.home_rounded),
                          selectedIcon: Icon(Icons.home_filled),
                          label: '主页',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.chat_bubble_outline_rounded),
                          selectedIcon: Icon(Icons.forum_rounded),
                          label: '消息',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.person_outline_rounded),
                          selectedIcon: Icon(Icons.account_circle_rounded),
                          label: '个人',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
