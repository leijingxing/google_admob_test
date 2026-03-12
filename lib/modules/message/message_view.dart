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
            _buildTopBar(context),
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

  /// 构建页面顶部标题栏和标签栏的一体化区域。
  Widget _buildTopBar(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, statusBarHeight + 8, 20, 0),
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
          const SizedBox(height: 8),
          _buildTabBar(context),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// 构建标题与刷新按钮区域。
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
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B2B44),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 2),
              Text(
                '实时掌握通知、预警与报警记录',
                style: TextStyle(
                  fontSize: 11,
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

  /// 构建手动刷新按钮，点击后通过控制器触发列表重载。
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

  /// 构建顶部标签栏，用于切换通知、预警和报警列表。
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
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        padding: EdgeInsets.zero,
        indicatorPadding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        tabs: MessageTab.values
            .map((tab) => Tab(height: 32, text: tab.label))
            .toList(),
      ),
    );
  }

  /// 构建单个标签页下的消息列表，统一处理加载态和空态。
  Widget _buildMessageList(MessageTab tab) {
    return CustomEasyRefreshList<MessageItem>(
      key: PageStorageKey(tab),
      pageSize: 10,
      padding: const EdgeInsets.only(top: 4, bottom: 20),
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
        return _MessageCard(
          item: item,
          onTap: () => controller.onMessageTap(item),
        );
      },
    );
  }
}

/// 消息卡片，根据消息类型自动切换普通/紧凑布局。
class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.item, required this.onTap});

  final MessageItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color accentColor = item.type.foregroundColor;
    final Color softColor = item.type.backgroundColor;
    // 预警/报警信息项更多，采用更紧凑的卡片尺寸提升列表密度。
    final bool compact = item.isRiskWarning;

    return Container(
      margin: EdgeInsets.fromLTRB(20, compact ? 8 : 10, 20, 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(compact ? 16 : 20),
          child: Ink(
            padding: EdgeInsets.all(compact ? 12 : 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(compact ? 16 : 20),
              border: Border.all(
                color: accentColor.withValues(alpha: item.unread ? 0.28 : 0.12),
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.08),
                  blurRadius: compact ? 14 : 18,
                  offset: Offset(0, compact ? 6 : 8),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, softColor.withValues(alpha: 0.26)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MessageAvatar(
                      type: item.type,
                      unread: item.unread,
                      compact: compact,
                    ),
                    SizedBox(width: compact ? 10 : 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: compact ? 14 : 15,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1B2B44),
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              SizedBox(width: compact ? 6 : 8),
                              if (item.unread)
                                Container(
                                  width: compact ? 7 : 8,
                                  height: compact ? 7 : 8,
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: compact ? 6 : 8),
                          Wrap(
                            spacing: compact ? 6 : 8,
                            runSpacing: compact ? 6 : 8,
                            children: [
                              _MetaTag(
                                text: item.type.label,
                                textColor: accentColor,
                                backgroundColor: softColor,
                                compact: compact,
                              ),
                              _MetaTag(
                                text: item.statusText,
                                textColor: _statusTextColor(item),
                                backgroundColor: _statusBackgroundColor(item),
                                compact: compact,
                              ),
                              if (item.levelText.isNotEmpty)
                                _MetaTag(
                                  text: item.levelText,
                                  textColor: _levelTextColor(item.levelText),
                                  backgroundColor: _levelBackgroundColor(
                                    item.levelText,
                                  ),
                                  compact: compact,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (item.locationText.isNotEmpty ||
                    item.deviceText.isNotEmpty ||
                    item.targetText.isNotEmpty ||
                    item.carNumText.isNotEmpty) ...[
                  SizedBox(height: compact ? 10 : 14),
                  Wrap(
                    spacing: compact ? 6 : 8,
                    runSpacing: compact ? 6 : 8,
                    children: [
                      if (item.locationText.isNotEmpty)
                        _FactChip(
                          icon: Icons.place_outlined,
                          text: item.locationText,
                          compact: compact,
                        ),
                      if (item.deviceText.isNotEmpty)
                        _FactChip(
                          icon: Icons.sensors_outlined,
                          text: item.deviceText,
                          compact: compact,
                        ),
                      if (item.targetText.isNotEmpty)
                        _FactChip(
                          icon: Icons.person_outline,
                          text: item.targetText,
                          compact: compact,
                        ),
                      if (item.carNumText.isNotEmpty)
                        _FactChip(
                          icon: Icons.directions_car_outlined,
                          text: item.carNumText,
                          compact: compact,
                        ),
                    ],
                  ),
                ],
                SizedBox(height: compact ? 10 : 14),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: compact ? 13 : 14,
                      color: const Color(0xFF97A3B6),
                    ),
                    SizedBox(width: compact ? 4 : 6),
                    Expanded(
                      child: Text(
                        item.createDate,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: compact ? 11 : 12,
                          color: const Color(0xFF97A3B6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      item.isRiskWarning ? '查看详情' : '查看',
                      style: TextStyle(
                        fontSize: compact ? 11 : 12,
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: compact ? 0 : 2),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: accentColor,
                      size: compact ? 16 : 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 通知使用已读态颜色，预警/报警统一使用强调蓝色状态标识。
  Color _statusTextColor(MessageItem item) {
    if (!item.isRiskWarning) {
      return item.unread ? const Color(0xFFB64B00) : const Color(0xFF4E647E);
    }
    return const Color(0xFF1E5EFF);
  }

  /// 返回状态标签背景色。
  Color _statusBackgroundColor(MessageItem item) {
    if (!item.isRiskWarning) {
      return item.unread ? const Color(0xFFFFF1E8) : const Color(0xFFF1F4F9);
    }
    return const Color(0xFFEAF1FF);
  }

  /// 根据预警等级文案映射对应的前景色。
  Color _levelTextColor(String text) {
    switch (text) {
      case '红色':
        return const Color(0xFFD93A49);
      case '橙色':
        return const Color(0xFFE07A34);
      case '黄色':
        return const Color(0xFFB78700);
      case '蓝色':
        return const Color(0xFF2E6FFF);
      default:
        return const Color(0xFF5C6F86);
    }
  }

  /// 根据预警等级文案映射对应的背景色。
  Color _levelBackgroundColor(String text) {
    switch (text) {
      case '红色':
        return const Color(0xFFFFECEE);
      case '橙色':
        return const Color(0xFFFFF1E8);
      case '黄色':
        return const Color(0xFFFFF7DB);
      case '蓝色':
        return const Color(0xFFEAF2FF);
      default:
        return const Color(0xFFF1F4F9);
    }
  }
}

/// 消息图标区，未读状态下附带红点提示。
class _MessageAvatar extends StatelessWidget {
  const _MessageAvatar({
    required this.type,
    required this.unread,
    this.compact = false,
  });

  final MessageType type;
  final bool unread;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: compact ? 40 : 48,
          height: compact ? 40 : 48,
          decoration: BoxDecoration(
            color: type.backgroundColor,
            borderRadius: BorderRadius.circular(compact ? 12 : 15),
          ),
          child: Icon(
            type.icon,
            size: compact ? 20 : 24,
            color: type.foregroundColor,
          ),
        ),
        if (unread)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: compact ? 10 : 12,
              height: compact ? 10 : 12,
              decoration: BoxDecoration(
                color: const Color(0xFFFF5A5F),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: Colors.white,
                  width: compact ? 1.5 : 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// 顶部标签胶囊，用于展示类型、状态和等级。
class _MetaTag extends StatelessWidget {
  const _MetaTag({
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    this.compact = false,
  });

  final String text;
  final Color textColor;
  final Color backgroundColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: compact ? 10 : 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

/// 事实信息胶囊，用于承载位置、设备、目标、车牌等短文本。
class _FactChip extends StatelessWidget {
  const _FactChip({
    required this.icon,
    required this.text,
    this.compact = false,
  });

  final IconData icon;
  final String text;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 5 : 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE3EAF2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 12 : 14, color: const Color(0xFF7B8AA0)),
          SizedBox(width: compact ? 4 : 6),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: compact ? 132 : 150),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: compact ? 10 : 11,
                color: const Color(0xFF5B6B81),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
