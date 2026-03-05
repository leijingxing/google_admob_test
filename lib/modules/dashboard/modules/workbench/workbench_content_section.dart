import 'package:flutter/material.dart';

import '../../../../core/constants/dimens.dart';

/// 工作台业务内容区。
class WorkbenchContentSection extends StatelessWidget {
  const WorkbenchContentSection({super.key});

  static const double _progress = 0.6;
  static const List<_WorkbenchEntry> _entries = [
    _WorkbenchEntry(title: '白名单审批', count: 12),
    _WorkbenchEntry(title: '黑名单审批', count: 12),
    _WorkbenchEntry(title: '车辆抽检', count: 12),
    _WorkbenchEntry(title: '园区巡检', count: 12),
    _WorkbenchEntry(title: '隐患治理', count: 12),
    _WorkbenchEntry(title: '异常确认', count: 12),
    _WorkbenchEntry(title: '申诉回复', count: 12),
    _WorkbenchEntry(title: '报警处置', count: 12),
    _WorkbenchEntry(title: '预警处置', count: 12),
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: AppDimens.dp10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFF8FCFF),
            const Color(0xFFF1F7FF),
            const Color(0xFFF8FCFF),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimens.dp18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TaskProgressCard(progress: _progress),
          SizedBox(height: AppDimens.dp12),
          const _PrimaryApprovalCard(title: '预约审批', count: 12),
          SizedBox(height: AppDimens.dp12),
          IgnorePointer(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _entries.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: AppDimens.dp10,
                crossAxisSpacing: AppDimens.dp10,
                childAspectRatio: 1.02,
              ),
              itemBuilder: (context, index) {
                final entry = _entries[index];
                final color = _entryColors[index % _entryColors.length];
                return _GridActionCard(
                  title: entry.title,
                  count: entry.count,
                  color: color,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskProgressCard extends StatelessWidget {
  const _TaskProgressCard({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEAF3FF), Color(0xFFDDEBFF)],
        ),
        borderRadius: BorderRadius.circular(AppDimens.dp16),
        border: Border.all(color: const Color(0xFFBDD6FC)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A8CFA).withValues(alpha: 0.09),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '任务进度跟踪',
                style: TextStyle(
                  color: const Color(0xFF1E3858),
                  fontSize: AppDimens.sp16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              IgnorePointer(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.dp10,
                    vertical: AppDimens.dp4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimens.dp8),
                    border: Border.all(color: const Color(0xFFC3D8FA)),
                  ),
                  child: Text(
                    '更多 >',
                    style: TextStyle(
                      color: const Color(0xFF3A73D9),
                      fontSize: AppDimens.sp10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '本周审批任务完成率',
            style: TextStyle(
              color: const Color(0xFF5E7B9D),
              fontSize: AppDimens.sp10,
            ),
          ),
          SizedBox(height: AppDimens.dp16),
          Center(
            child: SizedBox(
              width: AppDimens.dp150,
              height: AppDimens.dp150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: AppDimens.dp150,
                    height: AppDimens.dp150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white,
                          const Color(0xFFCFE3FF).withValues(alpha: 0.45),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: AppDimens.dp140,
                    height: AppDimens.dp140,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: AppDimens.dp12,
                      strokeCap: StrokeCap.round,
                      backgroundColor: const Color(0xFFD9E6FA),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF3B84F6),
                      ),
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${(progress * 100).toInt()}',
                          style: TextStyle(
                            color: const Color(0xFF1E3652),
                            fontSize: AppDimens.sp30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: '%',
                          style: TextStyle(
                            color: const Color(0xFF4D6F96),
                            fontSize: AppDimens.sp16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryApprovalCard extends StatelessWidget {
  const _PrimaryApprovalCard({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: double.infinity,
        height: AppDimens.dp84,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FCFF), Color(0xFFF1F7FF)],
          ),
          borderRadius: BorderRadius.circular(AppDimens.dp12),
          border: Border.all(color: const Color(0xFFD8E7FC)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A8CFA).withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF334D6A),
                fontSize: AppDimens.sp14,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppDimens.dp4),
            Text(
              '$count',
              style: TextStyle(
                color: const Color(0xFF3A73D9),
                fontSize: AppDimens.sp16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
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
  });

  final String title;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.98,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.dp6,
          vertical: AppDimens.dp10,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withValues(alpha: 0.14),
              color.withValues(alpha: 0.04),
            ],
          ),
          borderRadius: BorderRadius.circular(AppDimens.dp14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF304B69),
                fontSize: AppDimens.sp12,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppDimens.dp6),
            Text(
              '$count',
              style: TextStyle(
                color: color,
                fontSize: AppDimens.sp16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkbenchEntry {
  const _WorkbenchEntry({required this.title, required this.count});

  final String title;
  final int count;
}
