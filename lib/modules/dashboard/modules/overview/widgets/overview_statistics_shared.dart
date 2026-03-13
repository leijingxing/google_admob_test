import 'package:flutter/material.dart';

import '../../../../../core/components/date_picker/custom_date_range_picker.dart';
import '../../../../../core/components/select/app_company_select_field.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/dimens.dart';

/// 区块标题。
class OverviewSectionTitle extends StatelessWidget {
  const OverviewSectionTitle({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: AppDimens.sp16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

/// 区块通用间距。
class OverviewSectionSpacing extends StatelessWidget {
  const OverviewSectionSpacing({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(height: AppDimens.dp16);
}

/// 日期范围筛选。
class OverviewDateRangeFilter extends StatelessWidget {
  const OverviewDateRangeFilter({
    required this.range,
    required this.onChanged,
    this.width,
    super.key,
  });

  final DateTimeRange? range;
  final ValueChanged<DateTimeRange?> onChanged;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? AppDimens.dp196,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: CustomDateRangePicker(
          startDate: range?.start,
          endDate: range?.end,
          compact: true,
          onDateRangeSelected: (start, end) {
            onChanged(buildOverviewDateRange(start, end));
          },
        ),
      ),
    );
  }
}

/// 企业选择控件。
class OverviewCompanySelectField extends StatelessWidget {
  const OverviewCompanySelectField({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final AppSelectedCompany? value;
  final ValueChanged<AppSelectedCompany?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await showAppCompanySelectDialog(
          context,
          initialValue: value,
          title: '选择企业',
        );
        if (result != null) {
          onChanged(result);
        }
      },
      borderRadius: BorderRadius.circular(AppDimens.dp8),
      child: Container(
        height: AppDimens.dp36,
        padding: EdgeInsets.symmetric(horizontal: AppDimens.dp10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FBFF),
          borderRadius: BorderRadius.circular(AppDimens.dp8),
          border: Border.all(color: const Color(0xFFD9E4F3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value?.displayName ?? '选择企业',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: value == null
                      ? const Color(0xFF8A98AF)
                      : const Color(0xFF5A6F8A),
                  fontSize: AppDimens.sp12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (value != null)
              GestureDetector(
                onTap: () => onChanged(null),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.only(right: AppDimens.dp6),
                  child: Icon(
                    Icons.close_rounded,
                    size: AppDimens.dp16,
                    color: const Color(0xFF9AA8BE),
                  ),
                ),
              ),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
      ),
    );
  }
}

/// 构建合法的日期范围。
DateTimeRange? buildOverviewDateRange(DateTime? start, DateTime? end) {
  if (start == null && end == null) return null;
  if (start != null && end != null) {
    final sortedStart = start.isBefore(end) ? start : end;
    final sortedEnd = start.isBefore(end) ? end : start;
    return DateTimeRange(start: sortedStart, end: sortedEnd);
  }
  final singleDay = start ?? end!;
  return DateTimeRange(start: singleDay, end: singleDay);
}
