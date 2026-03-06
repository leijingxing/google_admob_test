import 'package:get/get.dart';

import '../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../data/models/workbench/inspection_abnormal_item_model.dart';
import '../../../../../../data/models/workbench/inspection_rectification_item_model.dart';
import '../../../../../../data/repository/workbench_repository.dart';

/// 隐患治理详情控制器。
class HiddenDangerGovernanceDetailController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

  late final InspectionAbnormalItemModel item;

  bool loading = false;
  Map<String, String> pointNameMap = <String, String>{};
  Map<String, String> ruleNameMap = <String, String>{};
  List<InspectionRectificationItemModel> rectifications =
      const <InspectionRectificationItemModel>[];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    item = args is InspectionAbnormalItemModel
        ? args
        : const InspectionAbnormalItemModel();
    loadData();
  }

  Future<void> loadData() async {
    loading = true;
    update();

    final futures = await Future.wait<dynamic>([
      _repository.getInspectionPointNameMap(),
      _repository.getInspectionRuleNameMap(),
      _repository.getInspectionRectifications(
        abnormalId: (item.id ?? '').trim(),
      ),
    ]);

    final pointResult = futures[0];
    pointResult.when(
      success: (data) => pointNameMap = data,
      failure: (error) => AppToast.showError(error.message),
    );

    final ruleResult = futures[1];
    ruleResult.when(
      success: (data) => ruleNameMap = data,
      failure: (error) => AppToast.showError(error.message),
    );

    final rectificationResult = futures[2];
    rectificationResult.when(
      success: (data) {
        final copied = List<InspectionRectificationItemModel>.from(data);
        copied.sort((left, right) {
          final l = _tryParseTime(left.rectifyTime);
          final r = _tryParseTime(right.rectifyTime);
          if (l == null && r == null) return 0;
          if (l == null) return -1;
          if (r == null) return 1;
          return l.compareTo(r);
        });
        rectifications = copied;
      },
      failure: (error) => AppToast.showError(error.message),
    );

    loading = false;
    update();
  }

  String get pointText {
    final name = (item.pointName ?? '').trim();
    if (name.isNotEmpty) return name;
    final pointId = (item.pointId ?? '').trim();
    if (pointId.isEmpty) return '--';
    return pointNameMap[pointId] ?? pointId;
  }

  String get ruleText {
    final name = (item.ruleName ?? '').trim();
    if (name.isNotEmpty) return name;
    final ruleId = (item.ruleId ?? '').trim();
    if (ruleId.isEmpty) return '--';
    return ruleNameMap[ruleId] ?? ruleId;
  }

  String get reporterText => _emptyDash(item.reporterName);

  String get urgentText => (item.isUrgent ?? '').trim() == '1' ? '是' : '否';

  String get statusText {
    switch ((item.abnormalStatus ?? '').trim()) {
      case 'PENDING_CONFIRM':
        return '待确认';
      case 'PENDING_RECTIFY':
        return '待整改';
      case 'RECTIFYING':
        return '整改中';
      case 'PENDING_VERIFY':
        return '待核查';
      case 'COMPLETED':
        return '已完成';
      case 'REASSIGN':
        return '待重新指派';
      default:
        return '--';
    }
  }

  String get reportTimeText => _emptyDash(item.reportTime);

  String get responsibleTypeText {
    switch ((item.responsibleType ?? '').trim()) {
      case 'ENTERPRISE':
        return '企业';
      case 'PERSONNEL':
        return '个人';
      default:
        return '--';
    }
  }

  String get responsibleNameText => _emptyDash(item.responsibleName);

  String get abnormalDescText => _emptyDash(item.abnormalDesc);

  List<String> get abnormalPhotos => _normalizePhotos(item.photoUrls);

  List<HiddenDangerDetailTimelineNode> get timelineNodes {
    return rectifications
        .map(
          (record) => HiddenDangerDetailTimelineNode(
            title: rectifyTypeText(record.rectifyType),
            timeText: _emptyDash(record.rectifyTime),
            lines: <HiddenDangerDetailTimelineLine>[
              HiddenDangerDetailTimelineLine(
                label: '整改类型',
                value: rectifyTypeText(record.rectifyType),
              ),
              HiddenDangerDetailTimelineLine(
                label: '整改人',
                value: _emptyDash(record.rectifyUserName),
              ),
              HiddenDangerDetailTimelineLine(
                label: '整改描述',
                value: _emptyDash(record.rectifyDesc),
              ),
              HiddenDangerDetailTimelineLine(
                label: '整改附件',
                photoUrls: _normalizePhotos(record.photoUrls),
              ),
              HiddenDangerDetailTimelineLine(
                label: '整改时间',
                value: _emptyDash(record.rectifyTime),
              ),
              HiddenDangerDetailTimelineLine(
                label: '核查结果',
                value: verifyResultText(record.verifyResult),
              ),
              HiddenDangerDetailTimelineLine(
                label: '状态',
                value: rectificationStatusText(record.status),
              ),
            ],
          ),
        )
        .toList();
  }

  String rectifyTypeText(String? rectifyType) {
    switch ((rectifyType ?? '').trim()) {
      case 'INITIAL':
        return '初始整改';
      case 'REJECT':
        return '驳回重改';
      case 'REASSIGN':
        return '重新指派';
      default:
        return '--';
    }
  }

  String verifyResultText(String? verifyResult) {
    switch ((verifyResult ?? '').trim()) {
      case 'PASS':
        return '通过';
      case 'REJECT':
        return '驳回';
      default:
        return '--';
    }
  }

  String rectificationStatusText(String? status) {
    switch ((status ?? '').trim()) {
      case 'PENDING_VERIFY':
        return '待核查';
      case 'PASSED':
        return '已通过';
      case 'REJECTED':
        return '已驳回';
      default:
        return '--';
    }
  }

  List<String> _normalizePhotos(List<String>? photos) {
    if (photos == null || photos.isEmpty) return const <String>[];
    return photos
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && e.toLowerCase() != 'null')
        .toList();
  }

  DateTime? _tryParseTime(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return null;
    final normalized = text.contains(' ') ? text.replaceFirst(' ', 'T') : text;
    return DateTime.tryParse(normalized);
  }

  String _emptyDash(String? value) {
    final text = (value ?? '').trim();
    return text.isEmpty ? '--' : text;
  }
}

/// 时间线节点。
class HiddenDangerDetailTimelineNode {
  final String title;
  final String timeText;
  final List<HiddenDangerDetailTimelineLine> lines;

  const HiddenDangerDetailTimelineNode({
    required this.title,
    required this.timeText,
    required this.lines,
  });
}

/// 时间线节点行信息。
class HiddenDangerDetailTimelineLine {
  final String label;
  final String value;
  final List<String> photoUrls;

  const HiddenDangerDetailTimelineLine({
    required this.label,
    this.value = '--',
    this.photoUrls = const <String>[],
  });

  bool get isPhoto => label.contains('照片') || label.contains('附件');
}
