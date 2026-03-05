import 'package:flutter/widgets.dart';

import '../common/module_placeholder_page.dart';

/// 总览页面。
class OverviewView extends StatelessWidget {
  const OverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholderPage(
      title: '总览',
      subtitle: '总览页面待接入统计图与业务指标数据。',
    );
  }
}
