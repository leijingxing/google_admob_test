import 'package:flutter/material.dart';

import '../../../../../core/components/date_picker/custom_date_range_picker.dart';
import '../../../../../core/components/select/app_company_select_field.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/dimens.dart';

/// 总览页统计模块统一视觉 token。
class OverviewSectionTokens {
  OverviewSectionTokens._();

  static double get cardRadius => AppDimens.dp14;
  static double get metricRadius => AppDimens.dp8;
  static double get cardPadding => AppDimens.dp12;
  static double get sectionGap => AppDimens.dp16;
  static double get contentGap => AppDimens.dp10;
  static double get itemGap => AppDimens.dp8;
  static double get chipHeight => AppDimens.dp36;

  static const Color cardBorder = AppColors.border;
  static const Color cardBackground = AppColors.surface;
  static const Color cardTintBackground = Color(0xFFF7FAFF);
  static const Color mutedBackground = Color(0xFFF4F7FB);
  static const Color metricBackground = Color(0xFFF6F9FD);
  static const Color metricEmphasisBackground = Color(0xFFF1F6FF);
  static const Color metricBorder = Color(0xFFE4EBF5);
  static const Color accent = AppColors.blue700;
  static const Color accentSoft = Color(0xFFE9F1FF);
  static const Color accentSoftBorder = Color(0xFFD7E5FF);
  static const Color successSoft = Color(0xFFF2FBF6);
  static const Color dangerSoft = Color(0xFFFFF5F5);
  static const Color shadow = Color(0x140F2747);
}

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

/// 模块标题栏。
class OverviewSectionHeader extends StatelessWidget {
  const OverviewSectionHeader({
    required this.title,
    this.trailing,
    this.onRefresh,
    this.isRefreshing = false,
    super.key,
  });

  final String title;
  final Widget? trailing;
  final VoidCallback? onRefresh;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: OverviewSectionTitle(title: title)),
        if (trailing != null) ...[
          SizedBox(width: OverviewSectionTokens.itemGap),
          Flexible(child: trailing!),
        ],
        if (onRefresh != null) ...[
          SizedBox(width: OverviewSectionTokens.itemGap),
          OverviewRefreshButton(onTap: onRefresh!, isRefreshing: isRefreshing),
        ],
      ],
    );
  }
}

/// 区块通用间距。
class OverviewSectionSpacing extends StatelessWidget {
  const OverviewSectionSpacing({super.key});

  @override
  Widget build(BuildContext context) =>
      SizedBox(height: OverviewSectionTokens.sectionGap);
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
      borderRadius: BorderRadius.circular(OverviewSectionTokens.metricRadius),
      child: Container(
        height: OverviewSectionTokens.chipHeight,
        padding: EdgeInsets.symmetric(horizontal: AppDimens.dp10),
        decoration: BoxDecoration(
          color: OverviewSectionTokens.mutedBackground,
          borderRadius: BorderRadius.circular(
            OverviewSectionTokens.metricRadius,
          ),
          border: Border.all(color: OverviewSectionTokens.metricBorder),
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
                      ? AppColors.textHint
                      : AppColors.headerSubtitle,
                  fontSize: AppDimens.sp12,
                  fontWeight: FontWeight.w600,
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
                    color: AppColors.textHint,
                  ),
                ),
              ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary,
            ),
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

/// 区块统一卡片容器。
class OverviewCard extends StatelessWidget {
  const OverviewCard({
    required this.child,
    this.padding,
    this.backgroundColor,
    this.showShadow = true,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(OverviewSectionTokens.cardPadding),
      decoration: BoxDecoration(
        color: backgroundColor ?? OverviewSectionTokens.cardBackground,
        borderRadius: BorderRadius.circular(OverviewSectionTokens.cardRadius),
        border: Border.all(color: OverviewSectionTokens.cardBorder),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: OverviewSectionTokens.shadow.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

/// 卡片内统一次级标题。
class OverviewCardTitle extends StatelessWidget {
  const OverviewCardTitle({required this.title, this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.headerTitle,
              fontSize: AppDimens.sp14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: OverviewSectionTokens.itemGap),
          trailing!,
        ],
      ],
    );
  }
}

/// 模块刷新按钮。
class OverviewRefreshButton extends StatefulWidget {
  const OverviewRefreshButton({
    required this.onTap,
    this.isRefreshing = false,
    super.key,
  });

  final VoidCallback onTap;
  final bool isRefreshing;

  @override
  State<OverviewRefreshButton> createState() => _OverviewRefreshButtonState();
}

class _OverviewRefreshButtonState extends State<OverviewRefreshButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didUpdateWidget(covariant OverviewRefreshButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRefreshing && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isRefreshing && _controller.isAnimating) {
      _controller
        ..stop()
        ..reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isRefreshing ? null : widget.onTap,
      borderRadius: BorderRadius.circular(OverviewSectionTokens.metricRadius),
      child: Container(
        width: OverviewSectionTokens.chipHeight,
        height: OverviewSectionTokens.chipHeight,
        decoration: BoxDecoration(
          color: OverviewSectionTokens.mutedBackground,
          borderRadius: BorderRadius.circular(
            OverviewSectionTokens.metricRadius,
          ),
          border: Border.all(color: OverviewSectionTokens.metricBorder),
        ),
        child: Center(
          child: RotationTransition(
            turns: Tween<double>(begin: 0, end: 1).animate(_controller),
            child: Icon(
              Icons.refresh_rounded,
              size: AppDimens.dp18,
              color: widget.isRefreshing
                  ? OverviewSectionTokens.accent
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// 统一指标块。
class OverviewMetricTile extends StatelessWidget {
  const OverviewMetricTile({
    required this.label,
    required this.value,
    this.emphasize = false,
    this.valueColor,
    this.backgroundColor,
    this.borderColor,
    this.leading,
    this.alignment = CrossAxisAlignment.start,
    super.key,
  });

  final String label;
  final String value;
  final bool emphasize;
  final Color? valueColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Widget? leading;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp10,
        vertical: AppDimens.dp10,
      ),
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            (emphasize
                ? OverviewSectionTokens.metricEmphasisBackground
                : OverviewSectionTokens.metricBackground),
        borderRadius: BorderRadius.circular(OverviewSectionTokens.metricRadius),
        border: Border.all(
          color: borderColor ?? OverviewSectionTokens.metricBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(height: OverviewSectionTokens.itemGap),
          ],
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor ?? AppColors.headerTitle,
              fontSize: emphasize ? AppDimens.sp18 : AppDimens.sp16,
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
          SizedBox(height: AppDimens.dp4),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.headerSubtitle,
              fontSize: AppDimens.sp10,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// 标签值信息行。
class OverviewInfoRow extends StatelessWidget {
  const OverviewInfoRow({
    required this.label,
    required this.value,
    this.emphasize = false,
    super.key,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp10,
        vertical: AppDimens.dp8,
      ),
      decoration: BoxDecoration(
        color: emphasize
            ? OverviewSectionTokens.metricEmphasisBackground
            : OverviewSectionTokens.metricBackground,
        borderRadius: BorderRadius.circular(OverviewSectionTokens.metricRadius),
        border: Border.all(color: OverviewSectionTokens.metricBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.headerSubtitle,
                fontSize: AppDimens.sp10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: AppDimens.dp8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.headerTitle,
                fontSize: emphasize ? AppDimens.sp13 : AppDimens.sp12,
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
