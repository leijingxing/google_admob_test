import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/constants/dimens.dart';
import '../../../../../../core/utils/file_service.dart';
import 'blacklist_approval_detail_controller.dart';

/// 黑名单详情页。
class BlacklistApprovalDetailView
    extends GetView<BlacklistApprovalDetailController> {
  const BlacklistApprovalDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BlacklistApprovalDetailController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('详情')),
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
                      _TimelineBlock(
                        title: '发起申请',
                        timeText: logic.applyTimeText,
                        sections: logic.applySections,
                        lineVisible: true,
                        accentColor: const Color(0xFF4A84F5),
                      ),
                      _TimelineBlock(
                        title: logic.approveNodeTitle,
                        timeText: logic.approveTimeText,
                        sections: logic.approveSections,
                        lineVisible: false,
                        accentColor: _approveAccentColor(
                          logic.source['parkCheckStatus'],
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Color _approveAccentColor(Object? status) {
    final code = int.tryParse((status ?? '').toString()) ?? 0;
    switch (code) {
      case 1:
        return const Color(0xFF22A06B);
      case 2:
        return const Color(0xFFE06A4B);
      default:
        return const Color(0xFF7B8798);
    }
  }
}

/// 时间轴区块，左侧为节点，右侧为业务卡片。
class _TimelineBlock extends StatelessWidget {
  const _TimelineBlock({
    required this.title,
    required this.timeText,
    required this.sections,
    required this.lineVisible,
    required this.accentColor,
  });

  final String title;
  final String timeText;
  final List<BlacklistDetailSection> sections;
  final bool lineVisible;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: lineVisible ? AppDimens.dp20 : 0),
      child: Stack(
        children: [
          if (lineVisible)
            Positioned(
              left: (AppDimens.dp28 - 2) / 2,
              top: AppDimens.dp14,
              bottom: 0,
              child: Container(
                width: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      accentColor.withValues(alpha: 0.35),
                      const Color(0xFFD9E2F1),
                    ],
                  ),
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
                        decoration: BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppDimens.dp8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TimelineHeader(
                      title: title,
                      timeText: timeText,
                      accentColor: accentColor,
                    ),
                    SizedBox(height: AppDimens.dp10),
                    ...sections.map((section) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: AppDimens.dp10),
                        child: _SectionCard(
                          title: section.title,
                          lines: section.lines,
                          accentColor: accentColor,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineHeader extends StatelessWidget {
  const _TimelineHeader({
    required this.title,
    required this.timeText,
    required this.accentColor,
  });

  final String title;
  final String timeText;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp12,
        vertical: AppDimens.dp10,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [accentColor.withValues(alpha: 0.14), Colors.white],
        ),
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: accentColor.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: AppDimens.dp16,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          SizedBox(width: AppDimens.dp8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: const Color(0xFF1F2D3D),
                fontSize: AppDimens.sp14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            timeText,
            style: TextStyle(
              color: const Color(0xFF5F6E82),
              fontSize: AppDimens.sp12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// 业务信息分组卡片。
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.lines,
    required this.accentColor,
  });

  final String title;
  final List<BlacklistDetailLine> lines;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return AppStandardCard(
      padding: EdgeInsets.all(AppDimens.dp12),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Row(
              children: [
                Container(
                  width: AppDimens.dp8,
                  height: AppDimens.dp8,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: AppDimens.dp8),
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF223246),
                    fontSize: AppDimens.sp13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimens.dp12),
          ],
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columnCount = width >= 760
                  ? 3
                  : width >= 460
                  ? 2
                  : 1;
              final spacing = AppDimens.dp10;
              final itemWidth =
                  (width - spacing * (columnCount - 1)) / columnCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: lines.map((line) {
                  return SizedBox(
                    width: itemWidth,
                    child: _DetailTile(line: line),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({required this.line});

  final BlacklistDetailLine line;

  @override
  Widget build(BuildContext context) {
    final isImage = _isImageField(line.label);
    final isStatus = line.label == '有效状态' || line.label == '审批状态';

    return Container(
      constraints: BoxConstraints(minHeight: AppDimens.dp64),
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
              color: const Color(0xFF5E6D82),
              fontSize: AppDimens.sp11,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDimens.dp8),
          if (isImage)
            _ImageGallery(title: line.label, rawValue: line.value)
          else if (isStatus)
            _StatusPill(label: line.value, isApprove: line.label == '审批状态')
          else
            Text(
              line.value,
              style: TextStyle(
                color: const Color(0xFF1E2E42),
                fontSize: AppDimens.sp13,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
        ],
      ),
    );
  }

  bool _isImageField(String label) {
    const labels = <String>{'行驶证', '挂车行驶证', '照片', '附件'};
    return labels.contains(label) || label.contains('照片');
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.isApprove});

  final String label;
  final bool isApprove;

  @override
  Widget build(BuildContext context) {
    final style = _style(label, isApprove);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp10,
        vertical: AppDimens.dp6,
      ),
      decoration: BoxDecoration(
        color: style.$2,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: style.$1,
          fontSize: AppDimens.sp11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  (Color, Color) _style(String text, bool isApprove) {
    if (!isApprove) {
      return text == '有效'
          ? (const Color(0xFFBA6A08), const Color(0xFFFFF3E6))
          : (const Color(0xFF6E7B8C), const Color(0xFFF1F3F7));
    }
    switch (text) {
      case '已通过':
        return (const Color(0xFF0E8C4C), const Color(0xFFE7F8EE));
      case '已拒绝':
        return (const Color(0xFFDA5A18), const Color(0xFFFFF1E8));
      default:
        return (const Color(0xFF1E4FCF), const Color(0xFFEAF1FF));
    }
  }
}

class _ImageGallery extends StatelessWidget {
  const _ImageGallery({required this.title, required this.rawValue});

  final String title;
  final String rawValue;

  @override
  Widget build(BuildContext context) {
    final urls = rawValue
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && e != '--' && e.toLowerCase() != 'null')
        .toList();

    if (urls.isEmpty) {
      return _ImagePlaceholder(title: title, imageUrl: null);
    }

    return Wrap(
      spacing: AppDimens.dp8,
      runSpacing: AppDimens.dp8,
      children: urls.map((url) {
        return _ImagePlaceholder(
          title: title,
          imageUrl: FileService.getFaceUrl(url),
        );
      }).toList(),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.title, required this.imageUrl});

  final String title;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: imageUrl == null
          ? null
          : () => FileService.openFile(imageUrl, title: title),
      borderRadius: BorderRadius.circular(AppDimens.dp10),
      child: Container(
        width: AppDimens.dp96,
        height: AppDimens.dp64,
        decoration: BoxDecoration(
          color: const Color(0xFFEEF3F8),
          borderRadius: BorderRadius.circular(AppDimens.dp10),
          border: Border.all(color: const Color(0xFFD8E1EC)),
        ),
        child: imageUrl == null
            ? Icon(
                Icons.image_outlined,
                size: 20,
                color: const Color(0xFF8A9AB1),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(AppDimens.dp9),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      imageUrl!,
                      headers: FileService.imageHeaders(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.broken_image_outlined,
                        size: 20,
                        color: const Color(0xFF8A9AB1),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.all(AppDimens.dp6),
                        padding: EdgeInsets.all(AppDimens.dp4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.open_in_full_rounded,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
