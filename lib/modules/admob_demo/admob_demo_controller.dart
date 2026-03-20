import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/components/toast/toast_widget.dart';
import '../../data/models/reader/reader_demo_models.dart';
import '../../data/repository/reader_demo_repository.dart';

class _AndroidTestAdUnitIds {
  static const adaptiveBanner = 'ca-app-pub-3940256099942544/9214589741';
  static const fixedBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const interstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const rewarded = 'ca-app-pub-3940256099942544/5224354917';
}

enum AdmobDemoTab { discover, reader, library }

enum ReaderContentMode { comic, novel }

class AdmobDemoController extends GetxController {
  AdmobDemoController() : _repository = const ReaderDemoRepository();

  static const _request = AdRequest();

  final ReaderDemoRepository _repository;

  BannerAd? fixedBannerAd;
  BannerAd? adaptiveBannerAd;
  InterstitialAd? interstitialAd;
  RewardedAd? rewardedAd;

  AdmobDemoTab currentTab = AdmobDemoTab.discover;
  ReaderContentMode readerMode = ReaderContentMode.comic;

  List<ReaderWork> works = <ReaderWork>[];
  int selectedWorkIndex = 0;
  int selectedChapterIndex = 0;
  bool bonusUnlocked = false;

  bool fixedBannerLoaded = false;
  bool adaptiveBannerLoaded = false;
  bool adaptiveBannerLoading = false;
  bool interstitialReady = false;
  bool rewardedReady = false;

  final Map<String, String> adStatuses = <String, String>{
    'fixed_banner': '等待加载',
    'adaptive_banner': '等待加载',
    'interstitial': '等待加载',
    'rewarded': '等待加载',
  };

  final Map<String, List<String>> adLogs = <String, List<String>>{
    'fixed_banner': <String>[],
    'adaptive_banner': <String>[],
    'interstitial': <String>[],
    'rewarded': <String>[],
  };

  VoidCallback? _afterInterstitialAction;

  bool get isAndroid => Platform.isAndroid;

  ReaderWork get currentWork => works[selectedWorkIndex];

  ReaderChapter get currentChapter => currentWork.chapters[selectedChapterIndex];

  bool get hasNextChapter => selectedChapterIndex < currentWork.chapters.length - 1;

  @override
  void onInit() {
    super.onInit();
    works = _repository.getWorks();
    readerMode = currentWork.preferComic ? ReaderContentMode.comic : ReaderContentMode.novel;
    if (!isAndroid) return;
    _loadFixedBanner();
    loadInterstitial();
    loadRewarded();
  }

  void switchTab(int index) {
    currentTab = AdmobDemoTab.values[index];
    update();
  }

  void openWork(int workIndex) {
    selectedWorkIndex = workIndex;
    selectedChapterIndex = 0;
    readerMode = currentWork.preferComic ? ReaderContentMode.comic : ReaderContentMode.novel;
    bonusUnlocked = false;
    _pushLog('interstitial', '已打开《${currentWork.title}》');
    update();
  }

  void selectChapter(int chapterIndex) {
    selectedChapterIndex = chapterIndex;
    bonusUnlocked = false;
    _pushLog('interstitial', '切换到 ${currentChapter.title} ${currentChapter.subtitle}');
    update();
  }

  void toggleReaderMode(ReaderContentMode mode) {
    readerMode = mode;
    _pushLog('interstitial', mode == ReaderContentMode.comic ? '切换到漫画模式' : '切换到小说模式');
    update();
  }

  void readNextChapter() {
    if (!hasNextChapter) {
      AppToast.showInfo('已经是最后一章');
      return;
    }
    if (interstitialReady && interstitialAd != null) {
      _afterInterstitialAction = _advanceChapter;
      showInterstitial();
      return;
    }
    _advanceChapter();
  }

  void unlockBonusContent() {
    if (bonusUnlocked) {
      AppToast.showInfo('番外已经解锁');
      return;
    }
    if (!rewardedReady || rewardedAd == null) {
      AppToast.showWarning('激励广告还没有准备好');
      return;
    }
    showRewarded();
  }

  Future<void> ensureAdaptiveBannerLoaded(int width) async {
    if (!isAndroid || width <= 0 || adaptiveBannerLoaded || adaptiveBannerLoading) return;

    adaptiveBannerLoading = true;
    _record('adaptive_banner', '计算尺寸中', '开始为阅读页请求自适应横幅尺寸');

    final adSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    if (adSize == null) {
      adaptiveBannerLoading = false;
      _record('adaptive_banner', '尺寸获取失败', '当前宽度下无法创建阅读页广告', toast: true, isError: true);
      return;
    }

    await adaptiveBannerAd?.dispose();
    adaptiveBannerLoaded = false;
    _record('adaptive_banner', '加载中', '阅读页广告尺寸 ${adSize.width}x${adSize.height}');

    adaptiveBannerAd = BannerAd(
      adUnitId: _AndroidTestAdUnitIds.adaptiveBanner,
      request: _request,
      size: adSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          adaptiveBannerAd = ad as BannerAd;
          adaptiveBannerLoaded = true;
          adaptiveBannerLoading = false;
          _record('adaptive_banner', '已加载', 'onAdLoaded: 阅读页横幅已就绪');
        },
        onAdImpression: (_) => _record('adaptive_banner', '已曝光', 'onAdImpression: 阅读页横幅产生曝光'),
        onAdClicked: (_) => _record('adaptive_banner', '已点击', 'onAdClicked: 阅读页横幅被点击'),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          adaptiveBannerAd = null;
          adaptiveBannerLoaded = false;
          adaptiveBannerLoading = false;
          _record('adaptive_banner', '加载失败', 'onAdFailedToLoad: ${error.message}', toast: true, isError: true);
        },
      ),
    )..load();
  }

  Future<void> reloadAdaptiveBanner(int width) async {
    await adaptiveBannerAd?.dispose();
    adaptiveBannerAd = null;
    adaptiveBannerLoaded = false;
    adaptiveBannerLoading = false;
    _record('adaptive_banner', '重新加载', '手动刷新阅读页广告');
    await ensureAdaptiveBannerLoaded(width);
  }

  void loadInterstitial() {
    if (!isAndroid) return;

    interstitialReady = false;
    _record('interstitial', '加载中', '开始请求章节切换插页广告');
    InterstitialAd.load(
      adUnitId: _AndroidTestAdUnitIds.interstitial,
      request: _request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          interstitialReady = true;
          ad.setImmersiveMode(true);
          _record('interstitial', '已加载', 'onAdLoaded: 章节切换插页广告已准备完成');
        },
        onAdFailedToLoad: (error) {
          interstitialAd = null;
          interstitialReady = false;
          _record('interstitial', '加载失败', 'onAdFailedToLoad: ${error.message}', toast: true, isError: true);
        },
      ),
    );
  }

  void showInterstitial() {
    final ad = interstitialAd;
    if (ad == null) {
      AppToast.showWarning('插页广告还没有准备好');
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) => _record('interstitial', '展示中', 'onAdShowedFullScreenContent: 章节切换广告已展示'),
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        interstitialAd = null;
        interstitialReady = false;
        _record('interstitial', '已关闭', 'onAdDismissedFullScreenContent: 章节切换广告已关闭');
        final action = _afterInterstitialAction;
        _afterInterstitialAction = null;
        action?.call();
        loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        interstitialAd = null;
        interstitialReady = false;
        _record('interstitial', '展示失败', 'onAdFailedToShowFullScreenContent: ${error.message}', toast: true, isError: true);
        final action = _afterInterstitialAction;
        _afterInterstitialAction = null;
        action?.call();
        loadInterstitial();
      },
    );

    _record('interstitial', '准备展示', '调用 show()，在切换到下一章前展示广告');
    ad.show();
    interstitialAd = null;
    interstitialReady = false;
    update();
  }

  void loadRewarded() {
    if (!isAndroid) return;

    rewardedReady = false;
    _record('rewarded', '加载中', '开始请求番外解锁激励广告');
    RewardedAd.load(
      adUnitId: _AndroidTestAdUnitIds.rewarded,
      request: _request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          rewardedReady = true;
          _record('rewarded', '已加载', 'onAdLoaded: 激励广告已准备完成');
        },
        onAdFailedToLoad: (error) {
          rewardedAd = null;
          rewardedReady = false;
          _record('rewarded', '加载失败', 'onAdFailedToLoad: ${error.message}', toast: true, isError: true);
        },
      ),
    );
  }

  void showRewarded() {
    final ad = rewardedAd;
    if (ad == null) {
      AppToast.showWarning('激励广告还没有准备好');
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) => _record('rewarded', '展示中', 'onAdShowedFullScreenContent: 番外解锁广告已展示'),
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        rewardedAd = null;
        rewardedReady = false;
        _record('rewarded', '已关闭', 'onAdDismissedFullScreenContent: 激励广告已关闭');
        loadRewarded();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        rewardedAd = null;
        rewardedReady = false;
        _record('rewarded', '展示失败', 'onAdFailedToShowFullScreenContent: ${error.message}', toast: true, isError: true);
        loadRewarded();
      },
    );

    ad.setImmersiveMode(true);
    _record('rewarded', '准备展示', '调用 show()，用于解锁章节番外');
    ad.show(
      onUserEarnedReward: (_, reward) {
        bonusUnlocked = true;
        _record('rewarded', '已发奖', 'onUserEarnedReward: ${reward.amount} ${reward.type}', toast: true);
        _pushLog('rewarded', '番外内容已解锁');
      },
    );
    rewardedAd = null;
    rewardedReady = false;
    update();
  }

  String statusOf(String key) => adStatuses[key]!;

  List<String> logsOf(String key) => adLogs[key]!;

  void _advanceChapter() {
    if (!hasNextChapter) return;
    selectedChapterIndex += 1;
    bonusUnlocked = false;
    _pushLog('interstitial', '已进入 ${currentChapter.title} ${currentChapter.subtitle}');
    update();
  }

  void _record(String key, String status, String log, {bool toast = false, bool isError = false}) {
    adStatuses[key] = status;
    _pushLog(key, log);
    update();
    if (toast) {
      isError ? AppToast.showError(log) : AppToast.showInfo(log);
    }
  }

  void _pushLog(String key, String message) {
    adLogs[key]!.insert(0, message);
    if (adLogs[key]!.length > 5) {
      adLogs[key]!.removeLast();
    }
  }

  void _loadFixedBanner() {
    if (!isAndroid) return;

    _record('fixed_banner', '加载中', '开始请求底部固定横幅广告');
    fixedBannerAd = BannerAd(
      adUnitId: _AndroidTestAdUnitIds.fixedBanner,
      request: _request,
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          fixedBannerAd = ad as BannerAd;
          fixedBannerLoaded = true;
          _record('fixed_banner', '已加载', 'onAdLoaded: 底部固定横幅广告加载成功');
        },
        onAdImpression: (_) => _record('fixed_banner', '已曝光', 'onAdImpression: 底部固定横幅产生曝光'),
        onAdClicked: (_) => _record('fixed_banner', '已点击', 'onAdClicked: 底部固定横幅被点击'),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          fixedBannerAd = null;
          fixedBannerLoaded = false;
          _record('fixed_banner', '加载失败', 'onAdFailedToLoad: ${error.message}', toast: true, isError: true);
        },
      ),
    )..load();
  }

  @override
  void onClose() {
    fixedBannerAd?.dispose();
    adaptiveBannerAd?.dispose();
    interstitialAd?.dispose();
    rewardedAd?.dispose();
    super.onClose();
  }
}
