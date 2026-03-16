import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/constants/dimens.dart';
import '../../../../../../core/utils/file_service.dart';
import 'alarm_disposal_detail_controller.dart';

const Color _alarmAccentColor = Color(0xFFE53935);
const Color _alarmAccentSoftColor = Color(0xFFFFEBEE);
const Color _alarmAccentBorderColor = Color(0xFFF2C7CB);

/// 报警详情页。
class AlarmDisposalDetailView extends GetView<AlarmDisposalDetailController> {
  const AlarmDisposalDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlarmDisposalDetailController>(
      builder: (logic) {
        final item = logic.source;
        return Scaffold(
          appBar: AppBar(title: const Text('报警详情')),
          backgroundColor: const Color(0xFFF4F7FB),
          body: logic.loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    AppDimens.dp12,
                    AppDimens.dp10,
                    AppDimens.dp12,
                    AppDimens.dp24,
                  ),
                  child: Column(
                    children: [
                      _SummaryCard(
                        title: logic.display(item.title),
                        statusText: logic.statusText(),
                        timeText: logic.display(item.warningStartTime),
                      ),
                      SizedBox(height: AppDimens.dp12),
                      _InfoCard(
                        title: '基础信息',
                        lines: [
                          _InfoLine(
                            label: '报警名称',
                            value: logic.display(item.title),
                          ),
                          _InfoLine(label: '报警状态', value: logic.statusText()),
                          _InfoLine(
                            label: '报警等级',
                            value: logic.warningLevelText(),
                          ),
                          _InfoLine(
                            label: '报警来源',
                            value: logic.warningSourceText(),
                          ),
                          _InfoLine(
                            label: '报警设备',
                            value: logic.display(item.deviceName),
                          ),
                          _InfoLine(
                            label: '发生位置',
                            value: logic.display(item.position),
                          ),
                          _InfoLine(
                            label: '报警开始时间',
                            value: logic.display(item.warningStartTime),
                          ),
                          _InfoLine(
                            label: '报警结束时间',
                            value: logic.display(item.warningEndTime),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimens.dp12),
                      _ContentCard(
                        title: '报警内容',
                        content: logic.display(item.description),
                      ),
                      SizedBox(height: AppDimens.dp12),
                      _InfoCard(
                        title: '处置信息',
                        lines: [
                          _InfoLine(
                            label: '处置类型',
                            value: logic.disposalCategoryText(),
                          ),
                          _InfoLine(
                            label: '处置描述',
                            value: logic.display(item.disposalResult),
                          ),
                        ],
                        attachments: item.disposalFiles,
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.statusText,
    required this.timeText,
  });

  final String title;
  final String statusText;
  final String timeText;

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
            _alarmAccentColor.withValues(alpha: 0.08),
            _alarmAccentColor.withValues(alpha: 0.02),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimens.dp16),
        border: Border.all(color: _alarmAccentBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF1C2C40),
                    fontSize: AppDimens.sp18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.dp12,
                  vertical: AppDimens.dp6,
                ),
                decoration: BoxDecoration(
                  color: _alarmAccentSoftColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: _alarmAccentColor,
                    fontSize: AppDimens.sp12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp10),
          Text(
            '开始时间：$timeText',
            style: TextStyle(
              color: const Color(0xFF5E6D82),
              fontSize: AppDimens.sp12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.lines, this.attachments});

  final String title;
  final List<_InfoLine> lines;
  final List<String>? attachments;

  @override
  Widget build(BuildContext context) {
    return AppStandardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF223246),
              fontSize: AppDimens.sp14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp12),
          ...lines.map((line) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppDimens.dp10),
              child: _LineTile(line: line),
            );
          }),
          if (attachments != null) ...[
            Text(
              '附件',
              style: TextStyle(
                color: const Color(0xFF5E6D82),
                fontSize: AppDimens.sp11,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppDimens.dp8),
            _AttachmentGrid(attachments: attachments!),
          ],
        ],
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AppStandardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF223246),
              fontSize: AppDimens.sp14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp12),
          Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: AppDimens.dp88),
            padding: EdgeInsets.all(AppDimens.dp12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(AppDimens.dp10),
              border: Border.all(color: const Color(0xFFE6ECF5)),
            ),
            child: Text(
              content,
              style: TextStyle(
                color: const Color(0xFF2A3950),
                fontSize: AppDimens.sp13,
                fontWeight: FontWeight.w600,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LineTile extends StatelessWidget {
  const _LineTile({required this.line});

  final _InfoLine line;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            line.label,
            style: TextStyle(
              color: const Color(0xFF6B788B),
              fontSize: AppDimens.sp11,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            line.value,
            style: TextStyle(
              color: const Color(0xFF1E2E42),
              fontSize: AppDimens.sp13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentGrid extends StatelessWidget {
  const _AttachmentGrid({required this.attachments});

  final List<String> attachments;

  @override
  Widget build(BuildContext context) {
    final validList = attachments
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && e.toLowerCase() != 'null')
        .toList();

    if (validList.isEmpty) {
      return const Text('--');
    }

    return Wrap(
      spacing: AppDimens.dp8,
      runSpacing: AppDimens.dp8,
      children: validList.map((item) {
        final url = FileService.getFaceUrl(item);
        return InkWell(
          onTap: url == null
              ? null
              : () => FileService.openFile(url, title: '附件'),
          borderRadius: BorderRadius.circular(AppDimens.dp10),
          child: Container(
            width: AppDimens.dp96,
            height: AppDimens.dp64,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F5FA),
              borderRadius: BorderRadius.circular(AppDimens.dp10),
              border: Border.all(color: const Color(0xFFD8E1EC)),
            ),
            child: url == null
                ? const Icon(Icons.insert_drive_file_outlined)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.dp9),
                    child: Image.network(
                      url,
                      headers: FileService.imageHeaders(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }
}

class _InfoLine {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;
}
