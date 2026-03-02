import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/dimens.dart';
import 'home_controller.dart';

/// 首页视图：面向开发者的框架接入指引页面。
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  /// 构建开发指引页主体布局。
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: AppBar(
        title: const Text('开发指引'),
        actions: [
          TextButton(onPressed: controller.logout, child: const Text('退出登录')),
        ],
      ),
      body: GetBuilder<HomeController>(
        builder: (logic) {
          return ListView(
            padding: EdgeInsets.fromLTRB(
              AppDimens.dp16,
              AppDimens.dp16,
              AppDimens.dp16,
              AppDimens.dp24,
            ),
            children: [
              _buildGuideBanner(logic),
              SizedBox(height: AppDimens.dp16),
              _buildSectionTitle('新增页面流程'),
              SizedBox(height: AppDimens.dp8),
              _buildStepSection(logic),
              SizedBox(height: AppDimens.dp16),
              _buildSectionTitle('开发规范清单'),
              SizedBox(height: AppDimens.dp8),
              _buildChecklistSection(logic),
              SizedBox(height: AppDimens.dp16),
              _buildSectionTitle('演示入口'),
              SizedBox(height: AppDimens.dp8),
              _buildDemoEntrySection(logic),
              SizedBox(height: AppDimens.dp16),
              _buildNextActionCard(),
            ],
          );
        },
      ),
    );
  }

  /// 顶部引导 Banner。
  Widget _buildGuideBanner(HomeController logic) {
    return Container(
      padding: EdgeInsets.all(AppDimens.dp16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F3A68), Color(0xFF1B5B9C)],
        ),
        borderRadius: BorderRadius.circular(AppDimens.dp14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF194C85).withValues(alpha: 0.25),
            blurRadius: AppDimens.dp20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            logic.guideTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppDimens.sp20,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp8),
          Text(
            logic.guideSubtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: AppDimens.sp12,
            ),
          ),
          SizedBox(height: AppDimens.dp12),
          Wrap(
            spacing: AppDimens.dp8,
            runSpacing: AppDimens.dp8,
            children: logic.guideTags
                .map(
                  (tag) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.dp10,
                      vertical: AppDimens.dp5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(AppDimens.dp20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppDimens.sp10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  /// 新增页面步骤列表。
  Widget _buildStepSection(HomeController logic) {
    return Column(
      children: logic.guideSteps
          .map(
            (step) => Padding(
              padding: EdgeInsets.only(bottom: AppDimens.dp10),
              child: _buildStepCard(step),
            ),
          )
          .toList(),
    );
  }

  /// 步骤卡片。
  Widget _buildStepCard(GuideStep step) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: const Color(0xFFE4EBF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppDimens.dp24,
                height: AppDimens.dp24,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppDimens.dp12),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${step.index}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppDimens.sp12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: AppDimens.dp8),
              Expanded(
                child: Text(
                  step.title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppDimens.sp16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp8),
          Text(
            step.desc,
            style: TextStyle(
              color: AppColors.textPrimary.withValues(alpha: 0.9),
              fontSize: AppDimens.sp12,
            ),
          ),
          SizedBox(height: AppDimens.dp8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.dp10,
              vertical: AppDimens.dp8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8ED),
              borderRadius: BorderRadius.circular(AppDimens.dp8),
              border: Border.all(color: const Color(0xFFF4E0BF)),
            ),
            child: Text(
              '注意：${step.warning}',
              style: TextStyle(
                color: const Color(0xFF9C5E10),
                fontSize: AppDimens.sp10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 规范清单区域。
  Widget _buildChecklistSection(HomeController logic) {
    return Column(
      children: logic.checklistGroups
          .map(
            (group) => Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: AppDimens.dp10),
              padding: EdgeInsets.all(AppDimens.dp14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimens.dp12),
                border: Border.all(color: const Color(0xFFE4EBF5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: AppDimens.sp14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: AppDimens.dp8),
                  ...group.items.map(_buildChecklistItem),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  /// 清单项。
  Widget _buildChecklistItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimens.dp8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppDimens.dp18,
            height: AppDimens.dp18,
            margin: EdgeInsets.only(top: AppDimens.dp2),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F2FF),
              borderRadius: BorderRadius.circular(AppDimens.dp9),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.check,
              size: AppDimens.dp12,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: AppDimens.dp8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: AppDimens.sp12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 演示入口区域。
  Widget _buildDemoEntrySection(HomeController logic) {
    return Column(
      children: logic.demoEntries
          .map(
            (entry) => Padding(
              padding: EdgeInsets.only(bottom: AppDimens.dp10),
              child: _buildDemoEntryCard(entry),
            ),
          )
          .toList(),
    );
  }

  /// 演示入口卡片。
  Widget _buildDemoEntryCard(GuideDemoEntry entry) {
    return InkWell(
      onTap: () => controller.onTapDemoEntry(entry),
      borderRadius: BorderRadius.circular(AppDimens.dp12),
      child: Ink(
        padding: EdgeInsets.all(AppDimens.dp14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.dp12),
          border: Border.all(color: const Color(0xFFE4EBF5)),
        ),
        child: Row(
          children: [
            Container(
              width: AppDimens.dp36,
              height: AppDimens.dp36,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F2FF),
                borderRadius: BorderRadius.circular(AppDimens.dp10),
              ),
              child: Icon(_iconByName(entry.icon), color: AppColors.primary),
            ),
            SizedBox(width: AppDimens.dp10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: AppDimens.sp14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: AppDimens.dp4),
                  Text(
                    entry.subtitle,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppDimens.sp12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppDimens.dp8),
            Text(
              entry.route,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppDimens.sp10,
              ),
            ),
            SizedBox(width: AppDimens.dp6),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: AppDimens.dp12,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  /// 底部下一步提示。
  Widget _buildNextActionCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: const Color(0xFFCADFFC)),
      ),
      child: Text(
        '下一步：复制一个模块作为模板，按上方 5 步完成页面接入与数据联调。',
        style: TextStyle(
          color: const Color(0xFF1B4E8A),
          fontSize: AppDimens.sp12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 区块标题。
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: AppDimens.sp16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  IconData _iconByName(String name) {
    switch (name) {
      case 'lock':
        return Icons.lock_outline_rounded;
      case 'rocket':
        return Icons.rocket_launch_outlined;
      case 'home':
      default:
        return Icons.home_outlined;
    }
  }
}
