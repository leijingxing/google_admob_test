import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 消息页控制器。
class MessageController extends GetxController {
  final ValueNotifier<int> refreshTrigger = ValueNotifier<int>(0);

  @override
  void onClose() {
    refreshTrigger.dispose();
    super.onClose();
  }

  /// 触发消息列表刷新。
  void triggerRefresh() {
    refreshTrigger.value++;
  }

  /// 分页加载消息数据。
  Future<List<MessageItem>> loadMessageData(int pageIndex, int pageSize) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final int start = (pageIndex - 1) * pageSize;
    if (start >= _mockMessages.length) {
      return [];
    }
    final int end = (start + pageSize).clamp(0, _mockMessages.length);
    return _mockMessages.sublist(start, end);
  }
}

enum MessageType {
  system(
    label: '系统通知',
    icon: Icons.notifications_active_rounded,
    backgroundColor: Color(0xFFEAF2FF),
    foregroundColor: Color(0xFF2F6BFF),
  ),
  activity(
    label: '活动提醒',
    icon: Icons.local_activity_rounded,
    backgroundColor: Color(0xFFFFF1E6),
    foregroundColor: Color(0xFFFB8C00),
  ),
  order(
    label: '业务进度',
    icon: Icons.inventory_2_rounded,
    backgroundColor: Color(0xFFE9F8EF),
    foregroundColor: Color(0xFF1E9E57),
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
    required this.content,
    required this.time,
    required this.type,
    required this.unread,
  });

  final String title;
  final String content;
  final String time;
  final MessageType type;
  final bool unread;
}

const List<MessageItem> _mockMessages = [
  MessageItem(
    title: '系统升级通知',
    content: '今晚 22:00 至 23:00 将进行系统维护，期间部分功能可能短暂不可用。',
    time: '刚刚',
    type: MessageType.system,
    unread: true,
  ),
  MessageItem(
    title: '春季活动已开启',
    content: '参与签到和邀请活动可领取积分奖励，活动截止至 3 月 20 日。',
    time: '10 分钟前',
    type: MessageType.activity,
    unread: true,
  ),
  MessageItem(
    title: '订单已发货',
    content: '您提交的样品订单已由仓库发出，请注意查收物流状态更新。',
    time: '30 分钟前',
    type: MessageType.order,
    unread: true,
  ),
  MessageItem(
    title: '审核结果通知',
    content: '您上次提交的企业资料已审核通过，现在可以继续下一步操作。',
    time: '今天 09:20',
    type: MessageType.system,
    unread: false,
  ),
  MessageItem(
    title: '限时优惠提醒',
    content: '您关注的套餐将于今晚结束优惠，若有需要建议尽快下单。',
    time: '今天 08:15',
    type: MessageType.activity,
    unread: false,
  ),
  MessageItem(
    title: '退款进度更新',
    content: '退款申请已进入打款流程，预计 1 至 3 个工作日内原路退回。',
    time: '昨天',
    type: MessageType.order,
    unread: false,
  ),
  MessageItem(
    title: '版本更新提示',
    content: '新版本已发布，优化了首页展示和消息提醒体验，建议及时更新。',
    time: '昨天',
    type: MessageType.system,
    unread: false,
  ),
  MessageItem(
    title: '直播开播提醒',
    content: '您预约的行业直播将在今天 19:30 开始，点击可提前进入等候页。',
    time: '昨天',
    type: MessageType.activity,
    unread: false,
  ),
  MessageItem(
    title: '发票申请已处理',
    content: '发票申请已处理完成，电子发票已发送到您的预留邮箱。',
    time: '03-04',
    type: MessageType.order,
    unread: false,
  ),
  MessageItem(
    title: '安全提醒',
    content: '检测到您的账号在新设备登录，如非本人操作请尽快修改密码。',
    time: '03-03',
    type: MessageType.system,
    unread: false,
  ),
  MessageItem(
    title: '积分到账通知',
    content: '您参与活动获得的 80 积分已到账，可前往积分商城查看。',
    time: '03-02',
    type: MessageType.activity,
    unread: false,
  ),
  MessageItem(
    title: '补货完成提醒',
    content: '您订阅的商品已补货成功，库存有限，建议尽快完成采购。',
    time: '03-01',
    type: MessageType.order,
    unread: false,
  ),
];
