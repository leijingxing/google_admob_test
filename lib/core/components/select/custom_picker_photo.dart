import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/repository/file_repository.dart';
import '../../utils/file_service.dart';
import '../toast/toast_widget.dart';

/// 通用图片选择上传组件。
///
/// 功能：
/// - 从相册选择图片或视频
/// - 调用 [FileRepository] 分片上传
/// - 展示已选媒体
/// - 支持预览与删除
enum CustomPickerMediaType { image, video }

enum _CustomPickerSourceAction { camera, gallery }

class CustomPickerPhoto extends StatefulWidget {
  /// 默认图片大小上限（10MB）。
  static const int defaultMaxImageSizeBytes = 10 * 1024 * 1024;

  /// 默认视频大小上限（100MB）。
  static const int defaultMaxVideoSizeBytes = 100 * 1024 * 1024;

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
    this.mediaType = CustomPickerMediaType.image,
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
  final CustomPickerMediaType mediaType;

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
      final source = await _showSourcePickerSheet();
      if (source == null) {
        return;
      }

      final files = await _pickFiles(
        remainingCount: remainingCount,
        source: source,
      );
      if (files.isEmpty) {
        AppToast.showInfo(
          widget.mediaType == CustomPickerMediaType.video ? '未选择视频' : '未选择图片',
        );
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

  Future<_CustomPickerSourceAction?> _showSourcePickerSheet() {
    return showModalBottomSheet<_CustomPickerSourceAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildSheetAction(
                        label: '拍摄',
                        onTap: () => Navigator.of(
                          sheetContext,
                        ).pop(_CustomPickerSourceAction.camera),
                      ),
                      const Divider(height: 1, color: Color(0xFFF0F2F5)),
                      _buildSheetAction(
                        label: '从相册选择',
                        onTap: () => Navigator.of(
                          sheetContext,
                        ).pop(_CustomPickerSourceAction.gallery),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: _buildSheetAction(
                    label: '取消',
                    onTap: () => Navigator.of(sheetContext).pop(),
                    isCancel: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSheetAction({
    required String label,
    required VoidCallback onTap,
    bool isCancel = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isCancel
                  ? const Color(0xFF2B3A4F)
                  : const Color(0xFF1F2D3D),
              fontSize: 16,
              fontWeight: isCancel ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Future<List<XFile>> _pickFiles({
    required int remainingCount,
    required _CustomPickerSourceAction source,
  }) async {
    if (widget.mediaType == CustomPickerMediaType.video) {
      final file = await _picker.pickVideo(
        source: source == _CustomPickerSourceAction.camera
            ? ImageSource.camera
            : ImageSource.gallery,
      );
      if (file == null) return const <XFile>[];
      return <XFile>[file];
    }
    if (source == _CustomPickerSourceAction.camera) {
      final file = await _picker.pickImage(source: ImageSource.camera);
      if (file == null) return const <XFile>[];
      return <XFile>[file];
    }
    return _picker.pickMultiImage(limit: remainingCount);
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
    final isVideo = _isVideoItem(item);
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
                : isVideo
                ? _buildVideoTile()
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

  bool _isVideoItem(String item) {
    final url = FileService.getFaceUrl(item) ?? item;
    final lower = url.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.avi') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.mkv');
  }

  Widget _buildVideoTile() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFEEF5FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videocam_outlined, color: Color(0xFF4B6BFB), size: 24),
          SizedBox(height: 6),
          Text(
            '点击查看',
            style: TextStyle(color: Color(0xFF4B6BFB), fontSize: 12),
          ),
        ],
      ),
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
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.mediaType == CustomPickerMediaType.video
                        ? Icons.video_library_outlined
                        : Icons.photo_camera_outlined,
                    color: const Color(0xFF8D95A3),
                    size: 24,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.mediaType == CustomPickerMediaType.video
                        ? '选择视频'
                        : '点击上传',
                    style: const TextStyle(
                      color: Color(0xFF8D95A3),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
