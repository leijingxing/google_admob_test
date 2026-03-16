import 'package:flutter/material.dart';

import '../../../data/models/auth/company_base_info_model.dart';
import '../../../data/repository/auth_repository.dart';
import '../../constants/dimens.dart';
import '../app_form_styles.dart';
import '../app_standard_card.dart';
import '../toast/toast_widget.dart';

/// 统一企业选择结果。
class AppSelectedCompany {
  /// 企业 ID。
  final String id;

  /// 企业编码。
  final String companyCode;

  /// 企业名称。
  final String companyName;

  const AppSelectedCompany({
    required this.id,
    required this.companyCode,
    required this.companyName,
  });

  /// 从企业基础信息模型中提取选择结果。
  factory AppSelectedCompany.fromCompanyBaseInfo(CompanyBaseInfoModel model) {
    return AppSelectedCompany(
      id: (model.id ?? '').trim(),
      companyCode: (model.companyCode ?? '').trim(),
      companyName: (model.companyName ?? '').trim(),
    );
  }

  /// 展示名称。
  String get displayName {
    if (companyName.isNotEmpty) return companyName;
    if (companyCode.isNotEmpty) return companyCode;
    return id;
  }
}

/// 统一企业选择表单项（单选）。
class AppCompanySelectField extends StatelessWidget {
  const AppCompanySelectField({
    super.key,
    required this.label,
    required this.hintText,
    required this.value,
    required this.onChanged,
    this.required = false,
    this.enabled = true,
    this.clearable = true,
    this.borderRadius,
    this.borderColor,
    this.dialogTitle = '选择企业',
  });

  final String label;
  final String hintText;
  final AppSelectedCompany? value;
  final ValueChanged<AppSelectedCompany?> onChanged;
  final bool required;
  final bool enabled;
  final bool clearable;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final String dialogTitle;

  @override
  Widget build(BuildContext context) {
    final selected = value;
    final hasValue = selected != null;
    final resolvedBorderRadius = borderRadius ?? AppFormStyles.borderRadius;
    final resolvedBorderColor = borderColor ?? AppFormStyles.borderColor;
    final backgroundColor = enabled
        ? AppFormStyles.fillColor
        : AppFormStyles.disabledFillColor;
    final titleColor = enabled
        ? const Color(0xFF2E3B4D)
        : AppFormStyles.disabledTextColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
              label,
              style: TextStyle(
                color: titleColor,
                fontSize: AppDimens.sp12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimens.dp8),
        InkWell(
          onTap: enabled
              ? () async {
                  final selectedCompany = await showAppCompanySelectDialog(
                    context,
                    title: dialogTitle,
                    initialValue: value,
                  );
                  if (selectedCompany != null) {
                    onChanged(selectedCompany);
                  }
                }
              : null,
          borderRadius: resolvedBorderRadius,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.dp12,
              vertical: AppDimens.dp12,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: resolvedBorderRadius,
              border: Border.all(color: resolvedBorderColor),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.apartment_rounded,
                  size: AppDimens.dp18,
                  color: const Color(0xFF7B8798),
                ),
                SizedBox(width: AppDimens.dp8),
                Expanded(
                  child: Text(
                    hasValue ? selected.displayName : hintText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppDimens.sp12,
                      color: hasValue
                          ? const Color(0xFF223146)
                          : AppFormStyles.hintColor,
                      fontWeight: hasValue ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                if (hasValue && clearable && enabled)
                  GestureDetector(
                    onTap: () => onChanged(null),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.only(right: AppDimens.dp6),
                      child: Icon(
                        Icons.close_rounded,
                        size: AppDimens.dp16,
                        color: const Color(0xFF90A0B3),
                      ),
                    ),
                  ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: AppDimens.dp18,
                  color: const Color(0xFF7E8EA4),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 打开统一企业选择弹窗。
Future<AppSelectedCompany?> showAppCompanySelectDialog(
  BuildContext context, {
  AppSelectedCompany? initialValue,
  String title = '选择企业',
}) {
  return Navigator.of(context).push<AppSelectedCompany>(
    MaterialPageRoute<AppSelectedCompany>(
      builder: (_) =>
          _AppCompanySelectPage(title: title, initialValue: initialValue),
    ),
  );
}

/// 企业选择弹窗页面。
class _AppCompanySelectPage extends StatefulWidget {
  const _AppCompanySelectPage({required this.title, this.initialValue});

  final String title;
  final AppSelectedCompany? initialValue;

  @override
  State<_AppCompanySelectPage> createState() => _AppCompanySelectPageState();
}

class _AppCompanySelectPageState extends State<_AppCompanySelectPage> {
  final AuthRepository _repository = AuthRepository();
  final TextEditingController _companyNameController = TextEditingController();

  bool _loading = false;
  List<CompanyBaseInfoModel> _items = const <CompanyBaseInfoModel>[];
  AppSelectedCompany? _selectedCompany;

  @override
  void initState() {
    super.initState();
    _selectedCompany = widget.initialValue;
    _loadCompanies();
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    super.dispose();
  }

  /// 加载企业列表。
  ///
  /// 按当前约定固定拉取前 10000 条，仅支持企业名称筛选。
  Future<void> _loadCompanies() async {
    setState(() {
      _loading = true;
    });

    final result = await _repository.getCompanyBaseInfoPage(
      pageIndex: 1,
      pageSize: 10000,
      companyName: _companyNameController.text.trim(),
    );

    if (!mounted) return;
    result.when(
      success: (page) {
        setState(() {
          _items = page.items;
          _loading = false;
        });
      },
      failure: (error) {
        AppToast.showError(error.message);
        setState(() {
          _items = const <CompanyBaseInfoModel>[];
          _loading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      backgroundColor: const Color(0xFFF6F8FC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppDimens.dp12,
            AppDimens.dp10,
            AppDimens.dp12,
            AppDimens.dp12,
          ),
          child: Column(
            children: [
              AppStandardCard(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _companyNameController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _loadCompanies(),
                        decoration: AppFormStyles.editableInputDecoration(
                          hintText: '请输入企业名称',
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 18,
                            color: Color(0xFF7B8798),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimens.dp10),
                    FilledButton(
                      onPressed: _loadCompanies,
                      child: const Text('查询'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimens.dp10),
              Expanded(child: AppStandardCard(child: _buildCompanyList())),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(
            AppDimens.dp12,
            AppDimens.dp10,
            AppDimens.dp12,
            AppDimens.dp10,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE7EDF5))),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('取消'),
                ),
              ),
              SizedBox(width: AppDimens.dp10),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    final selected = _selectedCompany;
                    if (selected == null) {
                      AppToast.showWarning('请选择企业');
                      return;
                    }
                    Navigator.of(context).pop(selected);
                  },
                  child: const Text('确定'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建企业列表。
  Widget _buildCompanyList() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_items.isEmpty) {
      return const _CompanyEmptyState();
    }

    return ListView.separated(
      itemCount: _items.length,
      separatorBuilder: (_, index) => SizedBox(height: AppDimens.dp8),
      itemBuilder: (context, index) {
        final row = _items[index];
        final company = AppSelectedCompany.fromCompanyBaseInfo(row);
        final selected = _selectedCompany?.id == company.id;

        return InkWell(
          onTap: company.id.isEmpty
              ? null
              : () {
                  setState(() {
                    _selectedCompany = company;
                  });
                },
          borderRadius: BorderRadius.circular(AppDimens.dp12),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.dp12,
              vertical: AppDimens.dp12,
            ),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFEAF1FF) : Colors.white,
              borderRadius: BorderRadius.circular(AppDimens.dp12),
              border: Border.all(
                color: selected
                    ? const Color(0xFF3A78F2)
                    : const Color(0xFFDCE3EE),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    company.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppDimens.sp13,
                      color: const Color(0xFF223146),
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: AppDimens.dp8),
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: AppDimens.dp18,
                  color: selected
                      ? const Color(0xFF3A78F2)
                      : const Color(0xFF9AA7B8),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 企业列表为空时的占位视图。
class _CompanyEmptyState extends StatelessWidget {
  const _CompanyEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '暂无企业数据',
        style: TextStyle(
          fontSize: AppDimens.sp12,
          color: const Color(0xFF8A97A8),
        ),
      ),
    );
  }
}
