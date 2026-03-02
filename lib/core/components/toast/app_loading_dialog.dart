import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import 'loading_widget.dart';

/// 加载弹框
/// [title] 弹框标题
/// [clickClose] 点击弹框是否关闭
/// [onClose] 点击弹框关闭回调
abstract class AppLoadingDialog {
  static CancelFunc? _cancelFunc;
  static int _lastTime = 0;

  /// 弹框动画时长
  static const int _animationDurationMilliseconds = 300;

  /// 显示加载弹框
  static void show({
    String title = '加载中...',
    bool clickClose = false,
    VoidCallback? onClose,
    // 是否覆盖整页
    bool fullPage = false,
  }) {
    _close();

    _lastTime = DateTime.now().millisecondsSinceEpoch;

    BotToast.showCustomLoading(
      clickClose: clickClose,
      onClose: onClose,
      backgroundColor: Colors.black38,
      backButtonBehavior:
          clickClose ? BackButtonBehavior.close : BackButtonBehavior.ignore,
      toastBuilder: (CancelFunc cancelFunc) {
        _cancelFunc = cancelFunc;
        return LoadingWidget(title: title, fullPage: fullPage);
      },
      animationDuration:
          const Duration(milliseconds: _animationDurationMilliseconds),
    );
  }

  static bool _close() {
    if (_cancelFunc != null) {
      _cancelFunc?.call();
      _cancelFunc = null;
      if (DateTime.now().millisecondsSinceEpoch - _lastTime <
          _animationDurationMilliseconds) {
        BotToast.closeAllLoading();
      }
      _lastTime = 0;
      return true;
    }
    return false;
  }

  /// 关闭加载弹框
  static void close() {
    if (!_close()) {
      closeAll();
    }
  }

  /// 取消全部, 会没有动画效果
  static void closeAll() {
    BotToast.closeAllLoading();
    _cancelFunc = null;
    _lastTime = 0;
  }
}
