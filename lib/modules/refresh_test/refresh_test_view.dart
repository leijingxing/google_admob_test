import 'package:flutter/material.dart';

import '../../core/components/custom_refresh.dart';

/// 消息页，当前先展示假数据。
class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final ValueNotifier<int> _refreshTrigger = ValueNotifier<int>(0);

  void _triggerRefresh() {
    _refreshTrigger.value++;
  }

  Future<List<_MessageItem>> _loadMessageData(
    int pageIndex,
    int pageSize,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final int start = (pageIndex - 1) * pageSize;
    if (start >= _mockMessages.length) {
      return [];
    }
    final int end = (start + pageSize).clamp(0, _mockMessages.length);
    return _mockMessages.sublist(start, end);
  }

  @override
  void dispose() {
    _refreshTrigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '消息',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1B2B44),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '展示系统通知、互动提醒和业务进度消息',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF7B8AA0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _triggerRefresh,
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: '刷新消息',
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomEasyRefreshList<_MessageItem>(
                pageSize: 10,
                refreshTrigger: _refreshTrigger,
                dataLoader: _loadMessageData,
                initialLoadingWidget: const Center(
                  child: CircularProgressIndicator(),
                ),
                emptyWidget: const CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text('暂无消息')),
                    ),
                  ],
                ),
                itemBuilder: (context, item, index) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF103A6F,
                          ).withValues(alpha: 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _MessageAvatar(type: item.type, unread: item.unread),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1B2B44),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item.time,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF98A6B9),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.content,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.5,
                                  color: Color(0xFF5B6B81),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: item.type.backgroundColor,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      item.type.label,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: item.type.foregroundColor,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    color: Color(0xFFB0BCCB),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageAvatar extends StatelessWidget {
  const _MessageAvatar({required this.type, required this.unread});

  final _MessageType type;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: type.backgroundColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(type.icon, color: type.foregroundColor),
        ),
        if (unread)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0xFFFF5A5F),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}

enum _MessageType {
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

  const _MessageType({
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

class _MessageItem {
  const _MessageItem({
    required this.title,
    required this.content,
    required this.time,
    required this.type,
    required this.unread,
  });

  final String title;
  final String content;
  final String time;
  final _MessageType type;
  final bool unread;
}

const List<_MessageItem> _mockMessages = [
  _MessageItem(
    title: '系统升级通知',
    content: '今晚 22:00 至 23:00 将进行系统维护，期间部分功能可能短暂不可用。',
    time: '刚刚',
    type: _MessageType.system,
    unread: true,
  ),
  _MessageItem(
    title: '春季活动已开启',
    content: '参与签到和邀请活动可领取积分奖励，活动截止至 3 月 20 日。',
    time: '10 分钟前',
    type: _MessageType.activity,
    unread: true,
  ),
  _MessageItem(
    title: '订单已发货',
    content: '您提交的样品订单已由仓库发出，请注意查收物流状态更新。',
    time: '30 分钟前',
    type: _MessageType.order,
    unread: true,
  ),
  _MessageItem(
    title: '审核结果通知',
    content: '您上次提交的企业资料已审核通过，现在可以继续下一步操作。',
    time: '今天 09:20',
    type: _MessageType.system,
    unread: false,
  ),
  _MessageItem(
    title: '限时优惠提醒',
    content: '您关注的套餐将于今晚结束优惠，若有需要建议尽快下单。',
    time: '今天 08:15',
    type: _MessageType.activity,
    unread: false,
  ),
  _MessageItem(
    title: '退款进度更新',
    content: '退款申请已进入打款流程，预计 1 至 3 个工作日内原路退回。',
    time: '昨天',
    type: _MessageType.order,
    unread: false,
  ),
  _MessageItem(
    title: '版本更新提示',
    content: '新版本已发布，优化了首页展示和消息提醒体验，建议及时更新。',
    time: '昨天',
    type: _MessageType.system,
    unread: false,
  ),
  _MessageItem(
    title: '直播开播提醒',
    content: '您预约的行业直播将在今天 19:30 开始，点击可提前进入等候页。',
    time: '昨天',
    type: _MessageType.activity,
    unread: false,
  ),
  _MessageItem(
    title: '发票申请已处理',
    content: '发票申请已处理完成，电子发票已发送到您的预留邮箱。',
    time: '03-04',
    type: _MessageType.order,
    unread: false,
  ),
  _MessageItem(
    title: '安全提醒',
    content: '检测到您的账号在新设备登录，如非本人操作请尽快修改密码。',
    time: '03-03',
    type: _MessageType.system,
    unread: false,
  ),
  _MessageItem(
    title: '积分到账通知',
    content: '您参与活动获得的 80 积分已到账，可前往积分商城查看。',
    time: '03-02',
    type: _MessageType.activity,
    unread: false,
  ),
  _MessageItem(
    title: '补货完成提醒',
    content: '您订阅的商品已补货成功，库存有限，建议尽快完成采购。',
    time: '03-01',
    type: _MessageType.order,
    unread: false,
  ),
];
