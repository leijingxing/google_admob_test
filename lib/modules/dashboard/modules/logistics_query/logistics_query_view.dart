import 'package:flutter/material.dart';

import '../../../../core/constants/dimens.dart';
import 'logistics_query_statistics_section.dart';

/// 物流查询页面。
class LogisticsQueryView extends StatelessWidget {
  const LogisticsQueryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('物流查询')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3F8FF), Color(0xFFEAF2FF)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppDimens.dp16,
            AppDimens.dp16,
            AppDimens.dp16,
            AppDimens.dp12,
          ),
          child: const LogisticsQueryStatisticsSection(),
        ),
      ),
    );
  }
}
