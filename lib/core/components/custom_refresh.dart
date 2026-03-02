import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 数据加载器函数类型
/// pageIndex: 当前页码
/// pageSize: 每页数量
/// 返回一个 Future，其中包含获取到的数据列表
typedef DataLoader<T> = Future<List<T>> Function(int pageIndex, int pageSize);

/// 列表项构建器
typedef ItemBuilder<T> = Widget Function(BuildContext context, T item, int index);

/// 一个通用的、基于 EasyRefresh 的分页列表组件
class CustomEasyRefreshList<T> extends StatefulWidget {
  /// 异步数据加载函数
  final DataLoader<T> dataLoader;

  /// 列表项 UI 构建器
  final ItemBuilder<T> itemBuilder;

  /// 每页加载的数量
  final int pageSize;

  /// 是否启用下拉刷新，默认为 true
  final bool enableRefresh;

  /// 是否启用上拉加载更多，默认为 true
  final bool enableLoadMore;

  /// 是否在组件初始化时自动加载第一页数据，默认为 true
  final bool autoLoad;

  /// 数据为空时显示的 Widget
  final Widget? emptyWidget;

  /// 首次加载时显示的 Widget
  final Widget? initialLoadingWidget;

  /// 列表的内边距
  final EdgeInsetsGeometry? padding;

  /// 用于从外部触发刷新的 notifier
  final ValueListenable<int>? refreshTrigger;

  const CustomEasyRefreshList({
    super.key,
    required this.dataLoader,
    required this.itemBuilder,
    this.pageSize = 20,
    this.enableRefresh = true,
    this.enableLoadMore = true,
    this.autoLoad = true,
    this.emptyWidget,
    this.initialLoadingWidget,
    this.padding,
    this.refreshTrigger,
  });

  @override
  State<CustomEasyRefreshList<T>> createState() =>
      _CustomEasyRefreshListState<T>();
}

class _CustomEasyRefreshListState<T> extends State<CustomEasyRefreshList<T>> {
  late final EasyRefreshController _controller;
  final List<T> _items = [];
  int _pageIndex = 1;
  bool _isLoading = false;
  bool _isError = false;
  String _errorMessage = '';
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    if (widget.autoLoad) {
      _loadData(isRefresh: true);
    }
    widget.refreshTrigger?.addListener(_handleRefreshTrigger);
  }

  @override
  void didUpdateWidget(covariant CustomEasyRefreshList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.refreshTrigger != oldWidget.refreshTrigger) {
      oldWidget.refreshTrigger?.removeListener(_handleRefreshTrigger);
      widget.refreshTrigger?.addListener(_handleRefreshTrigger);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    widget.refreshTrigger?.removeListener(_handleRefreshTrigger);
    _controller.dispose();
    super.dispose();
  }

  void _handleRefreshTrigger() {
    if (mounted) {
      _controller.callRefresh();
    }
  }

  /// 核心数据加载逻辑
  Future<void> _loadData({bool isRefresh = false}) async {
    if (isRefresh && _items.isEmpty) {
      setState(() {
        _isLoading = true;
        _isError = false;
      });
    }

    try {
      final newPageIndex = isRefresh ? 1 : _pageIndex;
      final newItems = await widget.dataLoader(newPageIndex, widget.pageSize);

      if (_isDisposed) return;

      setState(() {
        if (isRefresh) {
          _items.clear();
        }
        _items.addAll(newItems);
        _pageIndex = newPageIndex + 1;
        _isLoading = false;
        _isError = false;
        _errorMessage = '';
      });

      if (isRefresh) {
        _controller.finishRefresh(IndicatorResult.success);
      }

      if (newItems.length < widget.pageSize) {
        _controller.finishLoad(IndicatorResult.noMore);
      } else {
        _controller.finishLoad(IndicatorResult.success);
      }
    } catch (e) {
      if (_isDisposed) return;

      setState(() {
        _isLoading = false;
        _isError = true;
        _errorMessage = e.toString();
      });

      if (isRefresh) {
        _controller.finishRefresh(IndicatorResult.fail);
      }
      _controller.finishLoad(IndicatorResult.fail);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.initialLoadingWidget ??
          const Center(child: CircularProgressIndicator());
    }

    if (_isError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('加载失败: $_errorMessage'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadData(isRefresh: true),
              child: const Text('点击重试'),
            ),
          ],
        ),
      );
    }

    return EasyRefresh(
      controller: _controller,
      onRefresh: widget.enableRefresh ? () => _loadData(isRefresh: true) : null,
      onLoad: widget.enableLoadMore ? _loadData : null,
      child: _items.isEmpty
          ? (widget.emptyWidget ??
              const CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('暂无数据')),
                  ),
                ],
              ))
          : ListView.builder(
              padding: widget.padding,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return widget.itemBuilder(context, _items[index], index);
              },
            ),
    );
  }
}
