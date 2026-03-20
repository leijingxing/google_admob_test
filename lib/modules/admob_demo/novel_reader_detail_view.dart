import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/constants/app_colors.dart';
import 'novel_reader_detail_controller.dart';

/// 小说阅读详情页。
class NovelReaderDetailView extends GetView<NovelReaderDetailController> {
  const NovelReaderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NovelReaderDetailController>(
      init: controller,
      builder: (logic) {
        return Scaffold(
          backgroundColor: logic.backgroundColor,
          appBar: AppBar(
            backgroundColor: logic.backgroundColor,
            elevation: 0,
            foregroundColor: logic.textColor,
            title: Text('${logic.work.title} · 小说详情'),
            actions: [
              IconButton(
                onPressed: () => _showSettingsSheet(context, logic),
                icon: const Icon(Icons.tune_rounded),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${logic.chapter.title} · ${logic.chapter.subtitle}',
                        style: TextStyle(color: logic.secondaryTextColor),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: logic.rewardedReady ? const Color(0xFF1D7A66) : const Color(0xFF6B7280),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        logic.rewardedReady ? '作者手记可解锁' : '作者手记广告加载中',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: logic.pageController,
                  onPageChanged: logic.onPageChanged,
                  itemCount: logic.pages.length,
                  itemBuilder: (context, index) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.96, end: 1),
                      duration: const Duration(milliseconds: 380),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                          decoration: BoxDecoration(
                            color: logic.cardColor,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '第 ${index + 1} 页',
                                style: TextStyle(
                                  color: logic.secondaryTextColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    logic.pages[index],
                                    style: TextStyle(
                                      color: logic.textColor,
                                      fontSize: logic.fontSize,
                                      height: logic.lineHeight,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (logic.bannerLoaded && logic.bannerAd != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: logic.bannerAd!.size.width.toDouble(),
                    height: logic.bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: logic.bannerAd!),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: logic.previousPage,
                        child: const Text('上一页'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: logic.nextPage,
                        style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                        child: const Text('下一页'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextButton(
                        onPressed: logic.unlockAuthorNote,
                        child: const Text('作者手记'),
                      ),
                    ),
                  ],
                ),
              ),
              if (logic.authorNoteUnlocked)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: logic.cardColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    logic.chapter.bonusParagraph,
                    style: TextStyle(color: logic.textColor, height: logic.lineHeight),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showSettingsSheet(BuildContext context, NovelReaderDetailController logic) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          decoration: const BoxDecoration(
            color: Color(0xFFFDF8EF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('阅读设置', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              Text('字体大小 ${logic.fontSize.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700)),
              Slider(
                value: logic.fontSize,
                min: 16,
                max: 26,
                divisions: 10,
                onChanged: logic.updateFontSize,
              ),
              Text('行高 ${logic.lineHeight.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700)),
              Slider(
                value: logic.lineHeight,
                min: 1.5,
                max: 2.3,
                divisions: 8,
                onChanged: logic.updateLineHeight,
              ),
              const SizedBox(height: 8),
              const Text('主题', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  ChoiceChip(
                    selected: logic.themeMode == ReaderThemeMode.paper,
                    label: const Text('纸张'),
                    onSelected: (_) => logic.changeTheme(ReaderThemeMode.paper),
                  ),
                  ChoiceChip(
                    selected: logic.themeMode == ReaderThemeMode.night,
                    label: const Text('夜间'),
                    onSelected: (_) => logic.changeTheme(ReaderThemeMode.night),
                  ),
                  ChoiceChip(
                    selected: logic.themeMode == ReaderThemeMode.forest,
                    label: const Text('森林'),
                    onSelected: (_) => logic.changeTheme(ReaderThemeMode.forest),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
