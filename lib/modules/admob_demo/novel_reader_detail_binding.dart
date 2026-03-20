import 'package:get/get.dart';

import '../../data/models/reader/reader_demo_models.dart';
import 'novel_reader_detail_controller.dart';

/// 小说详情页依赖注入。
class NovelReaderDetailBinding extends Bindings {
  NovelReaderDetailBinding({required this.work});

  final ReaderWork work;

  @override
  void dependencies() {
    Get.lazyPut<NovelReaderDetailController>(
      () => NovelReaderDetailController(work: work),
    );
  }
}
