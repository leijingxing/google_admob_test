import 'package:get/get.dart';

import '../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../data/models/workbench/whitelist_approval_item_model.dart';
import '../../../../../../data/repository/workbench_repository.dart';

/// 白名单详情控制器。
class WhitelistApprovalDetailController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

  late final WhitelistApprovalItemModel item;
  bool loading = false;
  Map<String, dynamic> detail = const <String, dynamic>{};

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is WhitelistApprovalItemModel) {
      item = args;
    } else {
      item = const WhitelistApprovalItemModel();
    }
    loadDetail();
  }

  Future<void> loadDetail() async {
    final id = item.id ?? '';
    if (id.isEmpty) return;

    loading = true;
    update();

    final result = await _repository.getWhitelistDetail(id: id);
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
      _firstNonEmpty(source['submitDate'], item.submitDate, item.parkCheckTime);

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

  List<WhitelistDetailSection> get applySections {
    final sections = <WhitelistDetailSection>[
      WhitelistDetailSection(
        title: '',
        lines: [
          WhitelistDetailLine(
            label: '提交人',
            value: _firstNonEmpty(source['submitBy']),
          ),
          WhitelistDetailLine(
            label: '提交人联系电话',
            value: _firstNonEmpty(
              source['submitUserPhone'],
              source['userPhone'],
            ),
          ),
          WhitelistDetailLine(
            label: '备注',
            value: _firstNonEmpty(source['remark']),
          ),
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

  List<WhitelistDetailSection> get approveSections {
    return <WhitelistDetailSection>[
      WhitelistDetailSection(
        title: '',
        lines: [
          WhitelistDetailLine(
            label: '审批状态',
            value: parkCheckStatusText(_toInt(source['parkCheckStatus'])),
          ),
          WhitelistDetailLine(
            label: '审批人',
            value: _firstNonEmpty(
              source['parkCheckUserName'],
              source['checkUserName'],
            ),
          ),
          WhitelistDetailLine(
            label: '审批人电话',
            value: _firstNonEmpty(
              source['parkCheckUserPhone'],
              source['checkUserPhone'],
            ),
          ),
          WhitelistDetailLine(
            label: '审批意见',
            value: _firstNonEmpty(source['parkCheckDesc'], source['checkDesc']),
          ),
          WhitelistDetailLine(
            label: '授权期限',
            value: _rangeText(
              source['validityBeginTime'],
              source['validityEndTime'],
            ),
          ),
          WhitelistDetailLine(
            label: '入口',
            value: _firstNonEmpty(
              source['inDeviceName'],
              listText(source['inDeviceNameList']),
            ),
          ),
          WhitelistDetailLine(
            label: '出口',
            value: _firstNonEmpty(
              source['outDeviceName'],
              listText(source['outDeviceNameList']),
            ),
          ),
        ],
      ),
    ];
  }

  List<WhitelistDetailSection> _vehicleSections() {
    return <WhitelistDetailSection>[
      WhitelistDetailSection(
        title: '车辆信息',
        lines: [
          WhitelistDetailLine(
            label: '车牌号',
            value: _firstNonEmpty(source['carNumb']),
          ),
          WhitelistDetailLine(
            label: '车牌颜色',
            value: _carPlateColorText(source['carNumbColour']),
          ),
          WhitelistDetailLine(
            label: '车辆类别',
            value: _carCategoryText(source['carCategory']),
          ),
          WhitelistDetailLine(
            label: '道路运输证号',
            value: _firstNonEmpty(source['roadTransportPermitNumber']),
          ),
          WhitelistDetailLine(
            label: '行驶证有效期限',
            value: _rangeText(
              source['drivingLicenseBegin'],
              source['drivingLicenseEnd'],
            ),
          ),
          WhitelistDetailLine(
            label: '行驶证',
            value: _firstNonEmpty(source['drivingLicensePic']),
          ),
        ],
      ),
      WhitelistDetailSection(
        title: '挂车信息',
        lines: [
          WhitelistDetailLine(
            label: '是否挂车',
            value: boolText(source['trailer']),
          ),
          WhitelistDetailLine(
            label: '挂车车牌号',
            value: _firstNonEmpty(source['trailerLicensePlate']),
          ),
          WhitelistDetailLine(
            label: '挂车道路运输证号',
            value: _firstNonEmpty(source['trailerRoadTransportPermitNumber']),
          ),
          WhitelistDetailLine(
            label: '挂车行驶证',
            value: _firstNonEmpty(source['trailerTrailerDrivingLicense']),
          ),
        ],
      ),
    ];
  }

  List<WhitelistDetailSection> _personSections() {
    return <WhitelistDetailSection>[
      WhitelistDetailSection(
        title: '人员信息',
        lines: [
          WhitelistDetailLine(
            label: '姓名',
            value: _firstNonEmpty(source['realName']),
          ),
          WhitelistDetailLine(
            label: '性别',
            value: sexText(source['sex'] ?? source['userSex']),
          ),
          WhitelistDetailLine(
            label: '联系电话',
            value: _firstNonEmpty(source['userPhone']),
          ),
          WhitelistDetailLine(
            label: '证件号码',
            value: _firstNonEmpty(source['idCard']),
          ),
          WhitelistDetailLine(
            label: '照片',
            value: _firstNonEmpty(source['faceUrl']),
          ),
        ],
      ),
    ];
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

  String listText(Object? value) {
    if (value is List) {
      final list = value
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty && e.toLowerCase() != 'null')
          .toList();
      return list.isEmpty ? '--' : list.join('、');
    }
    return '--';
  }

  String _rangeText(Object? begin, Object? end) {
    final left = _firstNonEmpty(begin);
    final right = _firstNonEmpty(end);
    if (left == '--' && right == '--') return '--';
    return '$left / $right';
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

class WhitelistDetailSection {
  const WhitelistDetailSection({required this.title, required this.lines});

  final String title;
  final List<WhitelistDetailLine> lines;
}

class WhitelistDetailLine {
  const WhitelistDetailLine({required this.label, required this.value});

  final String label;
  final String value;
}
