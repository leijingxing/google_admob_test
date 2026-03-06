import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/dimens.dart';
import '../../../../router/module_routes/workbench_routes.dart';
import 'workbench_controller.dart';

/// 工作台业务内容区。
class WorkbenchContentSection extends StatelessWidget {
  const WorkbenchContentSection({super.key});

  static const List<_WorkbenchEntry> _entries = [
    _WorkbenchEntry(
      title: '白名单审批',
      count: 12,
      icon: Icons.verified_user_outlined,
    ),
    _WorkbenchEntry(title: '黑名单审批', count: 12, icon: Icons.gpp_bad_outlined),
    _WorkbenchEntry(
      title: '车辆抽检',
      count: 12,
      icon: Icons.directions_car_filled_outlined,
    ),
    _WorkbenchEntry(
      title: '园区巡检',
      count: 12,
      icon: Icons.camera_outdoor_outlined,
    ),
    _WorkbenchEntry(
      title: '隐患治理',
      count: 12,
      icon: Icons.build_circle_outlined,
    ),
    _WorkbenchEntry(
      title: '异常确认',
      count: 12,
      icon: Icons.report_problem_outlined,
    ),
    _WorkbenchEntry(title: '申诉回复', count: 12, icon: Icons.message_outlined),
    _WorkbenchEntry(
      title: '报警处置',
      count: 12,
      icon: Icons.notifications_active_outlined,
    ),
    _WorkbenchEntry(
      title: '预警处置',
      count: 12,
      icon: Icons.warning_amber_rounded,
    ),
  ];

  static const List<Color> _entryColors = [
    Color(0xFF3C84F6),
    Color(0xFF4694FF),
    Color(0xFF5DA3FF),
    Color(0xFF4B8EF7),
    Color(0xFF6AA9FF),
    Color(0xFF55A0FF),
    Color(0xFF3F90F0),
    Color(0xFF5A98F3),
    Color(0xFF73B1FF),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkbenchController>(
      init: Get.isRegistered<WorkbenchController>()
          ? Get.find<WorkbenchController>()
          : WorkbenchController(),
      builder: (controller) => SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: AppDimens.dp10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF8FCFF), Color(0xFFF1F7FF), Color(0xFFF8FCFF)],
            ),
            borderRadius: BorderRadius.circular(AppDimens.dp18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TaskProgressCard(
                progressPercent: controller.taskProgressPercent,
              ),
              SizedBox(height: AppDimens.dp16),
              _PrimaryApprovalCard(
                title: '预约审批',
                count: 12,
                onTap: WorkbenchRoutes.toAppointmentApproval,
              ),
              SizedBox(height: AppDimens.dp16),
              GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _entries.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: AppDimens.dp12,
                  crossAxisSpacing: AppDimens.dp12,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  final color = _entryColors[index % _entryColors.length];
                  return _GridActionCard(
                    title: entry.title,
                    count: entry.count,
                    color: color,
                    icon: entry.icon,
                    onTap: entry.title == '白名单审批'
                        ? WorkbenchRoutes.toWhitelistApproval
                        : () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskProgressCard extends StatelessWidget {
  const _TaskProgressCard({required this.progressPercent});

  /// 接口返回百分比值（0~100）。
  final double progressPercent;

  @override
  Widget build(BuildContext context) {
    // CircularProgressIndicator 需要 0~1，因此由百分比转换为归一化进度值。
    final progress = (progressPercent / 100).clamp(0, 1).toDouble();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFE6F0FF)],
        ),
        borderRadius: BorderRadius.circular(AppDimens.dp16),
        border: Border.all(color: const Color(0xFFC7DEFF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A8CFA).withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 3,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B84F6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: AppDimens.dp6),
                    Text(
                      '任务进度跟踪',
                      style: TextStyle(
                        color: const Color(0xFF1E3858),
                        fontSize: AppDimens.sp16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimens.dp8),
                SizedBox(height: AppDimens.dp12),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.dp12,
                    vertical: AppDimens.dp4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B84F6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimens.dp20),
                  ),
                  child: Text(
                    '查看详情 >',
                    style: TextStyle(
                      color: const Color(0xFF3B84F6),
                      fontSize: AppDimens.sp10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: AppDimens.dp92,
            height: AppDimens.dp92,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: AppDimens.dp80,
                  height: AppDimens.dp80,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: AppDimens.dp10,
                    strokeCap: StrokeCap.round,
                    backgroundColor: const Color(0xFFE1EDFF),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF3B84F6),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${progressPercent.toInt()}%',
                      style: TextStyle(
                        color: const Color(0xFF1E3652),
                        fontSize: AppDimens.sp18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '完成度',
                      style: TextStyle(
                        color: const Color(0xFF4D6F96),
                        fontSize: AppDimens.sp8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryApprovalCard extends StatelessWidget {
  const _PrimaryApprovalCard({
    required this.title,
    required this.count,
    required this.onTap,
  });

  final String title;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.dp14),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: AppDimens.dp64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF3B84F6), Color(0xFF5DA3FF)],
            ),
            borderRadius: BorderRadius.circular(AppDimens.dp14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B84F6).withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                top: -10,
                child: Icon(
                  Icons.assignment_turned_in_rounded,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.dp20),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppDimens.sp16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '待处理审批任务',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: AppDimens.sp10,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimens.dp12,
                        vertical: AppDimens.dp4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppDimens.dp8),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimens.sp20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimens.dp8),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridActionCard extends StatelessWidget {
  const _GridActionCard({
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final int count;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp14),
        border: Border.all(color: const Color(0xFFE8F1FF), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.dp14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(AppDimens.dp8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: AppDimens.dp22),
              ),
              SizedBox(height: AppDimens.dp8),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF334D6A),
                  fontSize: AppDimens.sp12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppDimens.dp2),
              Text(
                '$count',
                style: TextStyle(
                  color: color,
                  fontSize: AppDimens.sp14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkbenchEntry {
  const _WorkbenchEntry({
    required this.title,
    required this.count,
    required this.icon,
  });

  final String title;
  final int count;
  final IconData icon;
}
