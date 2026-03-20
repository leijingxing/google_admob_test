import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/dimens.dart';
import '../../data/models/reader/reader_demo_models.dart';
import 'admob_demo_controller.dart';
import 'comic_reader_detail_binding.dart';
import 'comic_reader_detail_view.dart';
import 'novel_reader_detail_binding.dart';
import 'novel_reader_detail_view.dart';

class AdmobDemoView extends GetView<AdmobDemoController> {
  const AdmobDemoView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdmobDemoController>(
      init: controller,
      builder: (logic) {
        return Scaffold(
          backgroundColor: const Color(0xFFF3F0EA),
          appBar: AppBar(
            title: const Text('MoonLeaf 阅读器'),
            centerTitle: false,
            backgroundColor: const Color(0xFFFDF8EF),
            foregroundColor: const Color(0xFF1E1D1A),
            elevation: 0,
          ),
          body: SafeArea(
            child: logic.isAndroid ? _buildCurrentTab(logic) : _buildUnsupported(),
          ),
          bottomNavigationBar: NavigationBar(
            backgroundColor: const Color(0xFFFDF8EF),
            selectedIndex: logic.currentTab.index,
            onDestinationSelected: logic.switchTab,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.auto_stories_outlined),
                selectedIcon: Icon(Icons.auto_stories),
                label: '书城',
              ),
              NavigationDestination(
                icon: Icon(Icons.chrome_reader_mode_outlined),
                selectedIcon: Icon(Icons.chrome_reader_mode),
                label: '阅读',
              ),
              NavigationDestination(
                icon: Icon(Icons.collections_bookmark_outlined),
                selectedIcon: Icon(Icons.collections_bookmark),
                label: '书架',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentTab(AdmobDemoController logic) {
    switch (logic.currentTab) {
      case AdmobDemoTab.discover:
        return _buildDiscoverTab(logic);
      case AdmobDemoTab.reader:
        return _buildReaderTab(logic);
      case AdmobDemoTab.library:
        return _buildLibraryTab(logic);
    }
  }

  Widget _buildDiscoverTab(AdmobDemoController logic) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _buildHeroBanner(logic.currentWork),
        const SizedBox(height: 20),
        const Text(
          '本地试读书城',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 0.2),
        ),
        const SizedBox(height: 8),
        const Text(
          '这些内容全部是本地 mock 数据，适合先把阅读器交互、章节切换和广告位跑通。',
          style: TextStyle(color: AppColors.textSecondary, height: 1.5),
        ),
        const SizedBox(height: 18),
        ...List.generate(logic.works.length, (index) {
          final work = logic.works[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _buildWorkCard(
              work: work,
              isSelected: index == logic.selectedWorkIndex,
              onTap: () {
                logic.openWork(index);
                _openWorkDetail(work);
              },
            ),
          );
        }),
        if (logic.fixedBannerLoaded && logic.fixedBannerAd != null) ...[
          const SizedBox(height: 18),
          _buildAdShelfCard(
            title: '书城推荐广告位',
            subtitle: '这里使用固定横幅，模拟书城底部推荐位。',
            child: SizedBox(
              width: logic.fixedBannerAd!.size.width.toDouble(),
              height: logic.fixedBannerAd!.size.height.toDouble(),
              child: AdWidget(ad: logic.fixedBannerAd!),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildReaderTab(AdmobDemoController logic) {
    final work = logic.currentWork;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _buildReaderHeader(logic),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: '继续沉浸式阅读',
          subtitle: '漫画详情页会使用真实本地大图和横向翻页；小说详情页会带阅读设置和更顺滑的翻页动画。',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildChapterSelector(logic),
              const SizedBox(height: 14),
              _buildModeSwitcher(logic),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _openWorkDetail(work),
                      child: Text(work.preferComic ? '进入漫画详情页' : '进入小说详情页'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _buildSectionCard(
          title: '阅读详情页能力',
          subtitle: '这部分说明的是详情页里已经做好的真实阅读能力。',
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('漫画详情页：真实本地封面、大图、横向翻页、底部横幅、章节广告。'),
              SizedBox(height: 8),
              Text('小说详情页：分页阅读、字体大小、行高、主题切换、作者手记激励解锁。'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLibraryTab(AdmobDemoController logic) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _buildSectionCard(
          title: '继续阅读',
          subtitle: '${logic.currentWork.title} · ${logic.currentChapter.title}',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                logic.currentChapter.subtitle,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                logic.currentWork.summary,
                style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: () => _openWorkDetail(logic.currentWork),
                child: const Text('打开详情阅读'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _buildSectionCard(
          title: '广告状态',
          subtitle: '把广告回调保留在书架页，方便演示时查看，不干扰阅读主流程。',
          child: Column(
            children: [
              _buildAdStatusRow('阅读页横幅', logic.statusOf('adaptive_banner')),
              _buildAdStatusRow('底部横幅', logic.statusOf('fixed_banner')),
              _buildAdStatusRow('章节插页', logic.statusOf('interstitial')),
              _buildAdStatusRow('番外激励', logic.statusOf('rewarded')),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _buildSectionCard(
          title: '最近广告回调',
          subtitle: '用于检查广告是否按预期插入到阅读流程中。',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMiniLogGroup('横幅广告', logic.logsOf('adaptive_banner')),
              const SizedBox(height: 12),
              _buildMiniLogGroup('章节插页', logic.logsOf('interstitial')),
              const SizedBox(height: 12),
              _buildMiniLogGroup('番外激励', logic.logsOf('rewarded')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroBanner(ReaderWork work) {
    final accent = Color(work.accentColor);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, accent.withValues(alpha: 0.72)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Featured Local Draft',
            style: TextStyle(color: Colors.white70, letterSpacing: 1.4, fontSize: 12),
          ),
          const SizedBox(height: 14),
          Text(
            work.title,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            work.tagline,
            style: const TextStyle(color: Colors.white, height: 1.5, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkCard({
    required ReaderWork work,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final accent = Color(work.accentColor);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? accent.withValues(alpha: 0.08) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? accent : const Color(0xFFE3DED3),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              _buildCoverBlock(work),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      work.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${work.author} · ${work.genre}',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: work.tags
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(tag, style: TextStyle(color: accent, fontWeight: FontWeight.w600)),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      work.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(height: 1.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverBlock(ReaderWork work) {
    final accent = Color(work.accentColor);
    return Container(
      width: 92,
      height: 132,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, accent.withValues(alpha: 0.72)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          work.preferComic ? 'COMIC' : 'NOVEL',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.1),
        ),
      ),
    );
  }

  Widget _buildReaderHeader(AdmobDemoController logic) {
    final work = logic.currentWork;
    final accent = Color(work.accentColor);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          _buildCoverBlock(work),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  work.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  work.tagline,
                  style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${logic.currentChapter.title} · ${logic.currentChapter.subtitle}',
                    style: TextStyle(color: accent, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterSelector(AdmobDemoController logic) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: logic.currentWork.chapters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final chapter = logic.currentWork.chapters[index];
          return ChoiceChip(
            selected: index == logic.selectedChapterIndex,
            label: Text(chapter.title),
            onSelected: (_) => logic.selectChapter(index),
          );
        },
      ),
    );
  }

  Widget _buildModeSwitcher(AdmobDemoController logic) {
    return SegmentedButton<ReaderContentMode>(
      segments: const [
        ButtonSegment(value: ReaderContentMode.comic, label: Text('漫画模式')),
        ButtonSegment(value: ReaderContentMode.novel, label: Text('小说模式')),
      ],
      selected: <ReaderContentMode>{logic.readerMode},
      onSelectionChanged: (selection) => logic.toggleReaderMode(selection.first),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildAdShelfCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return _buildSectionCard(title: title, subtitle: subtitle, child: Center(child: child));
  }

  Widget _buildAdStatusRow(String label, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEAE8FF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(status, style: const TextStyle(color: Color(0xFF5447B8), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniLogGroup(String title, List<String> logs) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF121822),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          if (logs.isEmpty)
            const Text('暂无回调', style: TextStyle(color: Color(0xFFAFC1D9)))
          else
            ...logs.map(
              (log) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(log, style: const TextStyle(color: Color(0xFFAFC1D9), height: 1.45)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUnsupported() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimens.dp24),
        child: const Text(
          '当前阅读器原型主要面向 Android 测试环境，请在 Android 设备或模拟器中运行。',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, height: 1.6),
        ),
      ),
    );
  }

  void _openWorkDetail(ReaderWork work) {
    if (work.preferComic) {
      Get.to(
        () => const ComicReaderDetailView(),
        binding: ComicReaderDetailBinding(work: work),
      );
      return;
    }

    Get.to(
      () => const NovelReaderDetailView(),
      binding: NovelReaderDetailBinding(work: work),
    );
  }
}
