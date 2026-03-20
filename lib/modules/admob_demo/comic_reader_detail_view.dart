import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'comic_reader_detail_controller.dart';

/// 漫画阅读详情页。
class ComicReaderDetailView extends GetView<ComicReaderDetailController> {
  const ComicReaderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ComicReaderDetailController>(
      init: controller,
      builder: (logic) {
        return Scaffold(
          backgroundColor: const Color(0xFF05070A),
          body: Stack(
            children: [
              Positioned.fill(
                child: PageView.builder(
                  controller: logic.pageController,
                  scrollDirection: Axis.vertical,
                  onPageChanged: logic.onPageChanged,
                  itemCount: logic.visiblePages.length,
                  itemBuilder: (context, index) {
                    final chapter = logic.chapterOfPage(index);
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: logic.toggleChrome,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(color: const Color(0xFF05070A)),
                          InteractiveViewer(
                            minScale: 1,
                            maxScale: 2.6,
                            child: Center(
                              child: logic.visiblePages[index].image(
                                fit: logic.pageFit,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0x9A05070A),
                                  Colors.transparent,
                                  Colors.transparent,
                                  Color(0xC405070A),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 18,
                            right: 18,
                            bottom: 132,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index == 0 ||
                                    logic.chapterIndexOfPage(index) !=
                                        logic.chapterIndexOfPage(index - 1))
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.55,
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      '${chapter.title} · ${chapter.subtitle}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 9,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.35),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    chapter.subtitle,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      height: 1.45,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: IgnorePointer(
                  ignoring: !logic.chromeVisible,
                  child: AnimatedOpacity(
                    opacity: logic.chromeVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                        child: Row(
                          children: [
                            _CircleAction(
                              icon: Icons.arrow_back_ios_new_rounded,
                              onTap: Get.back,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.36),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      logic.work.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${logic.currentChapter.title} · ${logic.progressLabel}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            _CircleAction(
                              icon: Icons.tune_rounded,
                              onTap: () => _showSettingsSheet(context, logic),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: logic.bannerLoaded && logic.bannerAd != null ? 88 : 24,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: logic.shouldUnlockNextChapter
                      ? _ChapterUnlockCard(
                          key: const ValueKey('unlock-card'),
                          adReady: logic.interstitialReady,
                          currentChapter: logic.currentChapter.title,
                          nextChapter: logic
                              .work
                              .chapters[logic.currentChapterIndex + 1]
                              .title,
                          adStatus: logic.chapterAdStatus,
                          onUnlock: logic.unlockNextChapter,
                        )
                      : logic.isFinalChapterFinished
                      ? Container(
                          key: const ValueKey('finish-card'),
                          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.72),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Text(
                            '本作已经读完，底部广告位保留用于 AdMob 演示。',
                            style: TextStyle(color: Colors.white, height: 1.5),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              if (logic.bannerLoaded && logic.bannerAd != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 12,
                  child: SafeArea(
                    top: false,
                    child: Center(
                      child: SizedBox(
                        width: logic.bannerAd!.size.width.toDouble(),
                        height: logic.bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: logic.bannerAd!),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showSettingsSheet(
    BuildContext context,
    ComicReaderDetailController logic,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          decoration: const BoxDecoration(
            color: Color(0xFF11161C),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '阅读设置',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '图片适配',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                children: [
                  ChoiceChip(
                    selected: logic.fitMode == ComicReaderFitMode.fitWidth,
                    label: const Text('适应宽度'),
                    onSelected: (_) =>
                        logic.changeFitMode(ComicReaderFitMode.fitWidth),
                  ),
                  ChoiceChip(
                    selected: logic.fitMode == ComicReaderFitMode.fillPage,
                    label: const Text('铺满屏幕'),
                    onSelected: (_) =>
                        logic.changeFitMode(ComicReaderFitMode.fillPage),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                '章节广告回调: ${logic.chapterAdStatus}',
                style: const TextStyle(color: Colors.white70, height: 1.5),
              ),
              const SizedBox(height: 6),
              Text(
                logic.interstitialReady ? '下一章广告可用' : '下一章广告加载中',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.38),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _ChapterUnlockCard extends StatelessWidget {
  const _ChapterUnlockCard({
    super.key,
    required this.adReady,
    required this.currentChapter,
    required this.nextChapter,
    required this.adStatus,
    required this.onUnlock,
  });

  final bool adReady;
  final String currentChapter;
  final String nextChapter;
  final String adStatus;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '本章已加载完成',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$currentChapter 已读完，观看一次测试插页广告后继续进入 $nextChapter。',
            style: const TextStyle(color: Colors.white70, height: 1.55),
          ),
          const SizedBox(height: 8),
          Text(
            '广告回调: $adStatus',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: adReady ? onUnlock : null,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: const Color(0xFF1A1308),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(adReady ? '观看广告，进入下一章' : '广告加载中'),
            ),
          ),
        ],
      ),
    );
  }
}
