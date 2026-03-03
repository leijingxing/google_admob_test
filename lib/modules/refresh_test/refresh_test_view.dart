import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/components/custom_refresh.dart';

/// CustomEasyRefreshList 功能测试页。
class RefreshTestView extends StatefulWidget {
  const RefreshTestView({super.key});

  @override
  State<RefreshTestView> createState() => _RefreshTestViewState();
}

enum _DemoMode {
  normal('正常数据'),
  empty('空数据'),
  error('异常');

  const _DemoMode(this.label);

  final String label;
}

class _RefreshTestViewState extends State<RefreshTestView> {
  final ValueNotifier<int> _refreshTrigger = ValueNotifier<int>(0);
  _DemoMode _mode = _DemoMode.normal;

  void _triggerRefresh() {
    _refreshTrigger.value++;
  }

  Future<List<String>> _loadDemoData(int pageIndex, int pageSize) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    switch (_mode) {
      case _DemoMode.empty:
        return [];
      case _DemoMode.error:
        throw Exception('模拟请求失败（第 $pageIndex 页）');
      case _DemoMode.normal:
        const int total = 47;
        final int start = (pageIndex - 1) * pageSize;
        if (start >= total) return [];
        final int end = min(start + pageSize, total);
        return List<String>.generate(end - start, (index) {
          final int itemNo = start + index + 1;
          return '第 $itemNo 条测试数据';
        });
    }
  }

  @override
  void dispose() {
    _refreshTrigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('刷新组件测试'),
        actions: [
          IconButton(
            onPressed: _triggerRefresh,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: '触发刷新',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const Text('数据模式：'),
                const SizedBox(width: 12),
                DropdownButton<_DemoMode>(
                  value: _mode,
                  onChanged: (value) {
                    if (value == null || value == _mode) return;
                    setState(() {
                      _mode = value;
                    });
                    _triggerRefresh();
                  },
                  items: _DemoMode.values
                      .map(
                        (mode) => DropdownMenuItem<_DemoMode>(
                          value: mode,
                          child: Text(mode.label),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomEasyRefreshList<String>(
              pageSize: 10,
              refreshTrigger: _refreshTrigger,
              dataLoader: _loadDemoData,
              initialLoadingWidget: const Center(
                child: CircularProgressIndicator(),
              ),
              emptyWidget: const CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('当前模式下没有数据')),
                  ),
                ],
              ),
              itemBuilder: (context, item, index) {
                return Card(
                  margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(item),
                    subtitle: Text('模式：${_mode.label}'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
