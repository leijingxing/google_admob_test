import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/components/app_standard_card.dart';
import '../../../../../../../core/constants/dimens.dart';
import '../../../../../../../core/utils/file_service.dart';
import 'park_inspection_abnormal_record_controller.dart';

class ParkInspectionAbnormalRecordView
    extends GetView<ParkInspectionAbnormalRecordController> {
  const ParkInspectionAbnormalRecordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParkInspectionAbnormalRecordController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('异常记录')),
          backgroundColor: const Color(0xFFF4F7FB),
          body: logic.loading
              ? const Center(child: CircularProgressIndicator())
              : logic.abnormals.isEmpty
              ? const _EmptyState()
              : ListView.separated(
                  padding: EdgeInsets.all(AppDimens.dp12),
                  itemCount: logic.abnormals.length + 1,
                  separatorBuilder: (_, index) =>
                      SizedBox(height: AppDimens.dp12),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _SummaryHeader(
                        pointName: logic.record.pointName ?? '--',
                      );
                    }
                    final item = logic.abnormals[index - 1];
                    return AppStandardCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  logic.detailController.ruleNameById(
                                    item.ruleId,
                                  ),
                                  style: TextStyle(
                                    color: const Color(0xFF223146),
                                    fontSize: AppDimens.sp14,
                                    fontWeight: FontWeight.w700,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              SizedBox(width: AppDimens.dp10),
                              _StatusBadge(
                                text: logic.abnormalStatusText(
                                  item.abnormalStatus,
                                ),
                                color: _statusColor(item.abnormalStatus),
                              ),
                            ],
                          ),
                          SizedBox(height: AppDimens.dp12),
                          const _SectionTitle(text: '异常信息'),
                          SizedBox(height: AppDimens.dp10),
                          _InfoLine(
                            label: '上报人',
                            value: item.reporterName ?? '--',
                          ),
                          _InfoLine(
                            label: '上报时间',
                            value: item.reportTime ?? '--',
                          ),
                          _InfoLine(
                            label: '异常描述',
                            value: item.abnormalDesc ?? '--',
                          ),
                          _InfoLine(
                            label: '是否紧急',
                            value: (item.isUrgent ?? '').trim() == '1'
                                ? '是'
                                : '否',
                          ),
                          _InfoLine(
                            label: '责任对象',
                            value: item.responsibleName ?? '--',
                          ),
                          SizedBox(height: AppDimens.dp4),
                          const _SectionTitle(text: '现场附件'),
                          SizedBox(height: AppDimens.dp10),
                          _AttachmentPreview(
                            ids: item.photoUrls ?? const <String>[],
                          ),
                        ],
                      ),
                    );
                  },
                ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                AppDimens.dp12,
                AppDimens.dp10,
                AppDimens.dp12,
                AppDimens.dp10,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE7EDF5))),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0A0F172A),
                    blurRadius: 14,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: Size.fromHeight(AppDimens.dp44),
                  backgroundColor: const Color(0xFF3A78F2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.dp10),
                  ),
                  elevation: 0,
                ),
                onPressed: Get.back,
                child: const Text('返回'),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _statusColor(String? value) {
    switch ((value ?? '').trim()) {
      case 'PENDING_CONFIRM':
        return const Color(0xFFEAA53A);
      case 'PENDING_RECTIFY':
      case 'RECTIFYING':
        return const Color(0xFF3A78F2);
      case 'PENDING_VERIFY':
      case 'REASSIGN':
        return const Color(0xFFE06A4B);
      case 'COMPLETED':
        return const Color(0xFF22A06B);
      default:
        return const Color(0xFF8A97A8);
    }
  }
}

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({required this.pointName});

  final String pointName;

  @override
  Widget build(BuildContext context) {
    return AppStandardCard(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppDimens.dp12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF5F1), Color(0xFFFFFBF9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimens.dp10),
          border: Border.all(color: const Color(0xFFFFD8CB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: AppDimens.dp30,
                  height: AppDimens.dp30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE9E1),
                    borderRadius: BorderRadius.circular(AppDimens.dp9),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    size: 18,
                    color: Color(0xFFE06A4B),
                  ),
                ),
                SizedBox(width: AppDimens.dp10),
                Expanded(
                  child: Text(
                    '异常记录说明',
                    style: TextStyle(
                      color: const Color(0xFF243447),
                      fontSize: AppDimens.sp13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimens.dp8),
            Text(
              '当前点位：$pointName。此页面展示当前巡检记录关联的异常上报信息，便于跟进处理状态。',
              style: TextStyle(
                color: const Color(0xFF6C7A8C),
                fontSize: AppDimens.sp12,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppStandardCard(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.dp28,
            vertical: AppDimens.dp28,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppDimens.dp54,
                height: AppDimens.dp54,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FB),
                  borderRadius: BorderRadius.circular(AppDimens.dp18),
                ),
                child: const Icon(
                  Icons.inbox_outlined,
                  color: Color(0xFF8A97A8),
                  size: 28,
                ),
              ),
              SizedBox(height: AppDimens.dp12),
              Text(
                '暂无数据',
                style: TextStyle(
                  color: const Color(0xFF223146),
                  fontSize: AppDimens.sp13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppDimens.dp4,
          height: AppDimens.dp14,
          decoration: BoxDecoration(
            color: const Color(0xFFE06A4B),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        SizedBox(width: AppDimens.dp8),
        Text(
          text,
          style: TextStyle(
            color: const Color(0xFF223146),
            fontSize: AppDimens.sp13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp10,
        vertical: AppDimens.dp6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: AppDimens.sp11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _AttachmentPreview extends StatelessWidget {
  const _AttachmentPreview({required this.ids});

  final List<String> ids;

  @override
  Widget build(BuildContext context) {
    if (ids.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.dp12,
          vertical: AppDimens.dp14,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(AppDimens.dp10),
          border: Border.all(color: const Color(0xFFE3EAF3)),
        ),
        child: Text(
          '--',
          style: TextStyle(
            color: const Color(0xFF8A97A8),
            fontSize: AppDimens.sp12,
          ),
        ),
      );
    }
    return Wrap(
      spacing: AppDimens.dp8,
      runSpacing: AppDimens.dp8,
      children: ids.map((id) {
        final imageUrl = FileService.getFaceUrl(id);
        return InkWell(
          onTap: imageUrl == null
              ? null
              : () => FileService.openFile(imageUrl, title: '附件预览'),
          borderRadius: BorderRadius.circular(AppDimens.dp12),
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FB),
              borderRadius: BorderRadius.circular(AppDimens.dp12),
              border: Border.all(color: const Color(0xFFE2E8F2)),
            ),
            child: imageUrl == null
                ? const Icon(Icons.image_not_supported_outlined)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.dp12),
                    child: Image.network(
                      imageUrl,
                      headers: FileService.imageHeaders(),
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimens.dp10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppDimens.dp80,
            child: Text(
              '$label：',
              style: TextStyle(
                color: const Color(0xFF7B8798),
                fontSize: AppDimens.sp12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: const Color(0xFF223146),
                fontSize: AppDimens.sp12,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
