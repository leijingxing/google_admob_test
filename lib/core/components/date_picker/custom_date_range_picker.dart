import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// @description 一个美观、易用的日期范围选择组件
/// 点击后会从底部弹出 iOS 风格的选择器
class CustomDateRangePicker extends StatelessWidget {
  static DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

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
    final DateTime safeDate = date ?? _today;
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
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return _DatePickerSheet(
          initialStartDate: startDate ?? _today,
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
    final normalized = _normalizeRange(
      widget.initialStartDate,
      widget.initialEndDate,
    );
    _startDate = normalized.$1;
    _endDate = normalized.$2;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedDate = _isSelectingStart ? _startDate : _endDate;
    final minimumDate = _isSelectingStart ? DateTime(2000) : _startDate;
    final initialDateTime = _resolvePickerInitialDate(
      selectedDate: selectedDate,
      minimumDate: minimumDate,
      maximumDate: DateTime(2101),
    );

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
              initialDateTime: initialDateTime,
              minimumDate: minimumDate,
              maximumDate: DateTime(2101),
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  if (_isSelectingStart) {
                    _startDate = newDate;
                    // 结束时间早于开始时间时，自动同步为开始时间，避免组件报错。
                    if (_endDate != null && _endDate!.isBefore(_startDate!)) {
                      _endDate = _startDate;
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
    final primaryColor = theme.primaryColor;
    final borderColor = isSelected ? primaryColor : Colors.grey.shade300;
    final backgroundColor = isSelected
        ? primaryColor.withValues(alpha: 0.08)
        : const Color(0xFFF7F9FC);
    final titleColor = isSelected ? primaryColor : Colors.grey.shade700;
    final valueColor = isSelected ? const Color(0xFF1D4ED8) : Colors.black87;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 1.6 : 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  size: 16,
                  color: titleColor,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '当前选择',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              date != null ? CustomDateRangePicker._displayDate(date) : '未设置',
              style: TextStyle(
                color: valueColor,
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
              onPressed: () {
                final normalized = _normalizeRange(_startDate, _endDate);
                widget.onConfirm(normalized.$1, normalized.$2);
              },
              child: const Text('确认'),
            ),
          ),
        ],
      ),
    );
  }

  (DateTime?, DateTime?) _normalizeRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return (start, end);
    if (start.isAfter(end)) {
      return (end, start);
    }
    return (start, end);
  }

  DateTime _resolvePickerInitialDate({
    required DateTime? selectedDate,
    required DateTime? minimumDate,
    required DateTime maximumDate,
  }) {
    final fallback = selectedDate ?? minimumDate ?? DateTime.now();
    if (fallback.isAfter(maximumDate)) return maximumDate;
    if (minimumDate != null && fallback.isBefore(minimumDate)) {
      return minimumDate;
    }
    return fallback;
  }
}
