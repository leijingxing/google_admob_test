import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// @description 一个美观、易用的日期范围选择组件
/// 点击后会从底部弹出 iOS 风格的选择器
class CustomDateRangePicker extends StatelessWidget {
  /// 选中的开始日期
  final DateTime? startDate;

  /// 选中的结束日期
  final DateTime? endDate;

  /// 日期范围选择后的回调
  final Function(DateTime? start, DateTime? end) onDateRangeSelected;

  /// 是否使用紧凑模式（更小的高度与字号）
  final bool compact;

  const CustomDateRangePicker({
    super.key,
    this.startDate,
    this.endDate,
    required this.onDateRangeSelected,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildDateDisplay(
            context: context,
            label: '开始时间',
            date: startDate,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('-'),
        ),
        Expanded(
          child: _buildDateDisplay(
            context: context,
            label: '结束时间',
            date: endDate,
          ),
        ),
      ],
    );
  }

  static String _displayDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year年$month月$day日';
  }

  /// 构建单个日期显示框
  Widget _buildDateDisplay({
    required BuildContext context,
    required String label,
    DateTime? date,
  }) {
    final bool hasValue = date != null;
    final DateTime safeDate = date ?? DateTime.now();
    final String displayText = hasValue ? _displayDate(safeDate) : label;

    return InkWell(
      onTap: () => _showDatePickerSheet(context),
      borderRadius: BorderRadius.circular(compact ? 6 : 8),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: compact ? 8 : 12,
          horizontal: compact ? 6 : 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(compact ? 6 : 8),
          color: compact ? const Color(0xFFF8FAFD) : null,
        ),
        child: Text(
          displayText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: hasValue ? Colors.black87 : Colors.grey.shade600,
            fontSize: compact ? 12 : 14,
          ),
        ),
      ),
    );
  }

  /// 显示底部日期选择弹窗
  void _showDatePickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return _DatePickerSheet(
          initialStartDate: startDate,
          initialEndDate: endDate,
          onConfirm: (start, end) {
            onDateRangeSelected(start, end);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

/// 底部弹窗的内部状态管理
class _DatePickerSheet extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime?, DateTime?) onConfirm;

  const _DatePickerSheet({
    this.initialStartDate,
    this.initialEndDate,
    required this.onConfirm,
  });

  @override
  State<_DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<_DatePickerSheet> {
  late DateTime? _startDate;
  late DateTime? _endDate;
  bool _isSelectingStart = true; // true: 选择开始日期, false: 选择结束日期

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedDate = _isSelectingStart ? _startDate : _endDate;

    return SafeArea(
      child: Wrap(
        children: [
          // 顶部标题和关闭按钮
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('选择日期', style: theme.textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          // 开始/结束日期切换器
          _buildDateToggle(),
          const Divider(height: 1),
          // CupertinoDatePicker
          SizedBox(
            height: 220,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: selectedDate ?? DateTime.now(),
              minimumDate: _isSelectingStart ? DateTime(2000) : _startDate,
              maximumDate: DateTime(2101),
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  if (_isSelectingStart) {
                    _startDate = newDate;
                    // 如果结束日期早于新的开始日期，则清空结束日期
                    if (_endDate != null && _endDate!.isBefore(_startDate!)) {
                      _endDate = null;
                    }
                  } else {
                    _endDate = newDate;
                  }
                });
              },
            ),
          ),
          const Divider(height: 1),
          // 底部按钮
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// 构建日期切换器
  Widget _buildDateToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleChild(
              label: '开始时间',
              date: _startDate,
              isSelected: _isSelectingStart,
              onTap: () => setState(() => _isSelectingStart = true),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildToggleChild(
              label: '结束时间',
              date: _endDate,
              isSelected: !_isSelectingStart,
              onTap: () => setState(() => _isSelectingStart = false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleChild({
    required String label,
    required DateTime? date,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final color = isSelected ? theme.primaryColor : Colors.grey.shade600;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: color, width: 2.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: color, fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              date != null ? CustomDateRangePicker._displayDate(date) : '未设置',
              style: TextStyle(
                color: isSelected ? theme.primaryColor : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建底部操作按钮
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _startDate = null;
                  _endDate = null;
                });
              },
              child: const Text('重置'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => widget.onConfirm(_startDate, _endDate),
              child: const Text('确认'),
            ),
          ),
        ],
      ),
    );
  }
}
