import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/dimens.dart';
import '../modules/logistics_query/logistics_query_statistics_section.dart';
import '../modules/overview/dashboard_statistics_section.dart';
import '../modules/personnel_query/personnel_query_statistics_section.dart';
import '../modules/vehicle_query/vehicle_query_statistics_section.dart';
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
                        children: const [
                          _WorkbenchPane(),
                          _VehicleQueryPane(),
                          _PersonnelQueryPane(),
                          _LogisticsQueryPane(),
                          _OverviewPane(),
                        ],
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
      width: AppDimens.dp48,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp0,
        vertical: AppDimens.dp8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp18),
        border: Border.all(color: const Color(0xFFE1EAF5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F2A4A),
            blurRadius: 16,
            offset: Offset(0, 8),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.dp14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.fromLTRB(
            AppDimens.dp0,
            AppDimens.dp4,
            AppDimens.dp0,
            AppDimens.dp4,
          ),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEEF5FF) : const Color(0xFFF8FBFF),
            borderRadius: BorderRadius.circular(AppDimens.dp14),
            border: Border.all(
              color: selected
                  ? const Color(0xFFBFD7FA)
                  : const Color(0xFFE3ECF8),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: AppDimens.dp18,
                height: AppDimens.dp3,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF2267C0)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              SizedBox(height: AppDimens.dp3),
              Container(
                width: AppDimens.dp26,
                height: AppDimens.dp26,
                decoration: BoxDecoration(
                  color: selected
                      ? item.color.withValues(alpha: 0.12)
                      : item.color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppDimens.dp9),
                ),
                child: Icon(
                  item.icon,
                  color: selected ? const Color(0xFF2267C0) : item.color,
                  size: AppDimens.sp14,
                ),
              ),
              SizedBox(height: AppDimens.dp2),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected
                      ? const Color(0xFF2267C0)
                      : const Color(0xFF6D86A2),
                  fontSize: AppDimens.sp10,
                  fontWeight: FontWeight.w600,
                  height: 1.05,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
              AppDimens.dp18,
              AppDimens.dp18,
              AppDimens.dp18,
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
          AppDimens.dp16,
          AppDimens.dp16,
          AppDimens.dp16,
          AppDimens.dp24,
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
          AppDimens.dp16,
          AppDimens.dp16,
          AppDimens.dp16,
          AppDimens.dp24,
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
          AppDimens.dp16,
          AppDimens.dp16,
          AppDimens.dp16,
          AppDimens.dp12,
        ),
        child: Column(children: [Expanded(child: child)]),
      ),
    );
  }
}
