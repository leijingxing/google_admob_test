import 'package:flutter/widgets.dart';

import '../common/module_placeholder_page.dart';

/// 物流查询页面。
class LogisticsQueryView extends StatelessWidget {
  const LogisticsQueryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholderPage(
      title: '物流查询',
      subtitle: '物流查询页面待接入真实业务数据。',
    );
  }
}
