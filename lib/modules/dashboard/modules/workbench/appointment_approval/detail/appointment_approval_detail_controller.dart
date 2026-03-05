import 'package:get/get.dart';

import '../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../data/models/workbench/appointment_approval_item_model.dart';
import '../../../../../../data/repository/workbench_repository.dart';

/// 预约审批详情页控制器（基本信息 / 出入记录 / 违规记录）。
class AppointmentApprovalDetailController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

  late final AppointmentApprovalItemModel item;

  int currentSection = 0;
  bool basicLoading = false;
  bool recordLoading = false;

  bool _basicLoaded = false;
  bool _recordLoaded = false;

  List<Map<String, dynamic>> progressTimeline = const <Map<String, dynamic>>[];
  List<Map<String, dynamic>> gateRecords = const <Map<String, dynamic>>[];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is AppointmentApprovalItemModel) {
      item = args;
    } else {
      item = const AppointmentApprovalItemModel();
    }
    _loadBasic();
  }

  Future<void> onSectionChanged(int index) async {
    if (currentSection == index) return;
    currentSection = index;
    update();
    if (index == 1) {
      await _loadRecords();
    }
  }

  Future<void> _loadBasic() async {
    final id = item.id ?? '';
    if (id.isEmpty || _basicLoaded) return;

    basicLoading = true;
    update();
    final result = await _repository.getReservationProgressTimeline(id: id);
    result.when(
      success: (data) {
        progressTimeline = data;
        _basicLoaded = true;
      },
      failure: (error) => AppToast.showError(error.message),
    );
    basicLoading = false;
    update();
  }

  Future<void> _loadRecords() async {
    final id = item.id ?? '';
    if (id.isEmpty || _recordLoaded) return;

    recordLoading = true;
    update();
    final result = await _repository.getGateRecords(id: id, idType: 1);
    result.when(
      success: (data) {
        gateRecords = data;
        _recordLoaded = true;
      },
      failure: (error) => AppToast.showError(error.message),
    );
    recordLoading = false;
    update();
  }

  Future<List<Map<String, dynamic>>> loadViolationPage(
    int pageIndex,
    int pageSize,
  ) async {
    final id = item.id ?? '';
    if (id.isEmpty) return const <Map<String, dynamic>>[];

    final result = await _repository.getRiskWarningPage(
      pageIndex: pageIndex,
      pageSize: pageSize,
      relationId: id,
      carNum: item.carNumb,
    );

    return result.when(
      success: (pageData) => pageData.items,
      failure: (error) {
        AppToast.showError(error.message);
        throw Exception(error.message);
      },
    );
  }

  String timelineTypeText(int? typeCode) {
    switch (typeCode ?? -1) {
      case 0:
        return '发起预约';
      case 1:
        return '企业审批';
      case 2:
        return '园区审批';
      case 3:
        return '司机自检';
      case 4:
        return '园区抽查';
      default:
        return '流程节点';
    }
  }

  String recordTypeText(int? type) {
    switch (type ?? -1) {
      case 1:
        return '入园';
      case 2:
        return '出园';
      case 3:
        return '园内抓拍';
      default:
        return '记录';
    }
  }

  List<DetailGroup> timelineDisplayGroups(Map<String, dynamic> node) {
    final typeCode = _toInt(node['typeCode']);
    final specific = timelineSpecificData(node);

    switch (typeCode) {
      case 0:
        return _buildInitiateGroups(specific);
      case 1:
        return _buildCompanyApproveGroups(specific);
      case 2:
        return _buildParkApproveGroups(specific);
      default:
        final lines = _commonDetailLines(specific);
        return lines.isEmpty
            ? const <DetailGroup>[]
            : <DetailGroup>[DetailGroup(title: '流程信息', lines: lines)];
    }
  }

  Map<String, dynamic> timelineSpecificData(Map<String, dynamic> node) {
    final specificRaw = node['specificData'];
    return specificRaw is Map
        ? Map<String, dynamic>.from(specificRaw)
        : const <String, dynamic>{};
  }

  List<DetailLine> _commonDetailLines(Map<String, dynamic> specific) {
    final lines = <DetailLine>[];
    void addLine(String label, Object? value) {
      final text = displayText(value);
      if (text == '--') return;
      lines.add(DetailLine(label: label, value: text));
    }

    addLine('提交人', specific['submitRealName']);
    addLine('提交人联系电话', specific['submitUserPhone']);
    addLine('车牌号', specific['carNumb']);
    addLine('驾驶员', specific['realName']);
    addLine('联系电话', specific['userPhone']);
    addLine('证件号码', specific['idCard']);
    return lines;
  }

  List<DetailGroup> _buildInitiateGroups(Map<String, dynamic> specific) {
    final headerLines = <DetailLine>[];
    void addHeader(String label, Object? value) {
      final text = displayText(value);
      if (text == '--') return;
      headerLines.add(DetailLine(label: label, value: text));
    }

    addHeader('提交人', specific['submitRealName']);
    addHeader('提交人联系电话', specific['submitUserPhone']);
    addHeader('预约类别', specific['reservationCategoryName']);

    final vehicleLines = <DetailLine>[];
    void addVehicle(String label, Object? value) {
      final text = displayText(value);
      if (text == '--') return;
      vehicleLines.add(DetailLine(label: label, value: text));
    }

    addVehicle('车牌号', specific['carNumb']);
    addVehicle('车牌颜色', _carPlateColorText(specific));
    addVehicle('道路运输证号', specific['roadTransportPermitNumber']);
    addVehicle('行驶证', specific['drivingLicensePic']);
    addVehicle(
      '行驶证有效期',
      '${displayText(specific['drivingLicenseBegin'])}/${displayText(specific['drivingLicenseEnd'])}',
    );

    final trailerLines = <DetailLine>[];
    void addTrailer(String label, Object? value) {
      final text = displayText(value);
      if (text == '--') return;
      trailerLines.add(DetailLine(label: label, value: text));
    }

    addTrailer('是否挂车', boolText(specific['trailer']));
    addTrailer('挂车车牌号', specific['trailerLicensePlate']);
    addTrailer('挂车道路运输证号', specific['trailerRoadTransportPermitNumber']);
    addTrailer('挂车行驶证', specific['trailerTrailerDrivingLicense']);

    final peopleLines = <DetailLine>[];
    void addPeople(
      String label,
      Object? value, {
      bool showWhenEmpty = false,
      String emptyText = '-',
    }) {
      final text = displayText(value);
      if (text == '--' && !showWhenEmpty) return;
      peopleLines.add(
        DetailLine(label: label, value: text == '--' ? emptyText : text),
      );
    }

    addPeople('姓名', specific['realName']);
    addPeople('性别', _sexText(specific['userSex']));
    addPeople('联系电话', specific['userPhone']);
    addPeople('证件号码', specific['idCard']);
    addPeople('正脸照片', specific['faceUrl']);
    addPeople('随车人数', specific['applianceCrewAmount']);
    addPeople('是否驾驶员', boolText(specific['driver']));
    addPeople('是否危货驾驶员', boolText(specific['dangerousGoodsDriver']));
    addPeople('驾驶证', specific['driverCardPic'], showWhenEmpty: true);
    addPeople(
      '驾驶证有效期限',
      _rangeText(specific['driverCardBegin'], specific['driverCardEnd']),
      showWhenEmpty: true,
      emptyText: '-/-',
    );
    addPeople(
      '道路危险货物驾驶人员从业资格证',
      specific['dangerousGoodsDriverCardPic'],
      showWhenEmpty: true,
    );
    addPeople(
      '道路危险货物押运人员从业资格证',
      specific['supercargoCardPic'],
      showWhenEmpty: true,
    );

    final cargoLines = <DetailLine>[];
    void addCargo(String label, Object? value) {
      final text = displayText(value);
      if (text == '--') return;
      cargoLines.add(DetailLine(label: label, value: text));
    }

    addCargo('装载类型', _loadTypeText(specific));
    final goodsListRaw = specific['reservationGoodsVOList'];
    if (goodsListRaw is List) {
      for (var i = 0; i < goodsListRaw.length; i++) {
        final goods = goodsListRaw[i];
        if (goods is! Map) continue;
        final g = Map<String, dynamic>.from(goods);
        final inOut = _toInt(g['inOut']) == 1 ? '入园' : '出园';
        addCargo('$inOut 危化品类型', g['goodsTypeName'] ?? g['goodsType']);
        addCargo('$inOut 危化品名称', g['goodsName']);
        addCargo('$inOut 危化品数量', g['goodsAmount']);
        addCargo('$inOut 电子运单', g['electronicWaybill']);
        if (i != goodsListRaw.length - 1) {
          cargoLines.add(const DetailLine(label: '', value: ''));
        }
      }
    }

    final reserveLines = <DetailLine>[];
    void addReserve(String label, Object? value) {
      final text = displayText(value);
      if (text == '--') return;
      reserveLines.add(DetailLine(label: label, value: text));
    }

    addReserve('计划入园时间', specific['planInTime']);
    addReserve('计划离开时间', specific['planOutTime']);
    addReserve('目的地', specific['companyName']);
    addReserve('联系人', specific['contactsName']);
    addReserve('联系电话', specific['contactsPhone']);
    addReserve('入园事由', specific['remark']);

    final groups = <DetailGroup>[];
    if (headerLines.isNotEmpty) {
      groups.add(DetailGroup(title: '发起信息', lines: headerLines));
    }
    if (vehicleLines.isNotEmpty) {
      groups.add(DetailGroup(title: '车辆信息', lines: vehicleLines));
    }
    if (trailerLines.isNotEmpty) {
      groups.add(DetailGroup(title: '挂车信息', lines: trailerLines));
    }
    if (peopleLines.isNotEmpty) {
      groups.add(DetailGroup(title: '人员信息', lines: peopleLines));
    }
    if (cargoLines.isNotEmpty) {
      groups.add(DetailGroup(title: '载货信息', lines: cargoLines));
    }
    if (reserveLines.isNotEmpty) {
      groups.add(DetailGroup(title: '预约信息', lines: reserveLines));
    }
    return groups;
  }

  List<DetailGroup> _buildCompanyApproveGroups(Map<String, dynamic> specific) {
    final lines = <DetailLine>[];
    void addLine(
      String label,
      Object? value, {
      bool showWhenEmpty = false,
      String emptyText = '-',
    }) {
      final text = displayText(value);
      if (text == '--' && !showWhenEmpty) return;
      lines.add(
        DetailLine(label: label, value: text == '--' ? emptyText : text),
      );
    }

    addLine('审批状态', _approveStatusText(specific['checkStatus']));
    addLine(
      '审批人',
      specific['checkUserName'] ??
          specific['companyCheckUserName'] ??
          specific['approveUserName'],
      showWhenEmpty: true,
    );
    addLine(
      '审批人电话',
      specific['checkUserPhone'] ??
          specific['companyCheckUserPhone'] ??
          specific['approveUserPhone'],
      showWhenEmpty: true,
    );
    addLine('审批意见', specific['checkDesc']);
    addLine('审批时间', specific['checkTime'] ?? specific['createDate']);
    return lines.isEmpty
        ? const <DetailGroup>[]
        : <DetailGroup>[DetailGroup(title: '企业审批', lines: lines)];
  }

  List<DetailGroup> _buildParkApproveGroups(Map<String, dynamic> specific) {
    final lines = <DetailLine>[];
    void addLine(String label, Object? value) {
      final text = displayText(value);
      if (text == '--') return;
      lines.add(DetailLine(label: label, value: text));
    }

    addLine('审批状态', _approveStatusText(specific['checkStatus']));
    addLine('审批人', specific['checkUserName']);
    addLine('审批人电话', specific['checkUserPhone']);
    addLine('审批意见', specific['checkDesc']);
    addLine(
      '授权期限',
      '${displayText(specific['validityBeginTime'])}/${displayText(specific['validityEndTime'])}',
    );
    addLine('入口', listText(specific['inDeviceNameList']));
    addLine('出口', listText(specific['outDeviceNameList']));
    addLine('审批时间', specific['checkTime'] ?? specific['createDate']);

    return lines.isEmpty
        ? const <DetailGroup>[]
        : <DetailGroup>[DetailGroup(title: '园区审批', lines: lines)];
  }

  String listText(Object? value) {
    if (value is List) {
      final list = value
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty && e.toLowerCase() != 'null')
          .toList();
      return list.isEmpty ? '--' : list.join('、');
    }
    return displayText(value);
  }

  String displayText(Object? value) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty || text.toLowerCase() == 'null' || text == '--/--') {
      return '--';
    }
    return text;
  }

  String boolText(Object? value) {
    return _toInt(value) == 1 ? '是' : '否';
  }

  String _carPlateColorText(Map<String, dynamic> specific) {
    final name = displayText(specific['carNumbColourName']);
    if (name != '--') return name;
    final code = _toInt(specific['carNumbColour']);
    const map = <int, String>{
      0: '白底黑字',
      1: '蓝底白字',
      2: '黄底黑字',
      3: '黑底白字',
      4: '绿底黑字',
    };
    return map[code] ?? displayText(specific['carNumbColour']);
  }

  String _sexText(Object? value) {
    final code = _toInt(value);
    if (code == 1) return '男';
    if (code == 2) return '女';
    return displayText(value);
  }

  String _approveStatusText(Object? value) {
    final code = _toInt(value);
    switch (code) {
      case 0:
        return '待审批';
      case 1:
        return '通过';
      case 2:
        return '拒绝';
      default:
        return displayText(value);
    }
  }

  int _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse((value ?? '').toString()) ?? -1;
  }

  String _loadTypeText(Map<String, dynamic> specific) {
    final name = displayText(specific['loadTypeName']);
    if (name != '--') return name;

    final code = _toInt(specific['loadType']);
    const map = <int, String>{
      0: '空载入园，空载出园',
      1: '重载入园，空载出园',
      2: '空载入园，重载出园',
      3: '重载入园，重载出园',
    };
    return map[code] ?? displayText(specific['loadType']);
  }

  String _rangeText(Object? begin, Object? end) {
    final beginText = displayText(begin);
    final endText = displayText(end);
    final left = beginText == '--' ? '-' : beginText;
    final right = endText == '--' ? '-' : endText;
    return '$left/$right';
  }
}

class DetailLine {
  const DetailLine({required this.label, required this.value});

  final String label;
  final String value;
}

class DetailGroup {
  const DetailGroup({required this.title, required this.lines});

  final String title;
  final List<DetailLine> lines;
}
