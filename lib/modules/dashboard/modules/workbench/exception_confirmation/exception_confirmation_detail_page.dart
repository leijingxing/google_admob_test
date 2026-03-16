import 'package:flutter/material.dart';

import '../../../../../core/constants/dimens.dart';
import '../../../../../core/utils/file_service.dart';
import '../../../../../data/models/workbench/exception_confirmation_item_model.dart';

/// 异常确认详情页。
class ExceptionConfirmationDetailPage extends StatelessWidget {
  const ExceptionConfirmationDetailPage({super.key, required this.item});

  final ExceptionConfirmationItemModel item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      appBar: AppBar(title: const Text('异常详情')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimens.dp12),
        child: Column(
          children: [
            _DetailCard(
              title: '基础信息',
              child: Column(
                children: [
                  _DetailLine(label: '上报人', value: item.reportUserName),
                  _DetailLine(label: '上报时间', value: item.reportTime),
                  _DetailLine(label: '异常位置', value: item.exceptionLocation),
                  _DetailLine(label: '位置经纬度', value: item.locationData),
                  _DetailLine(
                    label: '异常描述',
                    value: item.exceptionDesc,
                    isLast: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimens.dp12),
            _DetailCard(
              title: '确认信息',
              child: Column(
                children: [
                  _DetailLine(
                    label: '确认状态',
                    value: _statusText(item.confirmStatus),
                  ),
                  _DetailLine(label: '确认人', value: item.confirmerName),
                  _DetailLine(label: '确认时间', value: item.confirmerTime),
                  _DetailLine(label: '是否有效', value: _validText(item.isValid)),
                  _DetailLine(label: '备注', value: item.remark, isLast: true),
                ],
              ),
            ),
            SizedBox(height: AppDimens.dp12),
            _DetailCard(
              title: '现场照片',
              child: _PhotoGrid(
                photoUrls: item.exceptionImage ?? const <String>[],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusText(int value) {
    if (value == 1) return '已确认';
    if (value == 2) return '待确认';
    return '已撤销';
  }

  String _validText(int value) {
    switch (value) {
      case 1:
        return '有效';
      case 2:
        return '无效';
      default:
        return '--';
    }
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp14),
        border: Border.all(color: const Color(0xFFE1E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF1E2A3A),
              fontSize: AppDimens.sp15,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp12),
          child,
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String? value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final display = (value ?? '').trim().isEmpty ? '--' : value!.trim();

    return Container(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppDimens.dp10),
      margin: EdgeInsets.only(bottom: isLast ? 0 : AppDimens.dp10),
      decoration: isLast
          ? null
          : const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF0F3F8))),
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppDimens.dp80,
            child: Text(
              label,
              style: TextStyle(
                color: const Color(0xFF7B8798),
                fontSize: AppDimens.sp12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              display,
              style: TextStyle(
                color: const Color(0xFF263547),
                fontSize: AppDimens.sp12,
                fontWeight: FontWeight.w600,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid({required this.photoUrls});

  final List<String> photoUrls;

  @override
  Widget build(BuildContext context) {
    if (photoUrls.isEmpty) {
      return Text(
        '暂无照片',
        style: TextStyle(
          color: const Color(0xFF94A3B8),
          fontSize: AppDimens.sp12,
        ),
      );
    }

    return Wrap(
      spacing: AppDimens.dp8,
      runSpacing: AppDimens.dp8,
      children: photoUrls.map((url) {
        final imageUrl = FileService.getFaceUrl(url);
        return GestureDetector(
          onTap: imageUrl == null
              ? null
              : () => FileService.openFile(imageUrl, title: '现场照片'),
          child: Container(
            width: AppDimens.dp96,
            height: AppDimens.dp72,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FB),
              borderRadius: BorderRadius.circular(AppDimens.dp10),
              border: Border.all(color: const Color(0xFFD7E0EB)),
            ),
            child: imageUrl == null
                ? const Icon(Icons.broken_image_outlined)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.dp9),
                    child: Image.network(
                      imageUrl,
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
