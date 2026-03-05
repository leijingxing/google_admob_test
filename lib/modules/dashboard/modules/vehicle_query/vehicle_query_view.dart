import 'package:flutter/material.dart';

import '../../../../core/constants/dimens.dart';
import 'vehicle_query_statistics_section.dart';

/// 车辆查询页面。
class VehicleQueryView extends StatelessWidget {
  const VehicleQueryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('车辆查询')),
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
          child: const VehicleQueryStatisticsSection(),
        ),
      ),
    );
  }
}
