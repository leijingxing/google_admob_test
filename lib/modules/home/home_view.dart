import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../dashboard/dashboard_view.dart';
import '../profile/profile_view.dart';
import 'home_controller.dart';

/// 首页：底部 Tab（主页 / 个人）。
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
            children: const [DashboardView(), ProfileView()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: logic.currentIndex,
            onTap: logic.switchTab,
            selectedItemColor: AppColors.primary,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: '主页',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: '个人',
              ),
            ],
          ),
        );
      },
    );
  }
}
