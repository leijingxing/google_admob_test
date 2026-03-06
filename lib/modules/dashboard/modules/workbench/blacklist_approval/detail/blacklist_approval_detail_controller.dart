import 'package:get/get.dart';

import '../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../data/models/workbench/blacklist_approval_item_model.dart';
import '../../../../../../data/repository/workbench_repository.dart';

/// 黑名单详情控制器。
class BlacklistApprovalDetailController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

  late final BlacklistApprovalItemModel item;
  bool loading = false;
  Map<String, dynamic> detail = const <String, dynamic>{};

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is BlacklistApprovalItemModel) {
      item = args;
    } else {
      item = const BlacklistApprovalItemModel();
    }
    loadDetail();
  }

  Future<void> loadDetail() async {
    final id = item.id ?? '';
    if (id.isEmpty) return;

    loading = true;
    update();

    final result = await _repository.getBlacklistDetail(id: id);
    result.when(
      success: (data) {
        detail = data;
      },
      failure: (error) => AppToast.showError(error.message),
    );

    loading = false;
    update();
  }

  bool get isVehicle => _toInt(source['type']) != 1;

  Map<String, dynamic> get source =>
      detail.isEmpty ? item.toJson() : Map<String, dynamic>.from(detail);

  String get applyTimeText =>
      _firstNonEmpty(source['createDate'], item.createDate, item.parkCheckTime);

  String get approveTimeText =>
      _firstNonEmpty(source['parkCheckTime'], source['checkTime']);

  String get approveNodeTitle {
    switch (_toInt(source['parkCheckStatus'])) {
      case 1:
        return '园区已审批';
      case 2:
        return '园区已拒绝';
      default:
        return '园区待审批';
    }
  }

  List<BlacklistDetailSection> get applySections {
    final sections = <BlacklistDetailSection>[
      BlacklistDetailSection(
        title: '',
        lines: [
          BlacklistDetailLine(
            label: '提交人',
            value: _firstNonEmpty(source['createBy']),
          ),
          BlacklistDetailLine(
            label: '提交人联系电话',
            value: _firstNonEmpty(
              source['submitUserPhone'],
              source['userPhone'],
            ),
          ),
          BlacklistDetailLine(
            label: '拉黑描述',
            value: _firstNonEmpty(source['remark']),
          ),
          BlacklistDetailLine(
            label: '附件',
            value: _firstNonEmpty(source['attachment']),
          ),
          BlacklistDetailLine(label: '有效状态', value: validStatusText),
        ],
      ),
    ];

    if (isVehicle) {
      sections.addAll(_vehicleSections());
    } else {
      sections.addAll(_personSections());
    }
    return sections;
  }

  List<BlacklistDetailSection> get approveSections {
    return <BlacklistDetailSection>[
      BlacklistDetailSection(
        title: '',
        lines: [
          BlacklistDetailLine(
            label: '审批状态',
            value: parkCheckStatusText(_toInt(source['parkCheckStatus'])),
          ),
          BlacklistDetailLine(
            label: '审批人',
            value: _firstNonEmpty(source['parkCheckUserName']),
          ),
          BlacklistDetailLine(
            label: '审批人电话',
            value: _firstNonEmpty(source['parkCheckUserPhone']),
          ),
          BlacklistDetailLine(
            label: '审批意见',
            value: _firstNonEmpty(source['parkCheckDesc']),
          ),
          BlacklistDetailLine(
            label: '授权期限',
            value: _rangeText(
              source['validityBeginTime'],
              source['validityEndTime'],
            ),
          ),
        ],
      ),
    ];
  }

  List<BlacklistDetailSection> _vehicleSections() {
    return <BlacklistDetailSection>[
      BlacklistDetailSection(
        title: '车辆信息',
        lines: [
          BlacklistDetailLine(
            label: '车牌号',
            value: _firstNonEmpty(source['carNumb']),
          ),
          BlacklistDetailLine(
            label: '车牌颜色',
            value: _carPlateColorText(source['carNumbColour']),
          ),
          BlacklistDetailLine(
            label: '车辆类别',
            value: _carCategoryText(source['carCategory']),
          ),
          BlacklistDetailLine(
            label: '道路运输证号',
            value: _firstNonEmpty(source['roadTransportPermitNumber']),
          ),
          BlacklistDetailLine(
            label: '行驶证有效期限',
            value: _firstNonEmpty(source['drivingLicenseEnd']),
          ),
          BlacklistDetailLine(
            label: '行驶证',
            value: _firstNonEmpty(source['drivingLicensePic']),
          ),
        ],
      ),
      BlacklistDetailSection(
        title: '挂车信息',
        lines: [
          BlacklistDetailLine(
            label: '是否挂车',
            value: boolText(source['trailer']),
          ),
          BlacklistDetailLine(
            label: '挂车车牌号',
            value: _firstNonEmpty(source['trailerLicensePlate']),
          ),
          BlacklistDetailLine(
            label: '挂车道路运输证号',
            value: _firstNonEmpty(source['trailerRoadTransportPermitNumber']),
          ),
          BlacklistDetailLine(
            label: '挂车行驶证',
            value: _firstNonEmpty(source['trailerTrailerDrivingLicense']),
          ),
        ],
      ),
    ];
  }

  List<BlacklistDetailSection> _personSections() {
    return <BlacklistDetailSection>[
      BlacklistDetailSection(
        title: '人员信息',
        lines: [
          BlacklistDetailLine(
            label: '姓名',
            value: _firstNonEmpty(source['realName']),
          ),
          BlacklistDetailLine(label: '性别', value: sexText(source['sex'])),
          BlacklistDetailLine(
            label: '联系电话',
            value: _firstNonEmpty(source['userPhone']),
          ),
          BlacklistDetailLine(
            label: '证件号码',
            value: _firstNonEmpty(source['idCard']),
          ),
          BlacklistDetailLine(
            label: '照片',
            value: _firstNonEmpty(source['faceUrl']),
          ),
        ],
      ),
    ];
  }

  String get validStatusText {
    final state = _toInt(source['state']);
    final status = _toInt(source['status']);
    final value = state == -1 ? status : state;
    return value == 1 ? '有效' : '失效';
  }

  String parkCheckStatusText(int status) {
    switch (status) {
      case 0:
        return '待审批';
      case 1:
        return '已通过';
      case 2:
        return '已拒绝';
      default:
        return '--';
    }
  }

  String boolText(Object? value) {
    return _toInt(value) == 1 ? '是' : '否';
  }

  String sexText(Object? value) {
    final code = _toInt(value);
    if (code == 1) return '男';
    if (code == 2) return '女';
    return '--';
  }

  String _rangeText(Object? begin, Object? end) {
    final left = _firstNonEmpty(begin);
    final right = _firstNonEmpty(end);
    if (left == '--' && right == '--') return '--';
    return '$left 至 $right';
  }

  String _carPlateColorText(Object? value) {
    switch (_toInt(value)) {
      case 0:
        return '白底黑字';
      case 1:
        return '蓝底白字';
      case 2:
        return '黄底黑字';
      case 3:
        return '黑底白字';
      case 4:
        return '绿底黑字';
      default:
        return _firstNonEmpty(value);
    }
  }

  String _carCategoryText(Object? value) {
    switch (_toInt(value)) {
      case 2:
        return '普通车';
      case 3:
        return '危化车';
      case 4:
        return '危废车';
      case 5:
        return '普通货车';
      default:
        return _firstNonEmpty(value);
    }
  }

  int _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse((value ?? '').toString()) ?? -1;
  }

  String _firstNonEmpty([Object? a, Object? b, Object? c]) {
    for (final value in <Object?>[a, b, c]) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty && text.toLowerCase() != 'null') return text;
    }
    return '--';
  }
}

class BlacklistDetailSection {
  const BlacklistDetailSection({required this.title, required this.lines});

  final String title;
  final List<BlacklistDetailLine> lines;
}

class BlacklistDetailLine {
  const BlacklistDetailLine({required this.label, required this.value});

  final String label;
  final String value;
}
