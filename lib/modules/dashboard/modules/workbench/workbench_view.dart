import 'package:flutter/widgets.dart';

import '../common/module_placeholder_page.dart';

/// 工作台页面。
class WorkbenchView extends StatelessWidget {
  const WorkbenchView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholderPage(
      title: '工作台',
      subtitle: '工作台页面待接入真实业务数据。',
    );
  }
}
