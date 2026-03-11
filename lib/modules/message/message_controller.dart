import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 消息页控制器。
class MessageController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final ValueNotifier<int> refreshTrigger = ValueNotifier<int>(0);

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: MessageTab.values.length, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    refreshTrigger.dispose();
    super.onClose();
  }

  /// 触发消息列表刷新。
  void triggerRefresh() {
    refreshTrigger.value++;
  }

  /// 分页加载消息数据。
  Future<List<MessageItem>> loadMessageData(MessageTab tab, int pageIndex, int pageSize) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final List<MessageItem> currentList = _mockMessages
        .where((item) => item.tab == tab)
        .toList(growable: false);
    final int start = (pageIndex - 1) * pageSize;
    if (start >= currentList.length) {
      return [];
    }
    final int end = (start + pageSize).clamp(0, currentList.length);
    return currentList.sublist(start, end);
  }
}

enum MessageTab {
  notice(label: '通知'),
  warning(label: '预警'),
  alarm(label: '报警');

  const MessageTab({required this.label});

  final String label;
}

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

class MessageItem {
  const MessageItem({
    required this.title,
    this.content,
    this.description,
    required this.createDate,
    required this.type,
    required this.tab,
    this.receiverStatus = 2,
    this.beViewed = 1,
  });

  final String title;
  final String? content;
  final String? description;
  final String createDate;
  final MessageType type;
  final MessageTab tab;
  final int receiverStatus;
  final int beViewed;

  String get displayContent {
    final String warningContent = (description ?? '').trim();
    if (warningContent.isNotEmpty) {
      return warningContent;
    }
    return (content ?? '').trim();
  }

  bool get unread => receiverStatus != 2 || beViewed != 1;
}

const List<MessageItem> _mockMessages = [
  MessageItem(
    title: '系统升级通知',
    content: '今晚 22:00 至 23:00 将进行系统维护，期间部分功能可能短暂不可用。',
    createDate: '刚刚',
    type: MessageType.notice,
    tab: MessageTab.notice,
    receiverStatus: 1,
  ),
  MessageItem(
    title: '春季活动已开启',
    content: '参与签到和邀请活动可领取积分奖励，活动截止至 3 月 20 日。',
    createDate: '10 分钟前',
    type: MessageType.notice,
    tab: MessageTab.notice,
    receiverStatus: 1,
  ),
  MessageItem(
    title: '审核结果通知',
    content: '您上次提交的企业资料已审核通过，现在可以继续下一步操作。',
    createDate: '今天 09:20',
    type: MessageType.notice,
    tab: MessageTab.notice,
  ),
  MessageItem(
    title: '版本更新提示',
    content: '新版本已发布，优化了首页展示和消息提醒体验，建议及时更新。',
    createDate: '昨天',
    type: MessageType.notice,
    tab: MessageTab.notice,
  ),
  MessageItem(
    title: '安全提醒',
    content: '检测到您的账号在新设备登录，如非本人操作请尽快修改密码。',
    createDate: '03-03',
    type: MessageType.notice,
    tab: MessageTab.notice,
  ),
  MessageItem(
    title: '叉车偏航预警',
    description: '3 号仓东侧通道监测到叉车连续偏航，请及时核查现场情况。',
    createDate: '30 分钟前',
    type: MessageType.warning,
    tab: MessageTab.warning,
    beViewed: 0,
  ),
  MessageItem(
    title: '设备温升预警',
    description: '北区配电柜温升接近阈值，建议尽快安排巡检与复测。',
    createDate: '03-04',
    type: MessageType.warning,
    tab: MessageTab.warning,
  ),
  MessageItem(
    title: '燃气浓度预警',
    description: '1 号车间燃气浓度持续升高，请立即安排巡检确认。',
    createDate: '03-02',
    type: MessageType.warning,
    tab: MessageTab.warning,
    beViewed: 0,
  ),
  MessageItem(
    title: '围栏越界报警',
    description: '西门围栏区域触发越界报警，请安排值班人员复核告警原因。',
    createDate: '昨天',
    type: MessageType.alarm,
    tab: MessageTab.alarm,
  ),
  MessageItem(
    title: '夜间巡检报警',
    description: '夜间巡检发现 2 号楼消防通道占用，请立即通知相关责任人处理。',
    createDate: '03-01',
    type: MessageType.alarm,
    tab: MessageTab.alarm,
    beViewed: 0,
  ),
  MessageItem(
    title: '危化车提交预警',
    description: '危化车 JIA12345 成功提交预约，待审批。',
    createDate: '2026-01-20 15:16:32',
    type: MessageType.alarm,
    tab: MessageTab.alarm,
    beViewed: 0,
  ),
  MessageItem(
    title: '危化车完成审批',
    description: '危化车 JIA12345 完成审批，待抽检。',
    createDate: '2026-01-20 15:16:32',
    type: MessageType.alarm,
    tab: MessageTab.alarm,
  ),
];
