import 'dart:io';

import 'package:flutter/material.dart';

/// 图片预览页，支持网络地址与本地路径。
class ImageViewerPage extends StatelessWidget {
  const ImageViewerPage({
    required this.imageUrl,
    super.key,
    this.headers,
    this.title,
    this.appBarColor,
  });

  final String imageUrl;
  final Map<String, String>? headers;
  final String? title;
  final Color? appBarColor;

  bool get _isNetworkImage =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final widget = _isNetworkImage
        ? Image.network(imageUrl, headers: headers, fit: BoxFit.contain)
        : Image.file(File(imageUrl), fit: BoxFit.contain);

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? '图片预览'),
        backgroundColor: appBarColor,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(minScale: 0.8, maxScale: 4, child: widget),
      ),
    );
  }
}
