import 'package:flutter/widgets.dart';

import '../common/module_placeholder_page.dart';

/// 车辆查询页面。
class VehicleQueryView extends StatelessWidget {
  const VehicleQueryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholderPage(
      title: '车辆查询',
      subtitle: '车辆查询页面待接入真实业务数据。',
    );
  }
}
