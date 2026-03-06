import 'package:get/get.dart';

import '../../../../../../data/models/workbench/appeal_reply_item_model.dart';

/// 申诉回复详情页控制器。
class AppealReplyDetailController extends GetxController {
  late final AppealReplyItemModel item;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    item = args is AppealReplyItemModel ? args : const AppealReplyItemModel();
  }

  String appealTypeText() {
    switch (item.appealType) {
      case 1:
        return '违规申诉';
      case 2:
        return '拉黑申诉';
      default:
        return '--';
    }
  }

  String statusText() {
    switch (item.status) {
      case 1:
        return '已通过';
      case 2:
        return '不通过';
      default:
        return '申诉中';
    }
  }

  List<AppealReplyDetailLine> buildDetailLines() {
    return <AppealReplyDetailLine>[
      AppealReplyDetailLine(label: '申诉类型', value: appealTypeText()),
      AppealReplyDetailLine(label: '关联记录ID', value: _display(item.relationId)),
      AppealReplyDetailLine(label: '姓名/车牌', value: _display(item.targetValue)),
      AppealReplyDetailLine(label: '异常描述', value: _display(item.abnormalDesc)),
      AppealReplyDetailLine(label: '申诉人', value: _display(item.applicant)),
      AppealReplyDetailLine(label: '申诉时间', value: _display(item.appealTime)),
      AppealReplyDetailLine(label: '申诉描述', value: _display(item.appealDesc)),
      AppealReplyDetailLine(label: '处理状态', value: statusText()),
      AppealReplyDetailLine(label: '回复描述', value: _display(item.reply)),
    ];
  }

  String _display(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? '--' : text;
  }
}

class AppealReplyDetailLine {
  const AppealReplyDetailLine({required this.label, required this.value});

  final String label;
  final String value;
}
