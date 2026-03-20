import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/components/toast/toast_widget.dart';
import '../../data/models/reader/reader_demo_models.dart';

enum ReaderThemeMode { paper, night, forest }

/// 小说阅读详情页控制器。
class NovelReaderDetailController extends GetxController {
  NovelReaderDetailController({required this.work});

  static const _request = AdRequest();
  static const _bannerUnitId = 'ca-app-pub-3940256099942544/9214589741';
  static const _rewardedUnitId = 'ca-app-pub-3940256099942544/5224354917';

  final ReaderWork work;
  final PageController pageController = PageController();

  BannerAd? bannerAd;
  RewardedAd? rewardedAd;

  bool bannerLoaded = false;
  bool rewardedReady = false;
  int currentPage = 0;
  double fontSize = 19;
  double lineHeight = 1.95;
  ReaderThemeMode themeMode = ReaderThemeMode.paper;
  bool authorNoteUnlocked = false;

  bool get isAndroid => Platform.isAndroid;
  ReaderChapter get chapter => work.chapters.first;
  List<String> get pages => _buildPages();

  @override
  void onInit() {
    super.onInit();
    if (!isAndroid) return;
    _loadBanner();
    _loadRewarded();
  }

  void onPageChanged(int index) {
    currentPage = index;
    update();
  }

  Future<void> nextPage() async {
    if (currentPage >= pages.length - 1) {
      AppToast.showInfo('已经是最后一页');
      return;
    }
    await pageController.nextPage(duration: const Duration(milliseconds: 460), curve: Curves.easeInOutCubicEmphasized);
  }

  Future<void> previousPage() async {
    if (currentPage <= 0) {
      AppToast.showInfo('已经是第一页');
      return;
    }
    await pageController.previousPage(duration: const Duration(milliseconds: 460), curve: Curves.easeInOutCubicEmphasized);
  }

  void updateFontSize(double value) {
    fontSize = value;
    update();
  }

  void updateLineHeight(double value) {
    lineHeight = value;
    update();
  }

  void changeTheme(ReaderThemeMode mode) {
    themeMode = mode;
    update();
  }

  void unlockAuthorNote() {
    if (authorNoteUnlocked) {
      AppToast.showInfo('作者手记已经解锁');
      return;
    }
    if (!rewardedReady || rewardedAd == null) {
      AppToast.showWarning('激励广告还没有准备好');
      return;
    }
    _showRewarded();
  }

  Color get backgroundColor {
    switch (themeMode) {
      case ReaderThemeMode.paper:
        return const Color(0xFFF6EEDB);
      case ReaderThemeMode.night:
        return const Color(0xFF11161C);
      case ReaderThemeMode.forest:
        return const Color(0xFFE7F0E5);
    }
  }

  Color get cardColor {
    switch (themeMode) {
      case ReaderThemeMode.paper:
        return const Color(0xFFFFFBF3);
      case ReaderThemeMode.night:
        return const Color(0xFF1C242D);
      case ReaderThemeMode.forest:
        return const Color(0xFFF5FBF2);
    }
  }

  Color get textColor {
    switch (themeMode) {
      case ReaderThemeMode.paper:
        return const Color(0xFF2C261D);
      case ReaderThemeMode.night:
        return const Color(0xFFE7EDF3);
      case ReaderThemeMode.forest:
        return const Color(0xFF213223);
    }
  }

  Color get secondaryTextColor {
    switch (themeMode) {
      case ReaderThemeMode.paper:
        return const Color(0xFF6E6256);
      case ReaderThemeMode.night:
        return const Color(0xFFA3B0BE);
      case ReaderThemeMode.forest:
        return const Color(0xFF5A6B57);
    }
  }

  List<String> _buildPages() {
    final paragraphs = [...chapter.novelParagraphs];
    paragraphs.addAll([
      '雨停之后，陆灯才发现旅店窗外没有街道，只有缓慢移动的星光。它们像潮水一样从楼下流过去，无声却明亮，把窗沿映成一条温柔的边界。',
      '她想起自己很久没有真正读完一本书，也很久没有完整地听完一段心事。可在这座旅店里，时间像被放慢了半格，连呼吸都可以被允许更从容一些。',
      '阅览室角落的落地钟在整点前总会慢半分钟。前台小姐说，那是给犹豫的人留的余地。真正决定离开的那一刻，钟摆自然会追上时间。',
      '陆灯最终在留言簿里写下了一句很短的话：原来我不是被困在过去，我只是一直没有学会和自己好好告别。墨迹落下的同时，纸页边缘亮了一下，像有人在远处点头。',
    ]);

    return [
      '${work.title}\n\n${chapter.title} · ${chapter.subtitle}\n\n${paragraphs[0]}\n\n${paragraphs[1]}',
      '${paragraphs[2]}\n\n${paragraphs[3]}',
      '${paragraphs[4]}\n\n${paragraphs[5]}',
      '${paragraphs[6]}\n\n${paragraphs[0]}',
    ];
  }

  void _loadBanner() {
    bannerAd = BannerAd(
      adUnitId: _bannerUnitId,
      request: _request,
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAd = ad as BannerAd;
          bannerLoaded = true;
          update();
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          bannerAd = null;
          bannerLoaded = false;
          update();
        },
      ),
    )..load();
  }

  void _loadRewarded() {
    RewardedAd.load(
      adUnitId: _rewardedUnitId,
      request: _request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          rewardedReady = true;
          update();
        },
        onAdFailedToLoad: (_) {
          rewardedAd = null;
          rewardedReady = false;
          update();
        },
      ),
    );
  }

  void _showRewarded() {
    final ad = rewardedAd;
    if (ad == null) return;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        rewardedAd = null;
        rewardedReady = false;
        update();
        _loadRewarded();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        rewardedAd = null;
        rewardedReady = false;
        update();
        AppToast.showError('作者手记广告展示失败: ${error.message}');
        _loadRewarded();
      },
    );

    ad.show(
      onUserEarnedReward: (_, reward) {
        authorNoteUnlocked = true;
        AppToast.showSuccess('已解锁作者手记: ${reward.amount} ${reward.type}');
        update();
      },
    );
    rewardedAd = null;
    rewardedReady = false;
    update();
  }

  @override
  void onClose() {
    pageController.dispose();
    bannerAd?.dispose();
    rewardedAd?.dispose();
    super.onClose();
  }
}
