import 'package:flutter/material.dart';

import '../../../../core/constants/dimens.dart';
import 'workbench_content_section.dart';

/// 工作台页面。
class WorkbenchView extends StatelessWidget {
  const WorkbenchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('工作台')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3F8FF), Color(0xFFEAF2FF)],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppDimens.dp16,
            AppDimens.dp16,
            AppDimens.dp16,
            AppDimens.dp24,
          ),
          child: const WorkbenchContentSection(),
        ),
      ),
    );
  }
}
