import 'package:flutter/material.dart';

import '../../../../../core/constants/dimens.dart';

/// 工作台通用分段 Tab 数据。
class WorkbenchSegmentTabItem {
  final String label;

  const WorkbenchSegmentTabItem({required this.label});
}

/// 工作台通用分段 Tab，可在多页面复用。
class WorkbenchSegmentTabs extends StatelessWidget {
  const WorkbenchSegmentTabs({
    required this.items,
    required this.currentIndex,
    required this.onChanged,
    super.key,
  });

  final List<WorkbenchSegmentTabItem> items;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.dp36,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1F7BFF), width: 1),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final selected = index == currentIndex;
          final item = items[index];
          return Expanded(
            child: InkWell(
              onTap: () => onChanged(index),
              child: Container(
                color: selected ? const Color(0xFF1F7BFF) : Colors.white,
                alignment: Alignment.center,
                child: Text(
                  item.label,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF1F7BFF),
                    fontSize: AppDimens.sp12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
