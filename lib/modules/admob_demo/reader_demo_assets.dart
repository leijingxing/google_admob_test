import '../../data/models/reader/reader_demo_models.dart';
import '../../generated/assets.gen.dart';

/// 阅读器资源映射。
class ReaderDemoAssets {
  ReaderDemoAssets._();

  static AssetGenImage coverOf(ReaderWork work) {
    switch (work.id) {
      case 'mist-port':
        return Assets.images.reader.mistPortCover;
      case 'star-hotel':
        return Assets.images.reader.starHotelCover;
      case 'paper-bird':
        return Assets.images.reader.paperBirdCover;
      default:
        return Assets.appLogo;
    }
  }

  static List<AssetGenImage> comicPagesOf(ReaderWork work) {
    switch (work.id) {
      case 'mist-port':
        return [
          Assets.images.reader.mistPortPage1,
          Assets.images.reader.mistPortPage2,
          Assets.images.reader.mistPortPage3,
          Assets.images.reader.mistPortPage4,
        ];
      case 'star-hotel':
        return [
          Assets.images.reader.starHotelPage1,
          Assets.images.reader.starHotelPage2,
          Assets.images.reader.starHotelPage3,
          Assets.images.reader.starHotelPage4,
        ];
      case 'paper-bird':
        return [
          Assets.images.reader.paperBirdPage1,
          Assets.images.reader.paperBirdPage2,
          Assets.images.reader.paperBirdPage3,
          Assets.images.reader.paperBirdPage4,
        ];
      default:
        return [Assets.appLogo];
    }
  }
}
