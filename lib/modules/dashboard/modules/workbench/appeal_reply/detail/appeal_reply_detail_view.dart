import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/constants/dimens.dart';
import 'appeal_reply_detail_controller.dart';

/// 申诉回复详情页。
class AppealReplyDetailView extends GetView<AppealReplyDetailController> {
  const AppealReplyDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppealReplyDetailController>(
      builder: (logic) {
        final headerAccent = _statusAccentColor(logic.item.status);
        final targetValue = _display(logic.item.targetValue);

        return Scaffold(
          appBar: AppBar(title: const Text('申诉详情')),
          backgroundColor: const Color(0xFFF4F7FB),
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppDimens.dp12,
              AppDimens.dp10,
              AppDimens.dp12,
              AppDimens.dp24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SummaryCard(
                  targetValue: targetValue,
                  appealTypeText: logic.appealTypeText(),
                  statusText: logic.statusText(),
                  appealTime: _display(logic.item.appealTime),
                  applicant: _display(logic.item.applicant),
                  accentColor: headerAccent,
                ),
                SizedBox(height: AppDimens.dp12),
                _SectionCard(
                  title: '基础信息',
                  icon: Icons.info_outline_rounded,
                  child: Column(
                    children: [
                      _InfoGrid(
                        items: [
                          _InfoItem(
                            label: '申诉类型',
                            value: logic.appealTypeText(),
                          ),
                          _InfoItem(label: '处理状态', value: logic.statusText()),
                          _InfoItem(label: '姓名/车牌', value: targetValue),
                          _InfoItem(
                            label: '申诉人',
                            value: _display(logic.item.applicant),
                          ),
                          _InfoItem(
                            label: '申诉时间',
                            value: _display(logic.item.appealTime),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppDimens.dp12),
                _SectionCard(
                  title: '异常说明',
                  icon: Icons.report_problem_outlined,
                  child: _ContentBlock(
                    title: '异常描述',
                    content: _display(logic.item.abnormalDesc),
                    accentColor: const Color(0xFF5A8EF5),
                  ),
                ),
                SizedBox(height: AppDimens.dp12),
                _SectionCard(
                  title: '申诉与回复',
                  icon: Icons.forum_outlined,
                  child: Column(
                    children: [
                      _ContentBlock(
                        title: '申诉描述',
                        content: _display(logic.item.appealDesc),
                        accentColor: const Color(0xFF4C8DFF),
                      ),
                      SizedBox(height: AppDimens.dp10),
                      _ContentBlock(
                        title: '回复描述',
                        content: _display(logic.item.reply),
                        accentColor: _statusAccentColor(logic.item.status),
                        emptyHint: '暂未回复',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _statusAccentColor(int status) {
    switch (status) {
      case 1:
        return const Color(0xFF1C9B63);
      case 2:
        return const Color(0xFFE07A34);
      default:
        return const Color(0xFF3F7CF6);
    }
  }

  String _display(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? '--' : text;
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.targetValue,
    required this.appealTypeText,
    required this.statusText,
    required this.appealTime,
    required this.applicant,
    required this.accentColor,
  });

  final String targetValue;
  final String appealTypeText;
  final String statusText;
  final String appealTime;
  final String applicant;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withValues(alpha: 0.06),
            accentColor.withValues(alpha: 0.025),
            const Color(0xFFFCFDFF),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimens.dp16),
        border: Border.all(color: accentColor.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      targetValue,
                      style: TextStyle(
                        color: const Color(0xFF1C2C40),
                        fontSize: AppDimens.sp18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppDimens.dp6),
                    Text(
                      appealTypeText,
                      style: TextStyle(
                        color: const Color(0xFF5F7085),
                        fontSize: AppDimens.sp12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(label: statusText, accentColor: accentColor),
            ],
          ),
          SizedBox(height: AppDimens.dp14),
          Row(
            children: [
              Expanded(
                child: _MetaChip(
                  icon: Icons.person_outline_rounded,
                  label: '申诉人',
                  value: applicant,
                ),
              ),
              SizedBox(width: AppDimens.dp10),
              Expanded(
                child: _MetaChip(
                  icon: Icons.schedule_rounded,
                  label: '申诉时间',
                  value: appealTime,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.accentColor});

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp12,
        vertical: AppDimens.dp6,
      ),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accentColor.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: accentColor,
          fontSize: AppDimens.sp12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp12,
        vertical: AppDimens.dp10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: const Color(0xFFE4EBF5)),
      ),
      child: Row(
        children: [
          Container(
            width: AppDimens.dp28,
            height: AppDimens.dp28,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(AppDimens.dp8),
            ),
            child: Icon(icon, color: const Color(0xFF4A84F5), size: 16),
          ),
          SizedBox(width: AppDimens.dp8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: const Color(0xFF7A8797),
                    fontSize: AppDimens.sp10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppDimens.dp2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF223246),
                    fontSize: AppDimens.sp12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppStandardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppDimens.dp28,
                height: AppDimens.dp28,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FF),
                  borderRadius: BorderRadius.circular(AppDimens.dp8),
                ),
                child: Icon(icon, color: const Color(0xFF4A84F5), size: 16),
              ),
              SizedBox(width: AppDimens.dp8),
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF1E2E42),
                  fontSize: AppDimens.sp14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp12),
          child,
        ],
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.items});

  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columnCount = width >= 520 ? 2 : 1;
        final spacing = AppDimens.dp10;
        final itemWidth = (width - spacing * (columnCount - 1)) / columnCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items.map((item) {
            return SizedBox(
              width: itemWidth,
              child: Container(
                padding: EdgeInsets.all(AppDimens.dp10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9FC),
                  borderRadius: BorderRadius.circular(AppDimens.dp10),
                  border: Border.all(color: const Color(0xFFE6ECF5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: TextStyle(
                        color: const Color(0xFF6B788B),
                        fontSize: AppDimens.sp11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppDimens.dp6),
                    Text(
                      item.value,
                      style: TextStyle(
                        color: const Color(0xFF1E2E42),
                        fontSize: AppDimens.sp13,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _ContentBlock extends StatelessWidget {
  const _ContentBlock({
    required this.title,
    required this.content,
    required this.accentColor,
    this.emptyHint,
  });

  final String title;
  final String content;
  final Color accentColor;
  final String? emptyHint;

  @override
  Widget build(BuildContext context) {
    final isEmpty = content == '--';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: const Color(0xFFE4EAF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: AppDimens.dp14,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              SizedBox(width: AppDimens.dp8),
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF223246),
                  fontSize: AppDimens.sp12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp10),
          Text(
            isEmpty && emptyHint != null ? emptyHint! : content,
            style: TextStyle(
              color: isEmpty
                  ? const Color(0xFF8B96A5)
                  : const Color(0xFF2A3950),
              fontSize: AppDimens.sp13,
              fontWeight: isEmpty ? FontWeight.w500 : FontWeight.w600,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem {
  const _InfoItem({required this.label, required this.value});

  final String label;
  final String value;
}
