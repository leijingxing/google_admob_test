import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/dimens.dart';
import 'task_progress_detail_controller.dart';

/// 工作台任务详情页。
class TaskProgressDetailView extends GetView<TaskProgressDetailController> {
  const TaskProgressDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(title: const Text('任务详情')),
      body: GetBuilder<TaskProgressDetailController>(
        builder: (controller) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.only(
                  left: AppDimens.dp12,
                  right: AppDimens.dp12,
                  top: AppDimens.dp10,
                  bottom: AppDimens.dp8,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(controller.tabs.length, (index) {
                      final isSelected = index == controller.currentIndex;
                      return Padding(
                        padding: EdgeInsets.only(right: AppDimens.dp8),
                        child: _TaskTabChip(
                          title: controller.tabs[index],
                          isSelected: isSelected,
                          onTap: () => controller.switchTab(index),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppDimens.dp16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CurrentTabBanner(title: controller.currentTitle),
                      SizedBox(height: AppDimens.dp16),
                      _PlaceholderPanel(title: controller.currentTitle),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TaskTabChip extends StatelessWidget {
  const _TaskTabChip({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.dp10),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.dp14,
            vertical: AppDimens.dp10,
          ),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEAF2FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimens.dp10),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF2F6BFF)
                  : const Color(0xFFDCE5F2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.work_outline_rounded,
                size: AppDimens.dp16,
                color: isSelected
                    ? const Color(0xFF2F6BFF)
                    : const Color(0xFF6B7F97),
              ),
              SizedBox(width: AppDimens.dp6),
              Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF2F6BFF)
                      : const Color(0xFF445A73),
                  fontSize: AppDimens.sp12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrentTabBanner extends StatelessWidget {
  const _CurrentTabBanner({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2F6BFF), Color(0xFF5A92FF)],
        ),
        borderRadius: BorderRadius.circular(AppDimens.dp16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F6BFF).withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppDimens.sp18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '当前页面先完成顶部 Tab 切换结构，后续再接入列表与处理数据。',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.86),
              fontSize: AppDimens.sp11,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderPanel extends StatelessWidget {
  const _PlaceholderPanel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp16),
        border: Border.all(color: const Color(0xFFE3EBF5)),
      ),
      child: Column(
        children: [
          Container(
            width: AppDimens.dp60,
            height: AppDimens.dp60,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(AppDimens.dp18),
            ),
            child: const Icon(
              Icons.dashboard_customize_rounded,
              color: Color(0xFF2F6BFF),
              size: 30,
            ),
          ),
          SizedBox(height: AppDimens.dp12),
          Text(
            '$title 页面内容建设中',
            style: TextStyle(
              color: const Color(0xFF21364E),
              fontSize: AppDimens.sp15,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '当前仅实现顶部 Tab 切换与页面骨架，列表、筛选和操作区后续再补。',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF70839A),
              fontSize: AppDimens.sp11,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
