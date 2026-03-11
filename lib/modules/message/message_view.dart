import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/components/custom_refresh.dart';
import 'message_controller.dart';

/// 消息页，采用 TabBar + TabBarView 结构。
class MessageView extends GetView<MessageController> {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F8FC),
        body: Column(
          children: [
            // 整合的顶部区域
            _buildTopBar(context),

            // 内容区域
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: MessageTab.values
                    .map((tab) => _buildMessageList(tab))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建整合的顶部 Bar (Header + Tabs)
  Widget _buildTopBar(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, statusBarHeight + 8, 20, 0), // 底部 padding 设为 0
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF103A6F).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(controller),
          const SizedBox(height: 8), // 缩小标题与 TabBar 间距
          _buildTabBar(context),
          const SizedBox(height: 8), // TabBar 下方留极小间距
        ],
      ),
    );
  }

  /// 构建头部标题
  Widget _buildHeader(MessageController controller) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '消息中心',
                style: TextStyle(
                  fontSize: 22, // 稍微缩小标题字号
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B2B44),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 2),
              Text(
                '实时掌握通知、预警与报警记录',
                style: TextStyle(
                  fontSize: 11, // 缩小副标题
                  color: Color(0xFF98A6B9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        _buildRefreshButton(controller),
      ],
    );
  }

  /// 构建刷新按钮
  Widget _buildRefreshButton(MessageController controller) {
    return Material(
      color: const Color(0xFFF1F4F9),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: controller.triggerRefresh,
        borderRadius: BorderRadius.circular(10),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(
            Icons.refresh_rounded,
            size: 18,
            color: Color(0xFF5B6B81),
          ),
        ),
      ),
    );
  }

  /// 构建 TabBar
  Widget _buildTabBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: controller.tabController,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF103A6F).withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: const Color(0xFF2F6BFF),
        unselectedLabelColor: const Color(0xFF7B8AA0),
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        padding: EdgeInsets.zero,
        indicatorPadding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        tabs: MessageTab.values
            .map((tab) => Tab(
                  height: 32, // 缩小 Tab 高度
                  text: tab.label,
                ))
            .toList(),
      ),
    );
  }

  /// 构建独立的消息列表
  Widget _buildMessageList(MessageTab tab) {
    return CustomEasyRefreshList<MessageItem>(
      key: PageStorageKey(tab),
      pageSize: 10,
      padding: const EdgeInsets.only(top: 4, bottom: 20), // 设置明确的顶部间距
      refreshTrigger: controller.refreshTrigger,
      dataLoader: (page, size) => controller.loadMessageData(tab, page, size),
      initialLoadingWidget: const Center(
        child: CircularProgressIndicator(strokeWidth: 3),
      ),
      emptyWidget: const CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                '暂无相关消息',
                style: TextStyle(color: Color(0xFF98A6B9), fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      itemBuilder: (context, item, index) {
        return _MessageCard(item: item);
      },
    );
  }
}

/// 消息卡片组件
class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.item});

  final MessageItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF103A6F).withValues(alpha: 0.06),
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
                      item.createDate,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF98A6B9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.displayContent,
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
