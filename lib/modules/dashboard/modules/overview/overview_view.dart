import 'package:flutter/material.dart';

import '../../../../core/constants/dimens.dart';
import 'dashboard_statistics_section.dart';

/// 总览页面。
class OverviewView extends StatelessWidget {
  const OverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('总览')),
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
          child: const DashboardStatisticsSection(),
        ),
      ),
    );
  }
}
