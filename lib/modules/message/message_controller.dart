import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/components/toast/toast_widget.dart';
import '../../data/models/workbench/risk_warning_disposal_item_model.dart';
import '../../data/repository/workbench_repository.dart';
import '../../router/module_routes/workbench_routes.dart';

/// 消息页控制器。
class MessageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// 工作台仓库，负责预警/报警列表数据拉取。
  final WorkbenchRepository _repository = WorkbenchRepository();

  /// 顶部标签页控制器。
  late TabController tabController;

  /// 刷新触发器，通过自增值通知列表组件重新请求数据。
  final ValueNotifier<int> refreshTrigger = ValueNotifier<int>(0);

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(
      length: MessageTab.values.length,
      vsync: this,
    );
  }

  @override
  void onClose() {
    tabController.dispose();
    refreshTrigger.dispose();
    super.onClose();
  }

  /// 主动触发当前页签列表刷新。
  void triggerRefresh() {
    refreshTrigger.value++;
  }

  /// 处理消息点击事件，仅预警/报警消息支持跳转到对应详情页。
  Future<void> onMessageTap(MessageItem item) async {
    final detail = item.riskWarningItem;
    if (detail == null || (detail.id ?? '').trim().isEmpty) {
      return;
    }

    switch (item.tab) {
      case MessageTab.notice:
        return;
      case MessageTab.warning:
        // 预警与报警详情入口分开封装，避免业务层直接处理跳转细节。
        await WorkbenchRoutes.toWarningDisposalDetail(item: detail);
        return;
      case MessageTab.alarm:
        await WorkbenchRoutes.toAlarmDisposalDetail(item: detail);
        return;
    }
  }

  /// 按标签页分发对应的数据源。
  Future<List<MessageItem>> loadMessageData(
    MessageTab tab,
    int pageIndex,
    int pageSize,
  ) async {
    switch (tab) {
      case MessageTab.notice:
        return _loadNoticeData(pageIndex, pageSize);
      case MessageTab.warning:
        return _loadRiskWarningData(
          warningType: 1,
          tab: tab,
          pageIndex: pageIndex,
          pageSize: pageSize,
        );
      case MessageTab.alarm:
        return _loadRiskWarningData(
          warningType: 2,
          tab: tab,
          pageIndex: pageIndex,
          pageSize: pageSize,
        );
    }
  }

  /// 通知页当前仍使用本地模拟数据，占位真实通知接口。
  Future<List<MessageItem>> _loadNoticeData(int pageIndex, int pageSize) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final List<MessageItem> currentList = _mockMessages
        .where((item) => item.tab == MessageTab.notice)
        .toList(growable: false);
    final int start = (pageIndex - 1) * pageSize;
    if (start >= currentList.length) {
      return [];
    }
    final int end = (start + pageSize).clamp(0, currentList.length);
    return currentList.sublist(start, end);
  }

  /// 拉取预警/报警分页数据，并统一映射为消息卡片模型。
  Future<List<MessageItem>> _loadRiskWarningData({
    required int warningType,
    required MessageTab tab,
    required int pageIndex,
    required int pageSize,
  }) async {
    final result = await _repository.getRiskWarningDisposalPage(
      warningType: warningType,
      warningStatus: 0,
      current: pageIndex,
      size: pageSize,
    );

    return result.when(
      success: (pageData) => pageData.items
          .map((item) => _mapRiskWarningMessage(item: item, tab: tab))
          .toList(growable: false),
      failure: (error) {
        AppToast.showError(error.message);
        throw Exception(error.message);
      },
    );
  }

  /// 将工作台预警处置项转换为消息页展示模型。
  MessageItem _mapRiskWarningMessage({
    required RiskWarningDisposalItemModel item,
    required MessageTab tab,
  }) {
    final MessageType type = tab == MessageTab.warning
        ? MessageType.warning
        : MessageType.alarm;

    return MessageItem(
      id: item.id,
      title: _firstNotEmpty([
        item.title,
        item.moduleTypeName,
        item.subModuleTypeName,
        item.relationName,
        item.deviceName,
        item.targetValue,
        type.label,
      ]),
      createDate: _displayTimeOf(item),
      type: type,
      tab: tab,
      beViewed: item.beViewed,
      riskWarningItem: item,
    );
  }

  /// 从多个候选时间字段中选取最合适的展示时间。
  String _displayTimeOf(RiskWarningDisposalItemModel item) {
    return _firstNotEmpty([
      item.warningStartTime,
      item.giveWarningDate,
      item.dispatcherToDate,
      item.disposalDate,
      item.cancelWarningDate,
      item.warningEndTime,
      '--',
    ]);
  }

  /// 返回第一个非空字符串，用于兼容接口字段缺失场景。
  String _firstNotEmpty(List<String?> values) {
    for (final value in values) {
      final String text = (value ?? '').trim();
      if (text.isNotEmpty) {
        return text;
      }
    }
    return '';
  }
}

/// 消息中心顶部页签类型。
enum MessageTab {
  notice(label: '通知'),
  warning(label: '预警'),
  alarm(label: '报警');

  const MessageTab({required this.label});

  final String label;
}

/// 消息类型定义，承载图标和主题色。
enum MessageType {
  notice(
    label: '通知',
    icon: Icons.notifications_active_rounded,
    backgroundColor: Color(0xFFEAF2FF),
    foregroundColor: Color(0xFF2F6BFF),
  ),
  warning(
    label: '预警',
    icon: Icons.warning_amber_rounded,
    backgroundColor: Color(0xFFFFF4E8),
    foregroundColor: Color(0xFFF2994A),
  ),
  alarm(
    label: '报警',
    icon: Icons.crisis_alert_rounded,
    backgroundColor: Color(0xFFFFEBEE),
    foregroundColor: Color(0xFFE53935),
  );

  const MessageType({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
}

/// 消息页统一展示模型，屏蔽通知与预警/报警源数据差异。
class MessageItem {
  const MessageItem({
    this.id,
    required this.title,
    required this.createDate,
    required this.type,
    required this.tab,
    this.receiverStatus = 2,
    this.beViewed = 1,
    this.riskWarningItem,
  });

  final String? id;
  final String title;
  final String createDate;
  final MessageType type;
  final MessageTab tab;
  final int receiverStatus;
  final int beViewed;
  final RiskWarningDisposalItemModel? riskWarningItem;

  /// 是否为预警/报警消息，用于区分卡片样式和跳转行为。
  bool get isRiskWarning =>
      tab == MessageTab.warning || tab == MessageTab.alarm;

  /// 通知展示已读状态，预警/报警固定展示持续中。
  String get statusText {
    if (!isRiskWarning) {
      return unread ? '未读' : '已读';
    }
    return '持续中';
  }

  /// 将接口中的等级编码映射为页面展示文本。
  String get levelText {
    final level = riskWarningItem?.warningLevel ?? -1;
    switch (level) {
      case 0:
        return '无等级';
      case 1:
        return '红色';
      case 2:
        return '橙色';
      case 3:
        return '黄色';
      case 4:
        return '蓝色';
      default:
        return '';
    }
  }

  /// 优先展示详细位置描述，没有时回退到位置字段。
  String get locationText => _firstNotEmpty([
    riskWarningItem?.positionDescription,
    riskWarningItem?.position,
  ]);

  /// 设备名称。
  String get deviceText => (riskWarningItem?.deviceName ?? '').trim();

  /// 目标对象文案。
  String get targetText => (riskWarningItem?.targetValue ?? '').trim();

  /// 车牌号文案。
  String get carNumText => (riskWarningItem?.carNum ?? '').trim();

  /// 兼容接收状态和查看状态两种未读判定来源。
  bool get unread => receiverStatus != 2 || beViewed != 1;

  /// 返回第一个非空文本，避免 UI 直接处理空字符串兜底。
  String _firstNotEmpty(List<String?> values) {
    for (final value in values) {
      final String text = (value ?? '').trim();
      if (text.isNotEmpty) {
        return text;
      }
    }
    return '';
  }
}

/// 通知页本地占位数据。
const List<MessageItem> _mockMessages = [
  MessageItem(
    title: '系统升级通知',
    createDate: '刚刚',
    type: MessageType.notice,
    tab: MessageTab.notice,
    receiverStatus: 1,
  ),
  MessageItem(
    title: '春季活动已开启',
    createDate: '10 分钟前',
    type: MessageType.notice,
    tab: MessageTab.notice,
    receiverStatus: 1,
  ),
  MessageItem(
    title: '审核结果通知',
    createDate: '今天 09:20',
    type: MessageType.notice,
    tab: MessageTab.notice,
  ),
  MessageItem(
    title: '版本更新提示',
    createDate: '昨天',
    type: MessageType.notice,
    tab: MessageTab.notice,
  ),
  MessageItem(
    title: '安全提醒',
    createDate: '03-03',
    type: MessageType.notice,
    tab: MessageTab.notice,
  ),
];
