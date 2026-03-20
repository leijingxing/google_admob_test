// dart format width=160

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/.gitkeep
  String get aGitkeep => 'assets/images/.gitkeep';

  /// Directory path: assets/images/reader
  $AssetsImagesReaderGen get reader => const $AssetsImagesReaderGen();

  /// List of all assets
  List<String> get values => [aGitkeep];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/.gitkeep
  String get aGitkeep => 'assets/svg/.gitkeep';

  /// List of all assets
  List<String> get values => [aGitkeep];
}

class $AssetsImagesReaderGen {
  const $AssetsImagesReaderGen();

  /// File path: assets/images/reader/mist_port_cover.png
  AssetGenImage get mistPortCover => const AssetGenImage('assets/images/reader/mist_port_cover.png');

  /// File path: assets/images/reader/mist_port_page_1.png
  AssetGenImage get mistPortPage1 => const AssetGenImage('assets/images/reader/mist_port_page_1.png');

  /// File path: assets/images/reader/mist_port_page_2.png
  AssetGenImage get mistPortPage2 => const AssetGenImage('assets/images/reader/mist_port_page_2.png');

  /// File path: assets/images/reader/mist_port_page_3.png
  AssetGenImage get mistPortPage3 => const AssetGenImage('assets/images/reader/mist_port_page_3.png');

  /// File path: assets/images/reader/mist_port_page_4.png
  AssetGenImage get mistPortPage4 => const AssetGenImage('assets/images/reader/mist_port_page_4.png');

  /// File path: assets/images/reader/paper_bird_cover.png
  AssetGenImage get paperBirdCover => const AssetGenImage('assets/images/reader/paper_bird_cover.png');

  /// File path: assets/images/reader/paper_bird_page_1.png
  AssetGenImage get paperBirdPage1 => const AssetGenImage('assets/images/reader/paper_bird_page_1.png');

  /// File path: assets/images/reader/paper_bird_page_2.png
  AssetGenImage get paperBirdPage2 => const AssetGenImage('assets/images/reader/paper_bird_page_2.png');

  /// File path: assets/images/reader/paper_bird_page_3.png
  AssetGenImage get paperBirdPage3 => const AssetGenImage('assets/images/reader/paper_bird_page_3.png');

  /// File path: assets/images/reader/paper_bird_page_4.png
  AssetGenImage get paperBirdPage4 => const AssetGenImage('assets/images/reader/paper_bird_page_4.png');

  /// File path: assets/images/reader/star_hotel_cover.png
  AssetGenImage get starHotelCover => const AssetGenImage('assets/images/reader/star_hotel_cover.png');

  /// File path: assets/images/reader/star_hotel_page_1.png
  AssetGenImage get starHotelPage1 => const AssetGenImage('assets/images/reader/star_hotel_page_1.png');

  /// File path: assets/images/reader/star_hotel_page_2.png
  AssetGenImage get starHotelPage2 => const AssetGenImage('assets/images/reader/star_hotel_page_2.png');

  /// File path: assets/images/reader/star_hotel_page_3.png
  AssetGenImage get starHotelPage3 => const AssetGenImage('assets/images/reader/star_hotel_page_3.png');

  /// File path: assets/images/reader/star_hotel_page_4.png
  AssetGenImage get starHotelPage4 => const AssetGenImage('assets/images/reader/star_hotel_page_4.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    mistPortCover,
    mistPortPage1,
    mistPortPage2,
    mistPortPage3,
    mistPortPage4,
    paperBirdCover,
    paperBirdPage1,
    paperBirdPage2,
    paperBirdPage3,
    paperBirdPage4,
    starHotelCover,
    starHotelPage1,
    starHotelPage2,
    starHotelPage3,
    starHotelPage4,
  ];
}

class Assets {
  const Assets._();

  static const AssetGenImage appLogo = AssetGenImage('assets/app-logo.png');
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();

  /// List of all assets
  static List<AssetGenImage> get values => [appLogo];
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}, this.animation});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({required this.isAnimation, required this.duration, required this.frames});

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
