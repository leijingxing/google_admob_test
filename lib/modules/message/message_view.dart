import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/components/custom_refresh.dart';
import 'message_controller.dart';

/// 消息页，当前先展示假数据。
class MessageView extends GetView<MessageController> {
  const MessageView({super.key});

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
                    onPressed: controller.triggerRefresh,
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: '刷新消息',
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomEasyRefreshList<MessageItem>(
                pageSize: 10,
                refreshTrigger: controller.refreshTrigger,
                dataLoader: controller.loadMessageData,
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

  final MessageType type;
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
