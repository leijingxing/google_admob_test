import 'dart:async';

import 'package:get/get.dart';

import '../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../core/utils/dict_field_query_tool.dart';
import '../../../../../../data/models/workbench/appointment_approval_item_model.dart';
import '../../../../../../data/models/workbench/risk_warning_record_item_model.dart';
import '../../../../../../data/repository/workbench_repository.dart';

/// 预约审批详情页控制器（基本信息 / 出入记录 / 违规记录）。
class AppointmentApprovalDetailController extends GetxController {
  /// 工作台数据仓库，负责详情页相关接口请求。
  final WorkbenchRepository _repository = WorkbenchRepository();
  static const List<String> _pageDictTypes = <String>[DictFieldQueryTool.loadType, DictFieldQueryTool.goodsType, DictFieldQueryTool.carNumbColour];

  /// 当前预约单 ID，由上一页通过参数传入。
  late final String reservationId;

  /// 当前选中的详情分栏索引。
  int currentSection = 0;
  /// 基本信息模块加载态。
  bool basicLoading = false;
  /// 出入记录模块加载态。
  bool recordLoading = false;

  /// 基本信息是否已完成首次加载。
  bool _basicLoaded = false;
  /// 出入记录是否已完成首次加载。
  bool _recordLoaded = false;

  /// 基本信息模块使用时间线数据，节点类型由后端 typeCode 决定。
  List<Map<String, dynamic>> progressTimeline = const <Map<String, dynamic>>[];

  /// 出入记录模块按 Web 结构保留原始分组数据。
  List<Map<String, dynamic>> gateRecords = const <Map<String, dynamic>>[];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is AppointmentApprovalItemModel) {
      reservationId = args.id ?? '';
    } else if (args is String) {
      reservationId = args.trim();
    } else {
      reservationId = '';
    }
    _preloadDictItems();
    _loadBasic();
  }

  /// 预加载页面依赖的字典项，避免展示编码值。
  void _preloadDictItems() {
    unawaited(
      DictFieldQueryTool.ensureLoaded(dictTypes: _pageDictTypes).then((loaded) {
        if (!loaded) return;
        update();
      }),
    );
  }

  /// 切换详情分栏，并在需要时懒加载对应模块数据。
  Future<void> onSectionChanged(int index) async {
    if (currentSection == index) return;
    currentSection = index;
    update();

    // 仅在切到对应模块时加载，避免详情页首屏一次性打满所有接口。
    if (index == 1) {
      await _loadRecords();
    }
  }

  /// 加载基本信息模块的流程时间线数据。
  Future<void> _loadBasic() async {
    if (reservationId.isEmpty || _basicLoaded) return;

    basicLoading = true;
    update();
    final result = await _repository.getReservationProgressTimeline(id: reservationId);
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

  /// 加载出入记录模块数据。
  Future<void> _loadRecords() async {
    if (reservationId.isEmpty || _recordLoaded) return;

    recordLoading = true;
    update();
    final result = await _repository.getGateRecords(id: reservationId, idType: 1);
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

  /// 分页加载违规记录列表，供违规记录模块下拉翻页使用。
  Future<List<RiskWarningRecordItemModel>> loadViolationPage(int pageIndex, int pageSize) async {
    if (reservationId.isEmpty) return const <RiskWarningRecordItemModel>[];

    final result = await _repository.getRiskWarningPage(pageIndex: pageIndex, pageSize: pageSize, relationId: reservationId, carNum: reservationCarNumb);

    return result.when(
      success: (pageData) => pageData.items,
      failure: (error) {
        AppToast.showError(error.message);
        throw Exception(error.message);
      },
    );
  }

  /// 将流程节点类型编码转换为页面展示文案。
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

  /// 将出入记录类型编码转换为页面展示文案。
  String recordTypeText(int? type) {
    switch (type ?? -1) {
      case 1:
        return '出园';
      case 2:
        return '入园';
      case 3:
        return '园内抓拍';
      case 4:
        return '违规抓拍';
      default:
        return '记录';
    }
  }

  /// 将后端时间线节点转换为前端可直接渲染的分组结构。
  /// 不同 typeCode 对应不同模块字段组合，保持与 Web 展示口径一致。
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
        return lines.isEmpty ? const <DetailGroup>[] : <DetailGroup>[DetailGroup(title: '流程信息', lines: lines)];
    }
  }

  /// 读取节点中的具体业务数据字段。
  Map<String, dynamic> timelineSpecificData(Map<String, dynamic> node) {
    final specificRaw = node['specificData'];
    return specificRaw is Map ? Map<String, dynamic>.from(specificRaw) : const <String, dynamic>{};
  }

  /// 按节点类型查找第一条对应的具体业务数据。
  Map<String, dynamic> timelineSpecificDataByType(int typeCode) {
    for (final node in progressTimeline) {
      if (_toInt(node['typeCode']) != typeCode) continue;
      return timelineSpecificData(node);
    }
    return const <String, dynamic>{};
  }

  /// 发起预约节点的原始业务数据。
  Map<String, dynamic> get initiateSpecificData => timelineSpecificDataByType(0);

  /// 当前预约是否为人员预约。
  bool get isPersonReservation {
    final specific = initiateSpecificData;
    final reservationType = _toInt(specific['reservationType'] ?? specific['appointmentType'] ?? specific['type']);
    if (reservationType > 0) {
      return reservationType == 1;
    }

    final reservationCategoryName = displayText(specific['reservationCategoryName']);
    if (reservationCategoryName != '--') {
      return reservationCategoryName.contains('人员');
    }

    return displayText(specific['carNumb']) == '--';
  }

  /// 当前预约的车牌号，不存在时返回空值。
  String? get reservationCarNumb {
    final text = displayText(initiateSpecificData['carNumb']);
    return text == '--' ? null : text;
  }

  /// 兜底生成通用流程信息分组内容。
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

  /// 组装发起预约节点的展示分组。
  List<DetailGroup> _buildInitiateGroups(Map<String, dynamic> specific) {
    // 发起预约节点字段最多，前端按“发起/车辆/挂车/人员/载货/预约信息”拆组展示。
    final isPersonReservation = this.isPersonReservation;
    final headerLines = <DetailLine>[];
    void addHeader(String label, Object? value) {
      final text = displayText(value);
      if (text == '--') return;
      headerLines.add(DetailLine(label: label, value: text));
    }

    addHeader('提交人', specific['submitRealName']);
    addHeader('提交人联系电话', specific['submitUserPhone']);

    final vehicleLines = <DetailLine>[];
    void addVehicle(String label, Object? value) {
      final text = displayText(value);
      if (text == '--') return;
      vehicleLines.add(DetailLine(label: label, value: text));
    }

    if (!isPersonReservation) {
      addVehicle('车牌号', specific['carNumb']);
      addVehicle('车牌颜色', _carPlateColorText(specific));
      addVehicle('道路运输证号', specific['roadTransportPermitNumber']);
      addVehicle('行驶证', specific['drivingLicensePic']);
      addVehicle('行驶证有效期', '${displayText(specific['drivingLicenseBegin'])}/${displayText(specific['drivingLicenseEnd'])}');
    }

    final trailerLines = <DetailLine>[];
    void addTrailer(String label, Object? value) {
      final text = displayText(value);
      if (text == '--') return;
      trailerLines.add(DetailLine(label: label, value: text));
    }

    if (!isPersonReservation) {
      addTrailer('是否挂车', boolText(specific['trailer']));
      addTrailer('挂车车牌号', specific['trailerLicensePlate'] ?? '-');
      addTrailer('挂车道路运输证号', specific['trailerRoadTransportPermitNumber'] ?? '-');
      addTrailer('挂车行驶证', specific['trailerTrailerDrivingLicense'] ?? '-');
    }

    final peopleLines = <DetailLine>[];
    void addPeople(String label, Object? value, {bool showWhenEmpty = false, String emptyText = '-'}) {
      final text = displayText(value);
      if (text == '--' && !showWhenEmpty) return;
      peopleLines.add(DetailLine(label: label, value: text == '--' ? emptyText : text));
    }

    addPeople('姓名', specific['realName']);
    addPeople('性别', _sexText(specific['userSex']));
    addPeople('联系电话', specific['userPhone']);
    addPeople('证件号码', specific['idCard']);
    addPeople('正脸照片', specific['faceUrl']);
    if (!isPersonReservation) {
      addPeople('随车人数', specific['applianceCrewAmount']);
    }
    addPeople('是否驾驶员', boolText(specific['driver']));
    addPeople('是否危货驾驶员', boolText(specific['dangerousGoodsDriver']));
    addPeople('驾驶证', specific['driverCardPic'], showWhenEmpty: true);
    addPeople('驾驶证有效期限', _rangeText(specific['driverCardBegin'], specific['driverCardEnd']), showWhenEmpty: true, emptyText: '-/-');
    addPeople('道路危险货物驾驶人员从业资格证', specific['dangerousGoodsDriverCardPic'], showWhenEmpty: true);
    addPeople('道路危险货物押运人员从业资格证', specific['supercargoCardPic'], showWhenEmpty: true);

    final cargoLines = <DetailLine>[];
    void addCargo(String label, Object? value) {
      final text = displayText(value);
      if (text == '--') return;
      cargoLines.add(DetailLine(label: label, value: text));
    }

    if (!isPersonReservation) {
      addCargo('装载类型', _loadTypeText(specific));
      final goodsListRaw = specific['reservationGoodsVOList'];
      if (goodsListRaw is List) {
        for (var i = 0; i < goodsListRaw.length; i++) {
          final goods = goodsListRaw[i];
          if (goods is! Map) continue;
          final g = Map<String, dynamic>.from(goods);
          final inOut = _toInt(g['inOut']) == 1 ? '入园' : '出园';
          addCargo('$inOut 危化品类型', _goodsTypeText(g));
          addCargo('$inOut 危化品名称', g['goodsName']);
          addCargo('$inOut 危化品数量', g['goodsAmount']);
          addCargo('$inOut 电子运单', g['electronicWaybill']);

          // 组内插入空行标记，交给 View 渲染成一条分隔线。
          if (i != goodsListRaw.length - 1) {
            cargoLines.add(const DetailLine(label: '', value: ''));
          }
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

  /// 组装企业审批节点的展示分组。
  List<DetailGroup> _buildCompanyApproveGroups(Map<String, dynamic> specific) {
    // 企业审批节点仅保留审批相关字段，字段名存在历史差异，这里做多 key 兜底。
    final lines = <DetailLine>[];
    void addLine(String label, Object? value, {bool showWhenEmpty = false, String emptyText = '-'}) {
      final text = displayText(value);
      if (text == '--' && !showWhenEmpty) return;
      lines.add(DetailLine(label: label, value: text == '--' ? emptyText : text));
    }

    addLine('审批状态', _approveStatusText(specific['checkStatus']));
    addLine('审批人', specific['checkUserName'] ?? specific['companyCheckUserName'] ?? specific['approveUserName'], showWhenEmpty: true);
    addLine('审批人电话', specific['checkUserPhone'] ?? specific['companyCheckUserPhone'] ?? specific['approveUserPhone'], showWhenEmpty: true);
    addLine('审批意见', specific['checkDesc']);
    // addLine('审批时间', specific['checkTime'] ?? specific['createDate']);
    return lines.isEmpty ? const <DetailGroup>[] : <DetailGroup>[DetailGroup(title: '企业审批', lines: lines)];
  }

  /// 组装园区审批节点的展示分组。
  List<DetailGroup> _buildParkApproveGroups(Map<String, dynamic> specific) {
    // 园区审批节点相比企业审批多出授权期限和入口/出口设备信息。
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
    addLine('授权期限开始', displayText(specific['validityBeginTime']));
    addLine('授权期限结束', displayText(specific['validityEndTime']));
    addLine('入口', listText(specific['inDeviceNameList'] ?? '-'));
    addLine('出口', listText(specific['outDeviceNameList']));

    return lines.isEmpty ? const <DetailGroup>[] : <DetailGroup>[DetailGroup(title: '园区审批', lines: lines)];
  }

  /// 将列表值格式化为顿号分隔的展示文本。
  String listText(Object? value) {
    if (value is List) {
      final list = value.map((e) => e.toString().trim()).where((e) => e.isNotEmpty && e.toLowerCase() != 'null').toList();
      return list.isEmpty ? '--' : list.join('、');
    }
    return displayText(value);
  }

  /// 统一的文本兜底：屏蔽 null/空串，并返回页面约定占位符。
  String displayText(Object? value) {
    final text = value?.toString().trim() ?? '';
    if (text.toLowerCase() == 'null' || text == '--/--') {
      return '--';
    }
    return text;
  }

  /// 将布尔编码转换为“是/否”文案。
  String boolText(Object? value) {
    return _toInt(value) == 1 ? '是' : '否';
  }

  /// 解析车牌颜色展示文案，优先使用字典标签。
  String _carPlateColorText(Map<String, dynamic> specific) {
    final label = DictFieldQueryTool.carNumbColourLabel(specific['carNumbColour'], fallback: '--');
    if (label != '--') return label;

    final name = displayText(specific['carNumbColourName']);
    if (name != '--') return name;

    return displayText(specific['carNumbColour']);
  }

  /// 解析性别展示文案。
  String _sexText(Object? value) {
    final code = _toInt(value);
    if (code == 1) return '男';
    if (code == 2) return '女';
    return displayText(value);
  }

  /// 解析审批状态展示文案。
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

  /// 将动态值安全转换为整数编码。
  int _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse((value ?? '').toString()) ?? -1;
  }

  /// 解析装载类型展示文案。
  String _loadTypeText(Map<String, dynamic> specific) {
    final name = displayText(specific['loadTypeName']);
    if (name != '--') return name;

    // 后端未返回字典名称时，按编码回退为固定文案。
    final code = _toInt(specific['loadType']);
    const map = <int, String>{0: '空载入园，空载出园', 1: '重载入园，空载出园', 2: '空载入园，重载出园', 3: '重载入园，重载出园'};
    return map[code] ?? displayText(specific['loadType']);
  }

  /// 解析危化品类型展示文案。
  String _goodsTypeText(Map<String, dynamic> goods) {
    final label = DictFieldQueryTool.goodsTypeLabel(goods['goodsType'], fallback: '--');
    if (label != '--') return label;

    final name = displayText(goods['goodsTypeName']);
    if (name != '--') return name;

    return displayText(goods['goodsType']);
  }

  /// 将开始和结束时间拼接为区间文本。
  String _rangeText(Object? begin, Object? end) {
    final beginText = displayText(begin);
    final endText = displayText(end);
    final left = beginText == '--' ? '-' : beginText;
    final right = endText == '--' ? '-' : endText;
    return '$left/$right';
  }
}

/// 详情分组中的单行展示数据。
class DetailLine {
  const DetailLine({required this.label, required this.value});

  final String label;
  final String value;
}

/// 详情页中的一个信息分组。
class DetailGroup {
  const DetailGroup({required this.title, required this.lines});

  final String title;
  final List<DetailLine> lines;
}
