import 'package:get/get.dart';

import '../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../data/models/workbench/appointment_approval_item_model.dart';
import '../../../../../../data/repository/workbench_repository.dart';

/// 预约审批详情页控制器。
class AppointmentApprovalDetailController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

  late final AppointmentApprovalItemModel item;
  bool loading = false;
  Map<String, dynamic> detail = const <String, dynamic>{};

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is AppointmentApprovalItemModel) {
      item = args;
      if ((item.id ?? '').isNotEmpty) {
        loadDetail();
      }
    } else {
      item = const AppointmentApprovalItemModel();
    }
  }

  Future<void> loadDetail() async {
    final id = item.id ?? '';
    if (id.isEmpty) return;

    loading = true;
    update();
    final result = await _repository.getReservationProgressInfo(id: id);
    result.when(
      success: (data) => detail = data,
      failure: (error) => AppToast.showError(error.message),
    );
    loading = false;
    update();
  }

  String reservationTypeText(int type) {
    switch (type) {
      case 1:
        return '来访人员';
      case 2:
        return '普通车辆';
      case 3:
        return '危化车辆';
      case 4:
        return '危废车辆';
      case 5:
        return '普通货车';
      default:
        return '未知类型';
    }
  }

  List<AppointmentDetailLine> buildDetailLines() {
    final data = detail;
    return <AppointmentDetailLine>[
      AppointmentDetailLine(
        label: '预约类型',
        value: reservationTypeText(item.reservationType),
      ),
      AppointmentDetailLine(
        label: '车牌号',
        value: _firstNonEmpty(data['carNumb'], item.carNumb),
      ),
      AppointmentDetailLine(
        label: '驾驶员',
        value: _firstNonEmpty(data['realName'], item.realName),
      ),
      AppointmentDetailLine(
        label: '联系电话',
        value: _firstNonEmpty(data['userPhone']),
      ),
      AppointmentDetailLine(
        label: '目的地',
        value: _firstNonEmpty(data['targetName']),
      ),
      AppointmentDetailLine(
        label: '提交时间',
        value: _firstNonEmpty(
          data['submitTime'],
          item.submitTime,
          item.createTime,
        ),
      ),
      AppointmentDetailLine(
        label: '审批时间',
        value: _firstNonEmpty(data['parkCheckTime'], item.parkCheckTime),
      ),
    ].where((e) => e.value != '--').toList();
  }

  String _firstNonEmpty([Object? a, Object? b, Object? c]) {
    for (final value in <Object?>[a, b, c]) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty && text.toLowerCase() != 'null') return text;
    }
    return '--';
  }
}

class AppointmentDetailLine {
  const AppointmentDetailLine({required this.label, required this.value});

  final String label;
  final String value;
}
