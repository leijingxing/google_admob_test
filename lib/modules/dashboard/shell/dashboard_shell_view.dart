import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/dimens.dart';
import '../modules/logistics_query/logistics_query_binding.dart';
import '../modules/logistics_query/logistics_query_statistics_section.dart';
import '../modules/overview/dashboard_statistics_section.dart';
import '../modules/overview/overview_binding.dart';
import '../modules/personnel_query/personnel_query_binding.dart';
import '../modules/personnel_query/personnel_query_statistics_section.dart';
import '../modules/vehicle_query/vehicle_query_binding.dart';
import '../modules/vehicle_query/vehicle_query_statistics_section.dart';
import '../modules/workbench/workbench_binding.dart';
import '../modules/workbench/workbench_content_section.dart';
import 'dashboard_shell_controller.dart';

/// Dashboard 封闭化页面。
class DashboardShellView extends GetView<DashboardShellController> {
  const DashboardShellView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardShellController>(
      builder: (logic) {
        return Scaffold(
          backgroundColor: const Color(0xFFF3F7FC),
          appBar: AppBar(
            title: const Text('业务中心'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          body: SafeArea(
            top: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Sidebar(
                  items: logic.modules,
                  currentIndex: logic.currentIndex,
                  onTap: logic.switchModule,
                ),
                Expanded(
                  child: _ContentPanel(
                    title: logic.currentModule.title,
                    subtitle: logic.currentModule.subtitle,
                    color: logic.currentModule.color,
                    child: IndexedStack(
                      index: logic.currentIndex,
                      children: List<Widget>.generate(logic.modules.length, (
                        index,
                      ) {
                        if (!logic.isModuleLoaded(index)) {
                          return const SizedBox.shrink();
                        }
                        return _buildModulePane(index);
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModulePane(int index) {
    _ensureModuleBinding(index);
    switch (index) {
      case 0:
        return const _WorkbenchPane();
      case 1:
        return const _OverviewPane();
      case 2:
        return const _VehicleQueryPane();
      case 3:
        return const _PersonnelQueryPane();
      case 4:
        return const _LogisticsQueryPane();
      default:
        return const SizedBox.shrink();
    }
  }

  void _ensureModuleBinding(int index) {
    switch (index) {
      case 0:
        WorkbenchBinding().dependencies();
        break;
      case 1:
        OverviewBinding().dependencies();
        break;
      case 2:
        VehicleQueryBinding().dependencies();
        break;
      case 3:
        PersonnelQueryBinding().dependencies();
        break;
      case 4:
        LogisticsQueryBinding().dependencies();
        break;
    }
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<DashboardShellModuleItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DashboardShellController.sidebarWidth,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp4,
        vertical: AppDimens.dp10,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFCFDFF), Color(0xFFF2F6FC)],
        ),
        borderRadius: BorderRadius.circular(AppDimens.dp20),
        border: Border.all(color: const Color(0xFFDDE7F3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F2A4A),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final selected = index == currentIndex;
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppDimens.dp3),
                    child: _SidebarItem(
                      item: item,
                      selected: selected,
                      onTap: () => onTap(index),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final DashboardShellModuleItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color accentEnd =
        Color.lerp(item.color, const Color(0xFF7C4DFF), 0.22) ?? item.color;
    final Color iconSurface = selected
        ? Colors.white.withValues(alpha: 0.20)
        : item.color.withValues(alpha: 0.10);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.dp14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: DashboardShellController.sidebarItemHeight,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.dp3,
            vertical: AppDimens.dp5,
          ),
          decoration: BoxDecoration(
            gradient: selected
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [item.color, accentEnd],
                  )
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFF8FAFD), Color(0xFFF1F5FA)],
                  ),
            borderRadius: BorderRadius.circular(AppDimens.dp14),
            border: Border.all(
              color: selected
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFE3EAF4),
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: item.color.withValues(alpha: 0.22),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: DashboardShellController.sidebarItemIconBoxSize,
                height: DashboardShellController.sidebarItemIconBoxSize,
                decoration: BoxDecoration(
                  color: iconSurface,
                  borderRadius: BorderRadius.circular(AppDimens.dp12),
                  border: Border.all(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.14)
                        : item.color.withValues(alpha: 0.12),
                  ),
                ),
                child: Icon(
                  item.icon,
                  color: selected ? Colors.white : item.color,
                  size: DashboardShellController.sidebarItemIconSize,
                ),
              ),
              SizedBox(height: AppDimens.dp5),
              SizedBox(
                width: double.infinity,
                child: Text(
                  _formatSidebarLabel(item.title),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF5E728C),
                    fontSize: AppDimens.sp8,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatSidebarLabel(String title) {
  if (title.runes.length <= 2) return title;
  final int splitIndex = (title.runes.length / 2).ceil();
  final List<int> runes = title.runes.toList();
  final String firstLine = String.fromCharCodes(runes.take(splitIndex));
  final String secondLine = String.fromCharCodes(runes.skip(splitIndex));
  return '$firstLine\n$secondLine';
}

class _ContentPanel extends StatelessWidget {
  const _ContentPanel({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp24),
        border: Border.all(color: const Color(0xFFE1EAF5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F103A6F),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
              AppDimens.dp14,
              AppDimens.dp14,
              AppDimens.dp14,
              AppDimens.dp14,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.12),
                  const Color(0xFFF8FBFF),
                ],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimens.dp24),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppDimens.sp18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppDimens.dp4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppDimens.sp12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.dp10,
                    vertical: AppDimens.dp6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '左侧切换',
                    style: TextStyle(
                      color: color,
                      fontSize: AppDimens.sp11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _WorkbenchPane extends StatelessWidget {
  const _WorkbenchPane();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF3F8FF), Color(0xFFEAF2FF)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppDimens.dp12,
          AppDimens.dp12,
          AppDimens.dp12,
          AppDimens.dp16,
        ),
        child: const WorkbenchContentSection(),
      ),
    );
  }
}

class _VehicleQueryPane extends StatelessWidget {
  const _VehicleQueryPane();

  @override
  Widget build(BuildContext context) {
    return _SectionPane(child: const VehicleQueryStatisticsSection());
  }
}

class _PersonnelQueryPane extends StatelessWidget {
  const _PersonnelQueryPane();

  @override
  Widget build(BuildContext context) {
    return _SectionPane(child: const PersonnelQueryStatisticsSection());
  }
}

class _LogisticsQueryPane extends StatelessWidget {
  const _LogisticsQueryPane();

  @override
  Widget build(BuildContext context) {
    return _SectionPane(child: const LogisticsQueryStatisticsSection());
  }
}

class _OverviewPane extends StatelessWidget {
  const _OverviewPane();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF3F8FF), Color(0xFFEAF2FF)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppDimens.dp12,
          AppDimens.dp12,
          AppDimens.dp12,
          AppDimens.dp16,
        ),
        child: const DashboardStatisticsSection(),
      ),
    );
  }
}

class _SectionPane extends StatelessWidget {
  const _SectionPane({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF3F8FF), Color(0xFFEAF2FF)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppDimens.dp12,
          AppDimens.dp12,
          AppDimens.dp12,
          AppDimens.dp16,
        ),
        child: Column(children: [Expanded(child: child)]),
      ),
    );
  }
}
