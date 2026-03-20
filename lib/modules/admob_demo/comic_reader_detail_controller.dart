import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/components/toast/toast_widget.dart';
import '../../data/models/reader/reader_demo_models.dart';
import '../../generated/assets.gen.dart';
import 'reader_demo_assets.dart';

enum ComicReaderFitMode { fitWidth, fillPage }

/// 漫画详情页控制器。
class ComicReaderDetailController extends GetxController {
  ComicReaderDetailController({required this.work});

  static const _request = AdRequest();
  static const _bannerUnitId = 'ca-app-pub-3940256099942544/9214589741';
  static const _interstitialUnitId = 'ca-app-pub-3940256099942544/1033173712';

  final ReaderWork work;
  final PageController pageController = PageController();

  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;

  bool bannerLoaded = false;
  bool interstitialReady = false;
  bool chromeVisible = true;
  int currentPage = 0;
  int unlockedChapterIndex = 0;
  ComicReaderFitMode fitMode = ComicReaderFitMode.fitWidth;
  String chapterAdStatus = 'onAdLoading';

  bool get isAndroid => Platform.isAndroid;
  List<AssetGenImage> get allPages => ReaderDemoAssets.comicPagesOf(work);

  int get pagesPerChapter {
    if (work.chapters.isEmpty || allPages.isEmpty) {
      return 1;
    }
    return math.max(1, (allPages.length / work.chapters.length).ceil());
  }

  int get visiblePageCount {
    if (allPages.isEmpty) {
      return 0;
    }
    return math.min(
      allPages.length,
      (unlockedChapterIndex + 1) * pagesPerChapter,
    );
  }

  List<AssetGenImage> get visiblePages =>
      allPages.take(visiblePageCount).toList(growable: false);

  int chapterIndexOfPage(int pageIndex) {
    if (work.chapters.isEmpty) {
      return 0;
    }
    return (pageIndex ~/ pagesPerChapter).clamp(0, work.chapters.length - 1);
  }

  ReaderChapter chapterOfPage(int pageIndex) {
    return work.chapters[chapterIndexOfPage(pageIndex)];
  }

  int get currentChapterIndex {
    if (visiblePageCount == 0) {
      return 0;
    }
    return chapterIndexOfPage(currentPage.clamp(0, visiblePageCount - 1));
  }

  ReaderChapter get currentChapter =>
      chapterOfPage(currentPage.clamp(0, math.max(0, visiblePageCount - 1)));

  bool get hasNextChapter => currentChapterIndex < work.chapters.length - 1;

  bool get shouldUnlockNextChapter {
    return visiblePageCount > 0 &&
        currentPage == visiblePageCount - 1 &&
        hasNextChapter &&
        unlockedChapterIndex == currentChapterIndex;
  }

  bool get isFinalChapterFinished {
    return visiblePageCount > 0 &&
        currentPage == visiblePageCount - 1 &&
        !hasNextChapter;
  }

  BoxFit get pageFit {
    switch (fitMode) {
      case ComicReaderFitMode.fitWidth:
        return BoxFit.fitWidth;
      case ComicReaderFitMode.fillPage:
        return BoxFit.cover;
    }
  }

  String get progressLabel =>
      '${currentPage + 1} / ${visiblePageCount == 0 ? allPages.length : visiblePageCount}';

  @override
  void onInit() {
    super.onInit();
    if (!isAndroid) {
      chapterAdStatus = '非 Android 设备跳过广告';
      return;
    }
    _loadBanner();
    _loadInterstitial();
  }

  void onPageChanged(int index) {
    currentPage = index;
    update();
  }

  void toggleChrome() {
    chromeVisible = !chromeVisible;
    update();
  }

  void changeFitMode(ComicReaderFitMode mode) {
    fitMode = mode;
    update();
  }

  Future<void> unlockNextChapter() async {
    if (!shouldUnlockNextChapter) {
      return;
    }
    if (!isAndroid) {
      _unlockNextChapter();
      return;
    }
    if (interstitialAd == null) {
      AppToast.showWarning('章节广告还没有准备好');
      return;
    }
    _showUnlockInterstitial();
  }

  void _showUnlockInterstitial() {
    final ad = interstitialAd;
    if (ad == null) {
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) {
        chapterAdStatus = 'onAdShowedFullScreenContent';
        update();
      },
      onAdImpression: (_) {
        chapterAdStatus = 'onAdImpression';
        update();
      },
      onAdClicked: (_) {
        chapterAdStatus = 'onAdClicked';
        update();
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        interstitialAd = null;
        interstitialReady = false;
        chapterAdStatus = 'onAdDismissedFullScreenContent';
        _unlockNextChapter();
        update();
        _loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        interstitialAd = null;
        interstitialReady = false;
        chapterAdStatus = 'onAdFailedToShowFullScreenContent';
        update();
        AppToast.showError('漫画章节广告展示失败: ${error.message}');
        _loadInterstitial();
      },
    );

    ad.show();
    interstitialAd = null;
    interstitialReady = false;
    update();
  }

  void _unlockNextChapter() {
    if (!hasNextChapter) {
      return;
    }

    unlockedChapterIndex += 1;
    final nextPage = math.min(
      math.max(0, unlockedChapterIndex * pagesPerChapter),
      math.max(0, allPages.length - 1),
    );
    AppToast.showSuccess('下一章已解锁');
    update();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!pageController.hasClients) {
        return;
      }
      await pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
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

  void _loadInterstitial() {
    chapterAdStatus = 'onAdLoading';
    update();

    InterstitialAd.load(
      adUnitId: _interstitialUnitId,
      request: _request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          interstitialReady = true;
          chapterAdStatus = 'onAdLoaded';
          ad.setImmersiveMode(true);
          update();
        },
        onAdFailedToLoad: (_) {
          interstitialAd = null;
          interstitialReady = false;
          chapterAdStatus = 'onAdFailedToLoad';
          update();
        },
      ),
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    bannerAd?.dispose();
    interstitialAd?.dispose();
    super.onClose();
  }
}
