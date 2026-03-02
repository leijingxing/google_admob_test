import 'package:flutter/material.dart';

/// 全局隐藏键盘组件，点击空白处隐藏键盘，点击输入框显示键盘
class HideKeyboard extends StatelessWidget {
  const HideKeyboard({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 获取当前页面的焦点作用域
        final FocusScopeNode currentFocus = FocusScope.of(context);
        // 如果焦点作用域不是主焦点，并且当前有子控件获得焦点，则取消焦点
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      // 透明区域也响应点击事件
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}
