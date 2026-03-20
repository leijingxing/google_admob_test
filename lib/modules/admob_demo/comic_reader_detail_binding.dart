import 'package:get/get.dart';

import '../../data/models/reader/reader_demo_models.dart';
import 'comic_reader_detail_controller.dart';

/// 漫画详情页依赖注入。
class ComicReaderDetailBinding extends Bindings {
  ComicReaderDetailBinding({required this.work});

  final ReaderWork work;

  @override
  void dependencies() {
    Get.lazyPut<ComicReaderDetailController>(
      () => ComicReaderDetailController(work: work),
    );
  }
}
