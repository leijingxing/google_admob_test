import 'package:flutter/material.dart';

import '../../../../core/constants/dimens.dart';
import 'personnel_query_statistics_section.dart';

/// 人员查询页面。
class PersonnelQueryView extends StatelessWidget {
  const PersonnelQueryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('人员查询')),
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
          child: const PersonnelQueryStatisticsSection(),
        ),
      ),
    );
  }
}
