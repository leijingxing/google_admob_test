import 'package:flutter/material.dart';

import '../constants/dimens.dart';

/// 通用滑动 TabBar（胶囊风格）
class CustomSlidingTabBar extends StatelessWidget {
  const CustomSlidingTabBar({
    super.key,
    required this.labels,
    required this.currentIndex,
    required this.onChanged,
    this.isScrollable = true,
    this.adaptive = true,
    this.controller,
  });

  final List<String> labels;
  final int currentIndex;
  final ValueChanged<int> onChanged;
  final bool isScrollable;
  final bool adaptive;
  final TabController? controller;

  @override
  Widget build(BuildContext context) {
    final tabBar = _buildTabBar();
    if (controller != null) {
      return tabBar;
    }
    return DefaultTabController(
      key: ValueKey('custom-sliding-tab-$currentIndex'),
      length: labels.length,
      initialIndex: currentIndex,
      child: tabBar,
    );
  }

  Widget _buildTabBar() {
    final effectiveScrollable = adaptive ? labels.length > 3 : isScrollable;

    return Container(
      height: AppDimens.dp34,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp8),
        border: Border.all(color: const Color(0xFF3A78F2), width: 1),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: effectiveScrollable,
        tabAlignment: effectiveScrollable
            ? TabAlignment.center
            : TabAlignment.fill,
        dividerColor: Colors.transparent,
        labelPadding: EdgeInsets.symmetric(horizontal: AppDimens.dp12),
        indicator: BoxDecoration(
          color: const Color(0xFF3A78F2),
          borderRadius: BorderRadius.circular(AppDimens.dp6),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF3A78F2),
        labelStyle: TextStyle(
          fontSize: AppDimens.sp12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: AppDimens.sp12,
          fontWeight: FontWeight.w600,
        ),
        onTap: onChanged,
        tabs: labels.map((label) => Tab(text: label)).toList(),
      ),
    );
  }
}
