import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/repository/file_repository.dart';
import '../../utils/file_service.dart';
import '../toast/toast_widget.dart';

/// 通用图片选择上传组件。
///
/// 功能：
/// - 从相册选择图片
/// - 调用 [FileRepository] 分片上传
/// - 展示已选图片
/// - 支持预览与删除
class CustomPickerPhoto extends StatefulWidget {
  /// 默认图片大小上限（10MB）。
  static const int defaultMaxImageSizeBytes = 10 * 1024 * 1024;

  const CustomPickerPhoto({
    super.key,
    required this.title,
    required this.imagesList,
    this.callback,
    this.onImage,
    this.isRequired = false,
    this.maxCount = 9,
    this.isEnabled = true,
    this.isShowTitle = true,
    this.maxFileSizeBytes = defaultMaxImageSizeBytes,
    this.titleTextStyle,
  });

  final String title;
  final List<String> imagesList;
  final ValueChanged<List<String>>? callback;
  final ValueChanged<Uint8List>? onImage;
  final bool isRequired;
  final int maxCount;
  final bool isEnabled;
  final bool isShowTitle;
  final int? maxFileSizeBytes;
  final TextStyle? titleTextStyle;

  @override
  State<CustomPickerPhoto> createState() => _CustomPickerPhotoState();
}

class _CustomPickerPhotoState extends State<CustomPickerPhoto> {
  final ImagePicker _picker = ImagePicker();
  final FileRepository _fileRepository = FileRepository();

  late List<String> _imageList;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _imageList = List<String>.from(widget.imagesList);
  }

  @override
  void didUpdateWidget(covariant CustomPickerPhoto oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_sameList(oldWidget.imagesList, widget.imagesList)) {
      _imageList = List<String>.from(widget.imagesList);
    }
  }

  Future<void> _pickFromGallery() async {
    if (_uploading) return;
    final remainingCount = widget.maxCount - _imageList.length;
    if (remainingCount <= 0) {
      AppToast.showWarning('已达到最大上传数量');
      return;
    }

    try {
      final files = await _picker.pickMultiImage(limit: remainingCount);
      if (files.isEmpty) {
        AppToast.showInfo('未选择图片');
        return;
      }

      _uploading = true;
      if (mounted) setState(() {});

      for (final file in files) {
        try {
          final bytes = await file.readAsBytes();
          widget.onImage?.call(bytes);

          final fileId = await _fileRepository.uploadFileByChunks(
            filePath: file.path,
            originalFileName: file.name,
            maxFileSizeBytes: widget.maxFileSizeBytes,
          );

          if (fileId.isNotEmpty) {
            _imageList.add(fileId);
          }
        } catch (error) {
          AppToast.showWarning(_extractErrorMessage(error));
        }
      }

      widget.callback?.call(List<String>.from(_imageList));
      if (mounted) setState(() {});
    } catch (error) {
      AppToast.showWarning(_extractErrorMessage(error));
    } finally {
      _uploading = false;
      if (mounted) setState(() {});
    }
  }

  void _removeAt(String item) {
    _imageList.remove(item);
    widget.callback?.call(List<String>.from(_imageList));
    setState(() {});
  }

  bool _sameList(List<String> left, List<String> right) {
    if (left.length != right.length) return false;
    for (var i = 0; i < left.length; i++) {
      if (left[i] != right[i]) return false;
    }
    return true;
  }

  String _extractErrorMessage(Object error) {
    final message = error.toString();
    const prefix = 'Exception: ';
    if (message.startsWith(prefix)) {
      return message.substring(prefix.length);
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isShowTitle) ...[
          Row(
            children: [
              if (widget.isRequired)
                const Text('*', style: TextStyle(color: Colors.red)),
              if (widget.isRequired) const SizedBox(width: 2),
              Text(
                widget.title,
                style:
                    widget.titleTextStyle ??
                    const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              if (widget.isEnabled)
                Text(
                  '${_imageList.length}/${widget.maxCount}',
                  style: const TextStyle(
                    color: Color(0xFF8D95A3),
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._imageList.map(_buildImageTile),
            if (widget.isEnabled && _imageList.length < widget.maxCount)
              _buildAddTile(),
          ],
        ),
      ],
    );
  }

  Widget _buildImageTile(String item) {
    final imageUrl = FileService.getFaceUrl(item);
    return Stack(
      children: [
        InkWell(
          onTap: imageUrl == null
              ? null
              : () => FileService.openFile(imageUrl, title: widget.title),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7FB),
              border: Border.all(color: const Color(0xFFEBEDF0)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: imageUrl == null
                ? const Icon(Icons.image_not_supported_outlined)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      headers: FileService.imageHeaders(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
                  ),
          ),
        ),
        if (widget.isEnabled)
          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
              onTap: () => _removeAt(item),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 14,
                  color: Color(0xFF8D95A3),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddTile() {
    return InkWell(
      onTap: _pickFromGallery,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 78,
        height: 78,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7FB),
          border: Border.all(color: const Color(0xFFEBEDF0)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _uploading
            ? const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_camera_outlined,
                    color: Color(0xFF8D95A3),
                    size: 24,
                  ),
                  SizedBox(height: 6),
                  Text(
                    '点击上传',
                    style: TextStyle(color: Color(0xFF8D95A3), fontSize: 12),
                  ),
                ],
              ),
      ),
    );
  }
}
