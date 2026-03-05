import 'package:flutter/widgets.dart';

import '../common/module_placeholder_page.dart';

/// 人员查询页面。
class PersonnelQueryView extends StatelessWidget {
  const PersonnelQueryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholderPage(
      title: '人员查询',
      subtitle: '人员查询页面待接入真实业务数据。',
    );
  }
}
