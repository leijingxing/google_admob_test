import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/constants/dimens.dart';
import 'appeal_reply_handle_controller.dart';

/// 申诉回复处理页。
class AppealReplyHandleView extends GetView<AppealReplyHandleController> {
  const AppealReplyHandleView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppealReplyHandleController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('回复申诉')),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppDimens.dp12),
            child: Column(
              children: [
                AppStandardCard(
                  child: Column(
                    children: logic.buildDetailLines().map((line) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: AppDimens.dp10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: AppDimens.dp92,
                              child: Text(
                                '${line.label}：',
                                style: TextStyle(
                                  color: const Color(0xFF7B8798),
                                  fontSize: AppDimens.sp12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                line.value,
                                style: TextStyle(
                                  color: const Color(0xFF263547),
                                  fontSize: AppDimens.sp12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: AppDimens.dp12),
                AppStandardCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('处理结果', required: true),
                      SizedBox(height: AppDimens.dp8),
                      Row(
                        children: [
                          Expanded(
                            child: _ResultOptionCard(
                              title: '通过',
                              subtitle: '申诉内容成立，流程继续',
                              icon: Icons.check_circle_outline_rounded,
                              selected: logic.selectedStatus == 1,
                              activeColor: const Color(0xFF1C9B63),
                              onTap: () => logic.onStatusChanged(1),
                            ),
                          ),
                          SizedBox(width: AppDimens.dp10),
                          Expanded(
                            child: _ResultOptionCard(
                              title: '不通过',
                              subtitle: '申诉内容不成立，维持原结果',
                              icon: Icons.cancel_outlined,
                              selected: logic.selectedStatus == 2,
                              activeColor: const Color(0xFFE07A34),
                              onTap: () => logic.onStatusChanged(2),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimens.dp12),
                      _fieldLabel('回复描述', required: true),
                      SizedBox(height: AppDimens.dp8),
                      TextField(
                        controller: logic.replyController,
                        minLines: 4,
                        maxLines: 6,
                        maxLength: 300,
                        decoration: InputDecoration(
                          hintText: '请输入回复描述',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFD),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimens.dp10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD7DFEB),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimens.dp10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD7DFEB),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimens.dp10),
                            borderSide: const BorderSide(
                              color: Color(0xFF1F7BFF),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimens.dp12,
                AppDimens.dp8,
                AppDimens.dp12,
                AppDimens.dp8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: logic.submitting ? null : Get.back,
                      child: const Text('取消'),
                    ),
                  ),
                  SizedBox(width: AppDimens.dp8),
                  Expanded(
                    child: FilledButton(
                      onPressed: logic.submitting ? null : logic.submit,
                      child: logic.submitting
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('提交'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _fieldLabel(String text, {bool required = false}) {
    return Row(
      children: [
        if (required)
          const Text(
            '* ',
            style: TextStyle(
              color: Color(0xFFE55E59),
              fontWeight: FontWeight.w700,
            ),
          ),
        Text(
          text,
          style: TextStyle(
            color: const Color(0xFF2E3B4D),
            fontSize: AppDimens.sp12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ResultOptionCard extends StatelessWidget {
  const _ResultOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.activeColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final Color activeColor;
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
          curve: Curves.easeOut,
          height: 132,
          padding: EdgeInsets.all(AppDimens.dp12),
          decoration: BoxDecoration(
            color: selected
                ? activeColor.withValues(alpha: 0.08)
                : const Color(0xFFF8FAFD),
            borderRadius: BorderRadius.circular(AppDimens.dp14),
            border: Border.all(
              color: selected
                  ? activeColor.withValues(alpha: 0.75)
                  : const Color(0xFFDDE4EE),
              width: selected ? 1.4 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: AppDimens.dp34,
                    height: AppDimens.dp34,
                    decoration: BoxDecoration(
                      color: selected
                          ? activeColor.withValues(alpha: 0.16)
                          : const Color(0xFFEFF3F8),
                      borderRadius: BorderRadius.circular(AppDimens.dp10),
                    ),
                    child: Icon(
                      icon,
                      color: selected ? activeColor : const Color(0xFF7E8DA0),
                      size: 18,
                    ),
                  ),
                  const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: AppDimens.dp18,
                    height: AppDimens.dp18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? activeColor : Colors.transparent,
                      border: Border.all(
                        color: selected ? activeColor : const Color(0xFFC9D3E0),
                        width: 1.5,
                      ),
                    ),
                    child: selected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 12,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              ),
              SizedBox(height: AppDimens.dp12),
              Text(
                title,
                style: TextStyle(
                  color: selected ? activeColor : const Color(0xFF24364A),
                  fontSize: AppDimens.sp14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppDimens.dp4),
              Expanded(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: const Color(0xFF708093),
                    fontSize: AppDimens.sp11,
                    height: 1.4,
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
