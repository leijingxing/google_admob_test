import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/constants/dimens.dart';
import '../../../../../../core/utils/file_service.dart';
import 'hidden_danger_governance_detail_controller.dart';

/// 隐患治理详情页。
class HiddenDangerGovernanceDetailView extends GetView<HiddenDangerGovernanceDetailController> {
  const HiddenDangerGovernanceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HiddenDangerGovernanceDetailController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('详情')),
          backgroundColor: const Color(0xFFF4F7FB),
          body: logic.loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(AppDimens.dp12, AppDimens.dp10, AppDimens.dp12, AppDimens.dp24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DetailOverviewCard(controller: logic),
                      SizedBox(height: AppDimens.dp12),
                      _InfoSectionCard(controller: logic),
                      SizedBox(height: AppDimens.dp12),
                      _SectionHeader(title: '整改记录', subtitle: '${logic.rectifications.length}条'),
                      SizedBox(height: AppDimens.dp8),
                      _TimelineSection(nodes: logic.timelineNodes),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _DetailOverviewCard extends StatelessWidget {
  const _DetailOverviewCard({required this.controller});

  final HiddenDangerGovernanceDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(AppDimens.dp16, AppDimens.dp16, AppDimens.dp16, AppDimens.dp14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFFFFFF), Color(0xFFF2F7FF)]),
        borderRadius: BorderRadius.circular(AppDimens.dp18),
        border: Border.all(color: const Color(0xFFD9E6FB)),
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
                      controller.pointText,
                      style: TextStyle(color: const Color(0xFF223146), fontSize: AppDimens.sp18, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: AppDimens.dp6),
                    Text(
                      controller.ruleText,
                      style: TextStyle(color: const Color(0xFF6B7A90), fontSize: AppDimens.sp12),
                    ),
                  ],
                ),
              ),
              _StatusBadge(text: controller.statusText),
            ],
          ),
          SizedBox(height: AppDimens.dp14),
          Container(height: 1, color: const Color(0xFFDCE6F5)),
          SizedBox(height: AppDimens.dp14),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(label: '上报人', value: controller.reporterText),
              ),
              SizedBox(width: AppDimens.dp10),
              Expanded(
                child: _OverviewMetric(label: '上报时间', value: controller.reportTimeText),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp10),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(label: '是否紧急', value: controller.urgentText, highlight: controller.urgentText == '是'),
              ),
              SizedBox(width: AppDimens.dp10),
              Expanded(
                child: _OverviewMetric(label: '责任对象', value: controller.responsibleNameText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({required this.label, required this.value, this.highlight = false});

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp12, vertical: AppDimens.dp10),
      decoration: BoxDecoration(color: const Color(0xFFF7FAFF), borderRadius: BorderRadius.circular(AppDimens.dp12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: const Color(0xFF8090A6), fontSize: AppDimens.sp11),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: highlight ? const Color(0xFFE06A4B) : const Color(0xFF1D2B3A), fontSize: AppDimens.sp13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(text);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp12, vertical: AppDimens.dp6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: AppDimens.sp11, fontWeight: FontWeight.w700),
      ),
    );
  }

  Color _statusColor(String text) {
    switch (text) {
      case '待确认':
        return const Color(0xFF4A84F5);
      case '待整改':
      case '整改中':
        return const Color(0xFFEAA53A);
      case '待核查':
        return const Color(0xFF06BFCC);
      case '已完成':
        return const Color(0xFF22A06B);
      case '待重新指派':
        return const Color(0xFFE06A4B);
      default:
        return const Color(0xFF7B8798);
    }
  }
}

class _InfoSectionCard extends StatelessWidget {
  const _InfoSectionCard({required this.controller});

  final HiddenDangerGovernanceDetailController controller;

  @override
  Widget build(BuildContext context) {
    return AppStandardCard(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: '基础信息', subtitle: '隐患上报内容', compact: true),
          SizedBox(height: AppDimens.dp12),
          _InfoLine(label: '巡检点位', value: controller.pointText),
          _InfoLine(label: '巡检细则', value: controller.ruleText),
          _InfoLine(label: '上报人', value: controller.reporterText),
          _InfoLine(label: '上报时间', value: controller.reportTimeText),
          _InfoLine(label: '责任类型', value: controller.responsibleTypeText),
          _InfoLine(label: '责任对象', value: controller.responsibleNameText),
          _InfoLine(label: '是否紧急', value: controller.urgentText),
          _InfoLine(label: '异常状态', value: controller.statusText, emphasize: true),
          _InfoLine(label: '异常描述', value: controller.abnormalDescText, multiLine: true),
          _PhotoInfoLine(label: '现场照片', photoUrls: controller.abnormalPhotos),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle, this.compact = false});

  final String title;
  final String subtitle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: compact ? AppDimens.dp16 : AppDimens.dp18,
          decoration: BoxDecoration(color: const Color(0xFF4A84F5), borderRadius: BorderRadius.circular(999)),
        ),
        SizedBox(width: AppDimens.dp8),
        Text(
          title,
          style: TextStyle(color: const Color(0xFF223146), fontSize: compact ? AppDimens.sp14 : AppDimens.dp18, fontWeight: FontWeight.w700),
        ),
        SizedBox(width: AppDimens.dp8),
        Text(
          subtitle,
          style: TextStyle(color: const Color(0xFF7B8798), fontSize: AppDimens.sp12),
        ),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value, this.multiLine = false, this.emphasize = false});

  final String label;
  final String value;
  final bool multiLine;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimens.dp12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppDimens.dp80,
            child: Text(
              '$label：',
              style: TextStyle(color: const Color(0xFF6D7889), fontSize: AppDimens.sp12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: multiLine ? null : 2,
              overflow: multiLine ? null : TextOverflow.ellipsis,
              style: TextStyle(
                color: emphasize ? const Color(0xFF225BE6) : const Color(0xFF1D2B3A),
                fontSize: AppDimens.sp12,
                fontWeight: emphasize ? FontWeight.w700 : FontWeight.w600,
                height: multiLine ? 1.5 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoInfoLine extends StatelessWidget {
  const _PhotoInfoLine({required this.label, required this.photoUrls});

  final String label;
  final List<String> photoUrls;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppDimens.dp80,
          child: Text(
            '$label：',
            style: TextStyle(color: const Color(0xFF6D7889), fontSize: AppDimens.sp12),
          ),
        ),
        Expanded(
          child: _ThumbList(title: label, photoUrls: photoUrls),
        ),
      ],
    );
  }
}

class _TimelineSection extends StatelessWidget {
  const _TimelineSection({required this.nodes});

  final List<HiddenDangerDetailTimelineNode> nodes;

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) {
      return AppStandardCard(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimens.dp8),
            child: Text(
              '暂无整改记录',
              style: TextStyle(color: const Color(0xFF7B8798), fontSize: AppDimens.sp12),
            ),
          ),
        ),
      );
    }

    return Column(
      children: nodes.asMap().entries.map((entry) {
        return _TimelineNode(node: entry.value, isLast: entry.key == nodes.length - 1);
      }).toList(),
    );
  }
}

class _TimelineNode extends StatelessWidget {
  const _TimelineNode({required this.node, required this.isLast});

  final HiddenDangerDetailTimelineNode node;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final accentColor = _accentColor(node.title);
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppDimens.dp12),
      child: Stack(
        children: [
          if (!isLast)
            Positioned(
              left: (AppDimens.dp28 - 2) / 2,
              top: AppDimens.dp14,
              bottom: 0,
              child: Container(
                width: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [accentColor.withValues(alpha: 0.35), const Color(0xFFD9E2F1)]),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: AppDimens.dp28,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: AppDimens.dp12,
                    height: AppDimens.dp12,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.14),
                      border: Border.all(color: accentColor, width: 1.5),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppDimens.dp8),
              Expanded(
                child: AppStandardCard(
                  padding: EdgeInsets.all(AppDimens.dp12),
                  backgroundColor: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TimelineHeader(title: node.title, timeText: node.timeText, accentColor: accentColor),
                      SizedBox(height: AppDimens.dp12),
                      ..._buildLineWidgets(node.lines),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _accentColor(String title) {
    if (title.contains('初始')) return const Color(0xFF4A84F5);
    if (title.contains('驳回')) return const Color(0xFFE06A4B);
    if (title.contains('重新指派')) return const Color(0xFF7B8798);
    if (title.contains('整改')) return const Color(0xFFEAA53A);
    return const Color(0xFF4A84F5);
  }

  List<Widget> _buildLineWidgets(List<HiddenDangerDetailTimelineLine> lines) {
    final widgets = <Widget>[];
    var index = 0;

    while (index < lines.length) {
      final current = lines[index];
      if (current.isPhoto) {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: AppDimens.dp8),
            child: _TimelinePhotoLine(line: current),
          ),
        );
        index++;
        continue;
      }

      HiddenDangerDetailTimelineLine? right;
      if (index + 1 < lines.length && !lines[index + 1].isPhoto) {
        right = lines[index + 1];
        index += 2;
      } else {
        index += 1;
      }

      widgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: AppDimens.dp8),
          child: _TimelineTextLine(left: current, right: right),
        ),
      );
    }

    return widgets;
  }
}

class _TimelineHeader extends StatelessWidget {
  const _TimelineHeader({required this.title, required this.timeText, required this.accentColor});

  final String title;
  final String timeText;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp12, vertical: AppDimens.dp10),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [accentColor.withValues(alpha: 0.14), Colors.white]),
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: accentColor.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: AppDimens.dp16,
            decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(999)),
          ),
          SizedBox(width: AppDimens.dp8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: const Color(0xFF1F2D3D), fontSize: AppDimens.sp14, fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            timeText,
            style: TextStyle(color: const Color(0xFF5F6E82), fontSize: AppDimens.sp12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _TimelineTextLine extends StatelessWidget {
  const _TimelineTextLine({required this.left, this.right});

  final HiddenDangerDetailTimelineLine left;
  final HiddenDangerDetailTimelineLine? right;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _TimelineInfoCell(label: left.label, value: left.value),
        ),
        SizedBox(width: AppDimens.dp8),
        Expanded(
          child: right == null ? const SizedBox() : _TimelineInfoCell(label: right!.label, value: right!.value),
        ),
      ],
    );
  }
}

class _TimelineInfoCell extends StatelessWidget {
  const _TimelineInfoCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp10, vertical: AppDimens.dp10),
      decoration: BoxDecoration(color: const Color(0xFFF7FAFF), borderRadius: BorderRadius.circular(AppDimens.dp10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: const Color(0xFF7C8BA1), fontSize: AppDimens.sp11),
          ),
          SizedBox(height: AppDimens.dp4),
          Text(
            value,
            style: TextStyle(color: const Color(0xFF223146), fontSize: AppDimens.sp12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _TimelinePhotoLine extends StatelessWidget {
  const _TimelinePhotoLine({required this.line});

  final HiddenDangerDetailTimelineLine line;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp10),
      decoration: BoxDecoration(color: const Color(0xFFF7FAFF), borderRadius: BorderRadius.circular(AppDimens.dp10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppDimens.dp58,
            child: Text(
              '${line.label}：',
              style: TextStyle(color: const Color(0xFF7C8BA1), fontSize: AppDimens.sp11),
            ),
          ),
          Expanded(
            child: _ThumbList(title: line.label, photoUrls: line.photoUrls, emptyText: '--'),
          ),
        ],
      ),
    );
  }
}

class _ThumbList extends StatelessWidget {
  const _ThumbList({required this.title, required this.photoUrls, this.emptyText = '暂无照片'});

  final String title;
  final List<String> photoUrls;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    if (photoUrls.isEmpty) {
      return Text(
        emptyText,
        style: TextStyle(color: const Color(0xFF7B8798), fontSize: AppDimens.sp12),
      );
    }

    return Wrap(
      spacing: AppDimens.dp8,
      runSpacing: AppDimens.dp8,
      children: photoUrls.map((url) {
        final imageUrl = FileService.getFaceUrl(url);
        return InkWell(
          onTap: imageUrl == null ? null : () => FileService.openFile(imageUrl, title: title),
          borderRadius: BorderRadius.circular(AppDimens.dp8),
          child: Container(
            width: AppDimens.dp80,
            height: AppDimens.dp50,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF3F8),
              borderRadius: BorderRadius.circular(AppDimens.dp8),
              border: Border.all(color: const Color(0xFFD6DFEC)),
            ),
            child: imageUrl == null
                ? Icon(Icons.image_outlined, size: 18, color: const Color(0xFF8A9AB1))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.dp8 - 1),
                    child: Image.network(
                      imageUrl,
                      headers: FileService.imageHeaders(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image_outlined, size: 18, color: const Color(0xFF8A9AB1)),
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }
}
