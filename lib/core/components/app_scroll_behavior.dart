import 'package:flutter/material.dart';

/// 统一 ScrollPhysics
///
/// 参考:
/// https://stackoverflow.com/questions/62809540/how-can-you-change-the-default-scrollphysics-in-flutter
class AppScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
        return const BouncingScrollPhysics();
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }
}
