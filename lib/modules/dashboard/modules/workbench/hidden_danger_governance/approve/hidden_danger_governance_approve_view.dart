import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/app_form_styles.dart';
import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/components/select/app_user_select_field.dart';
import '../../../../../../core/components/select/custom_picker_photo.dart';
import '../../../../../../core/constants/dimens.dart';
import '../../../../../../core/utils/file_service.dart';
import 'hidden_danger_governance_approve_controller.dart';

/// 隐患治理审批页。
class HiddenDangerGovernanceApproveView extends GetView<HiddenDangerGovernanceApproveController> {
  const HiddenDangerGovernanceApproveView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HiddenDangerGovernanceApproveController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: Text(logic.pageTitle)),
          backgroundColor: const Color(0xFFF4F7FB),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppDimens.dp12),
            child: Column(
              children: [
                _IntroCard(title: logic.pageTitle, desc: _modeDesc(logic.mode)),
                SizedBox(height: AppDimens.dp12),
                AppStandardCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionTitle(text: '隐患信息'),
                      SizedBox(height: AppDimens.dp12),
                      ...logic.buildDetailLines().map((line) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: AppDimens.dp10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: AppDimens.dp92,
                                child: Text(
                                  '${line.label}：',
                                  style: TextStyle(color: const Color(0xFF7B8798), fontSize: AppDimens.sp12),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  line.value,
                                  style: TextStyle(color: const Color(0xFF263547), fontSize: AppDimens.sp12, fontWeight: FontWeight.w600, height: 1.5),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      _PhotoLine(photoUrls: logic.abnormalPhotos),
                    ],
                  ),
                ),
                SizedBox(height: AppDimens.dp12),
                AppStandardCard(
                  child: logic.loading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionTitle(text: _modeTitle(logic.mode)),
                            SizedBox(height: AppDimens.dp12),
                            _ActionForm(logic: logic),
                          ],
                        ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.fromLTRB(AppDimens.dp12, AppDimens.dp10, AppDimens.dp12, AppDimens.dp10),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE7EDF5))),
                boxShadow: [BoxShadow(color: Color(0x0A0F172A), blurRadius: 14, offset: Offset(0, -2))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size.fromHeight(AppDimens.dp44),
                        side: const BorderSide(color: Color(0xFFD7DFEB)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp10)),
                        foregroundColor: const Color(0xFF5C6B7D),
                      ),
                      onPressed: logic.submitting ? null : Get.back,
                      child: const Text('取消'),
                    ),
                  ),
                  SizedBox(width: AppDimens.dp10),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: Size.fromHeight(AppDimens.dp44),
                        backgroundColor: const Color(0xFF3A78F2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp10)),
                        elevation: 0,
                      ),
                      onPressed: logic.submitting ? null : logic.submit,
                      child: logic.submitting ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(logic.submitButtonText),
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

  String _modeTitle(HiddenDangerGovernanceApproveMode mode) {
    switch (mode) {
      case HiddenDangerGovernanceApproveMode.confirm:
        return '确认信息';
      case HiddenDangerGovernanceApproveMode.rectify:
        return '整改信息';
      case HiddenDangerGovernanceApproveMode.verify:
        return '核查信息';
      case HiddenDangerGovernanceApproveMode.reassign:
        return '重新指派';
    }
  }

  String _modeDesc(HiddenDangerGovernanceApproveMode mode) {
    switch (mode) {
      case HiddenDangerGovernanceApproveMode.confirm:
        return '请确认隐患信息，选择责任类型、整改人员与整改期限。';
      case HiddenDangerGovernanceApproveMode.rectify:
        return '请补充整改描述和整改图片，确保整改信息完整可追溯。';
      case HiddenDangerGovernanceApproveMode.verify:
        return '请结合整改记录填写核查结果和核查意见。';
      case HiddenDangerGovernanceApproveMode.reassign:
        return '请重新指定整改人员，并说明重新指派原因。';
    }
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.title, required this.desc});

  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return AppStandardCard(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppDimens.dp12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFF2F8FF), Color(0xFFFAFCFF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(AppDimens.dp10),
          border: Border.all(color: const Color(0xFFD8E6FF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: AppDimens.dp30,
                  height: AppDimens.dp30,
                  decoration: BoxDecoration(color: const Color(0xFFE8F1FF), borderRadius: BorderRadius.circular(AppDimens.dp9)),
                  child: const Icon(Icons.assignment_outlined, size: 18, color: Color(0xFF3A78F2)),
                ),
                SizedBox(width: AppDimens.dp10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(color: const Color(0xFF243447), fontSize: AppDimens.sp13, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimens.dp8),
            Text(
              desc,
              style: TextStyle(color: const Color(0xFF6C7A8C), fontSize: AppDimens.sp12, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoLine extends StatelessWidget {
  const _PhotoLine({required this.photoUrls});

  final List<String> photoUrls;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppDimens.dp92,
          child: Text(
            '现场图片：',
            style: TextStyle(color: const Color(0xFF7B8798), fontSize: AppDimens.sp12),
          ),
        ),
        Expanded(child: _PhotoThumbList(photoUrls: photoUrls)),
      ],
    );
  }
}

class _PhotoThumbList extends StatelessWidget {
  const _PhotoThumbList({required this.photoUrls});

  final List<String> photoUrls;

  @override
  Widget build(BuildContext context) {
    if (photoUrls.isEmpty) {
      return Text(
        '--',
        style: TextStyle(color: const Color(0xFF263547), fontSize: AppDimens.sp12, fontWeight: FontWeight.w600),
      );
    }

    return Wrap(
      spacing: AppDimens.dp8,
      runSpacing: AppDimens.dp8,
      children: photoUrls.map((url) {
        final imageUrl = FileService.getFaceUrl(url);
        return InkWell(
          onTap: imageUrl == null ? null : () => FileService.openFile(imageUrl, title: '现场图片'),
          borderRadius: BorderRadius.circular(AppDimens.dp10),
          child: Container(
            width: AppDimens.dp84,
            height: AppDimens.dp56,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF3F8),
              borderRadius: BorderRadius.circular(AppDimens.dp10),
              border: Border.all(color: const Color(0xFFD6DFEC)),
              boxShadow: const [BoxShadow(color: Color(0x080F172A), blurRadius: 8, offset: Offset(0, 3))],
            ),
            child: imageUrl == null
                ? Icon(Icons.image_outlined, size: 18, color: const Color(0xFF8A9AB1))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.dp10),
                    child: Image.network(
                      imageUrl,
                      headers: FileService.imageHeaders(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image_outlined, size: 18, color: const Color(0xFF8A9AB1)),
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }
}

class _ActionForm extends StatelessWidget {
  const _ActionForm({required this.logic});

  final HiddenDangerGovernanceApproveController logic;

  @override
  Widget build(BuildContext context) {
    switch (logic.mode) {
      case HiddenDangerGovernanceApproveMode.confirm:
        return _ConfirmForm(logic: logic);
      case HiddenDangerGovernanceApproveMode.rectify:
        return _RectifyForm(logic: logic);
      case HiddenDangerGovernanceApproveMode.verify:
        return _VerifyForm(logic: logic);
      case HiddenDangerGovernanceApproveMode.reassign:
        return _ReassignForm(logic: logic);
    }
  }
}

class _ConfirmForm extends StatelessWidget {
  const _ConfirmForm({required this.logic});

  final HiddenDangerGovernanceApproveController logic;
  static final BorderRadius _inputBorderRadius = AppFormStyles.borderRadius;
  static const Color _inputBorderColor = AppFormStyles.borderColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel(text: '核验结果', required: true),
        SizedBox(height: AppDimens.dp8),
        DropdownButtonFormField<String>(
          initialValue: logic.confirmVerifyResult,
          isExpanded: true,
          itemHeight: null,
          borderRadius: AppFormStyles.dropdownBorderRadius,
          dropdownColor: AppFormStyles.dropdownBackgroundColor,
          menuMaxHeight: AppFormStyles.dropdownMenuMaxHeight,
          items: const [
            DropdownMenuItem(value: 'CONFIRMED', child: AppDropdownMenuText('确认')),
            DropdownMenuItem(value: 'REJECTED', child: AppDropdownMenuText('驳回')),
          ],
          selectedItemBuilder: (context) {
            return const [AppDropdownSelectedText('确认'), AppDropdownSelectedText('驳回')];
          },
          onChanged: (value) {
            if (value == null) return;
            logic.confirmVerifyResult = value;
            logic.update();
          },
          decoration: _buildAlignedInputDecoration(),
        ),
        if (logic.confirmVerifyResult == 'CONFIRMED') ...[
          SizedBox(height: AppDimens.dp12),
          const _FieldLabel(text: '责任类型', required: true),
          SizedBox(height: AppDimens.dp8),
          DropdownButtonFormField<String?>(
            initialValue: logic.responsibleType,
            isExpanded: true,
            itemHeight: null,
            borderRadius: AppFormStyles.dropdownBorderRadius,
            dropdownColor: AppFormStyles.dropdownBackgroundColor,
            menuMaxHeight: AppFormStyles.dropdownMenuMaxHeight,
            items: const [
              DropdownMenuItem<String?>(value: 'ENTERPRISE', child: AppDropdownMenuText('企业')),
              DropdownMenuItem<String?>(value: 'PERSONNEL', child: AppDropdownMenuText('个人')),
            ],
            selectedItemBuilder: (context) {
              return const [AppDropdownSelectedText('企业'), AppDropdownSelectedText('个人')];
            },
            onChanged: logic.onResponsibleTypeChanged,
            decoration: _buildAlignedInputDecoration(),
          ),
          SizedBox(height: AppDimens.dp12),
          if (logic.responsibleType == 'ENTERPRISE') _TextInputField(controller: logic.enterpriseNameController, label: '责任对象名称', hintText: '请输入企业/部门名称', required: true),
          if (logic.responsibleType == 'PERSONNEL')
            AppUserSelectField(
              label: '责任对象名称',
              hintText: '请选择责任人员',
              value: logic.selectedResponsibleUser,
              required: true,
              borderRadius: _inputBorderRadius,
              borderColor: _inputBorderColor,
              onChanged: (value) {
                logic.selectedResponsibleUser = value;
                logic.update();
              },
            ),
          SizedBox(height: AppDimens.dp12),
          AppUserSelectField(
            label: '整改人员',
            hintText: '请选择整改人员',
            value: logic.selectedRectifyUser,
            required: true,
            borderRadius: _inputBorderRadius,
            borderColor: _inputBorderColor,
            onChanged: (value) {
              logic.selectedRectifyUser = value;
              logic.update();
            },
          ),
          SizedBox(height: AppDimens.dp12),
          _DateTimeInputField(label: '整改期限', controller: logic.deadlineController, onTap: () => logic.pickDeadline(context)),
        ],
      ],
    );
  }
}

class _RectifyForm extends StatelessWidget {
  const _RectifyForm({required this.logic});

  final HiddenDangerGovernanceApproveController logic;
  static final BorderRadius _inputBorderRadius = AppFormStyles.borderRadius;
  static const Color _inputBorderColor = AppFormStyles.borderColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppUserSelectField(
          label: '整改人员',
          hintText: '请选择整改人员',
          value: logic.selectedRectifyUser,
          required: true,
          borderRadius: _inputBorderRadius,
          borderColor: _inputBorderColor,
          onChanged: (value) {
            logic.selectedRectifyUser = value;
            logic.update();
          },
        ),
        SizedBox(height: AppDimens.dp12),
        _TextInputField(controller: logic.rectifyDescController, label: '整改描述', hintText: '请输入整改描述', required: true, maxLines: 4),
        SizedBox(height: AppDimens.dp12),
        _PhotoUploadField(label: '整改图片', imageIds: logic.photoUrlsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(), onChanged: logic.setPhotoUrls),
      ],
    );
  }
}

class _VerifyForm extends StatelessWidget {
  const _VerifyForm({required this.logic});

  final HiddenDangerGovernanceApproveController logic;

  @override
  Widget build(BuildContext context) {
    final record = logic.latestRectification;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppDimens.dp12),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAFF),
            borderRadius: BorderRadius.circular(AppDimens.dp10),
            border: Border.all(color: const Color(0xFFDCE6F4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoText(label: '整改类型', value: logic.rectifyTypeText(record?.rectifyType)),
              _InfoText(label: '整改人', value: record?.rectifyUserName ?? '--'),
              _InfoText(label: '整改描述', value: record?.rectifyDesc ?? '--'),
              _InfoText(label: '整改时间', value: record?.rectifyTime ?? '--'),
              _InfoText(label: '当前状态', value: logic.rectifyStatusText(record?.status)),
            ],
          ),
        ),
        SizedBox(height: AppDimens.dp12),
        const _FieldLabel(text: '核查结果', required: true),
        SizedBox(height: AppDimens.dp8),
        DropdownButtonFormField<String>(
          initialValue: logic.verifyResult,
          isExpanded: true,
          itemHeight: null,
          borderRadius: AppFormStyles.dropdownBorderRadius,
          dropdownColor: AppFormStyles.dropdownBackgroundColor,
          menuMaxHeight: AppFormStyles.dropdownMenuMaxHeight,
          items: const [
            DropdownMenuItem(value: 'PASS', child: AppDropdownMenuText('通过')),
            DropdownMenuItem(value: 'REJECT', child: AppDropdownMenuText('驳回')),
          ],
          selectedItemBuilder: (context) {
            return const [AppDropdownSelectedText('通过'), AppDropdownSelectedText('驳回')];
          },
          onChanged: (value) {
            if (value == null) return;
            logic.verifyResult = value;
            logic.update();
          },
          decoration: _buildAlignedInputDecoration(),
        ),
        SizedBox(height: AppDimens.dp12),
        _TextInputField(controller: logic.verifyCommentController, label: '核查意见', hintText: '请输入核查意见', maxLines: 4),
      ],
    );
  }
}

class _ReassignForm extends StatelessWidget {
  const _ReassignForm({required this.logic});

  final HiddenDangerGovernanceApproveController logic;
  static final BorderRadius _inputBorderRadius = AppFormStyles.borderRadius;
  static const Color _inputBorderColor = AppFormStyles.borderColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppUserSelectField(
          label: '新整改人员',
          hintText: '请选择新整改人员',
          value: logic.selectedNewRectifyUser,
          required: true,
          borderRadius: _inputBorderRadius,
          borderColor: _inputBorderColor,
          onChanged: (value) {
            logic.selectedNewRectifyUser = value;
            logic.update();
          },
        ),
        SizedBox(height: AppDimens.dp12),
        _TextInputField(controller: logic.reassignReasonController, label: '指派原因', hintText: '请输入重新指派原因', maxLines: 4),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppDimens.dp4,
          height: AppDimens.dp14,
          decoration: BoxDecoration(color: const Color(0xFF3A78F2), borderRadius: BorderRadius.circular(999)),
        ),
        SizedBox(width: AppDimens.dp8),
        Text(
          text,
          style: TextStyle(color: const Color(0xFF223146), fontSize: AppDimens.sp13, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text, this.required = false});

  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (required)
          const Text(
            '* ',
            style: TextStyle(color: Color(0xFFE55E59), fontWeight: FontWeight.w700),
          ),
        Text(
          text,
          style: TextStyle(color: const Color(0xFF2E3B4D), fontSize: AppDimens.sp12, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

const Color _alignedInputTextColor = Color(0xFF2B3A4F);

InputDecoration _buildAlignedInputDecoration({String? hintText, Widget? suffixIcon, bool enabled = true}) {
  return AppFormStyles.inputDecoration(hintText: hintText, suffixIcon: suffixIcon, enabled: enabled);
}

class _TextInputField extends StatelessWidget {
  const _TextInputField({required this.controller, required this.label, required this.hintText, this.required = false, this.maxLines = 1});

  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool required;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(text: label, required: required),
        SizedBox(height: AppDimens.dp8),
        TextField(
          controller: controller,
          minLines: maxLines > 1 ? maxLines : 1,
          maxLines: maxLines,
          style: TextStyle(fontSize: AppDimens.sp13, color: _alignedInputTextColor),
          decoration: _buildAlignedInputDecoration(hintText: hintText),
        ),
      ],
    );
  }
}

class _DateTimeInputField extends StatelessWidget {
  const _DateTimeInputField({required this.label, required this.controller, required this.onTap});

  final String label;
  final TextEditingController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(text: label, required: true),
        SizedBox(height: AppDimens.dp8),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          style: TextStyle(fontSize: AppDimens.sp13, color: _alignedInputTextColor),
          decoration: _buildAlignedInputDecoration(
            hintText: '请选择日期时间',
            suffixIcon: const Icon(Icons.schedule_rounded, color: Color(0xFF7E8EA4)),
          ),
        ),
      ],
    );
  }
}

class _PhotoUploadField extends StatelessWidget {
  const _PhotoUploadField({required this.label, required this.imageIds, required this.onChanged});

  final String label;
  final List<String> imageIds;
  final ValueChanged<List<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(text: label),
        SizedBox(height: AppDimens.dp8),
        CustomPickerPhoto(title: '上传图片', isShowTitle: false, maxCount: 3, imagesList: imageIds, callback: onChanged),
      ],
    );
  }
}

class _InfoText extends StatelessWidget {
  const _InfoText({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimens.dp8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppDimens.dp80,
            child: Text(
              '$label：',
              style: TextStyle(color: const Color(0xFF7B8798), fontSize: AppDimens.sp12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: const Color(0xFF263547), fontSize: AppDimens.sp12, fontWeight: FontWeight.w600, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
