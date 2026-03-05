import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/dimens.dart';
import 'dashboard_controller.dart';

/// 首页 Tab 页面：5 个业务模块入口。
class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (logic) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF3F8FF), Color(0xFFEAF2FF)],
            ),
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppDimens.dp16,
                    AppDimens.dp56,
                    AppDimens.dp16,
                    AppDimens.dp20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _HomeHeroCard(),
                      SizedBox(height: AppDimens.dp12),
                      _SafetyTipsCard(items: logic.safetyTips),
                      SizedBox(height: AppDimens.dp12),
                      Text(
                        '业务模块',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppDimens.sp16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.dp16),
                sliver: SliverToBoxAdapter(
                  child: _ModuleGrid(
                    items: logic.modules,
                    onTap: logic.onTapModule,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeHeroCard extends StatelessWidget {
  const _HomeHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1D5FB2), Color(0xFF3B84DA)],
        ),
        borderRadius: BorderRadius.circular(AppDimens.dp16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D5FB2).withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '园区运行状态',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: AppDimens.sp12,
                  ),
                ),
                SizedBox(height: AppDimens.dp6),
                Text(
                  '今日运行平稳',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppDimens.sp20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppDimens.dp8),
                Text(
                  '可通过下方模块进入具体业务页面',
                  style: TextStyle(
                    color: const Color(0xFFDCEBFF),
                    fontSize: AppDimens.sp10,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: AppDimens.dp56,
            height: AppDimens.dp56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(AppDimens.dp14),
            ),
            child: Icon(
              Icons.health_and_safety_rounded,
              color: Colors.white,
              size: AppDimens.sp30,
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyTipsCard extends StatefulWidget {
  const _SafetyTipsCard({required this.items});

  final List<SafetyTipItem> items;

  @override
  State<_SafetyTipsCard> createState() => _SafetyTipsCardState();
}

class _SafetyTipsCardState extends State<_SafetyTipsCard> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.items.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (!mounted) return;
        final next = (_currentIndex + 1) % widget.items.length;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(AppDimens.dp12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp14),
        border: Border.all(color: const Color(0xFFE2EAF6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E2A49).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: AppDimens.dp20,
                height: AppDimens.dp20,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A78F2).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimens.dp6),
                ),
                child: Icon(
                  Icons.tips_and_updates_rounded,
                  color: const Color(0xFF3A78F2),
                  size: AppDimens.sp12,
                ),
              ),
              SizedBox(width: AppDimens.dp8),
              Text(
                '化工安全小贴士',
                style: TextStyle(
                  fontSize: AppDimens.sp14,
                  color: const Color(0xFF262626),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp10),
          SizedBox(
            height: AppDimens.dp88,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.items.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return _TipItem(item: item);
              },
            ),
          ),
          SizedBox(height: AppDimens.dp8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.items.length, (index) {
              final selected = index == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: EdgeInsets.symmetric(horizontal: AppDimens.dp2),
                width: selected ? AppDimens.dp14 : AppDimens.dp6,
                height: AppDimens.dp6,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF3A78F2)
                      : const Color(0xFFCFDAEA),
                  borderRadius: BorderRadius.circular(AppDimens.dp6),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  const _TipItem({required this.item});

  final SafetyTipItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FF),
        borderRadius: BorderRadius.circular(AppDimens.dp10),
        border: Border.all(color: const Color(0xFFE3ECFA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppDimens.sp12,
              color: const Color(0xFF25364D),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            item.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppDimens.sp10,
              color: const Color(0xFF60758F),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleGrid extends StatelessWidget {
  const _ModuleGrid({required this.items, required this.onTap});

  final List<DashboardModuleItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - AppDimens.dp10) / 2;
        return Wrap(
          spacing: AppDimens.dp10,
          runSpacing: AppDimens.dp10,
          children: List.generate(items.length, (index) {
            final item = items[index];
            return SizedBox(
              width: cardWidth,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppDimens.dp16),
                onTap: () => onTap(index),
                child: Container(
                  padding: EdgeInsets.all(AppDimens.dp12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimens.dp16),
                    border: Border.all(color: const Color(0xFFE2EAF6)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0E2A49).withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppDimens.dp36,
                        height: AppDimens.dp36,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppDimens.dp10),
                        ),
                        child: Icon(item.icon, color: item.color),
                      ),
                      SizedBox(height: AppDimens.dp10),
                      Text(
                        item.title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppDimens.sp14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppDimens.dp4),
                      Text(
                        item.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppDimens.sp10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
