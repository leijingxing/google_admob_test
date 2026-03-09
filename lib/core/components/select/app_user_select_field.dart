import 'package:flutter/material.dart';

import '../../../data/models/workbench/system_department_tree_model.dart';
import '../../../data/models/workbench/system_post_item_model.dart';
import '../../../data/models/workbench/system_user_item_model.dart';
import '../../../data/repository/workbench_repository.dart';
import '../../components/app_form_styles.dart';
import '../../components/app_standard_card.dart';
import '../../constants/dimens.dart';
import '../toast/toast_widget.dart';

/// 统一人员选择结果。
class AppSelectedUser {
  final String id;
  final String name;
  final String postName;
  final String phone;
  final String companyName;

  const AppSelectedUser({required this.id, required this.name, this.postName = '', this.phone = '', this.companyName = ''});

  factory AppSelectedUser.fromSystemUser(SystemUserItemModel model) {
    return AppSelectedUser(
      id: (model.id ?? '').trim(),
      name: (model.userName ?? '').trim(),
      postName: (model.postName ?? '').trim(),
      phone: (model.phone ?? '').trim(),
      companyName: (model.companyName ?? '').trim(),
    );
  }

  String get displayName => name.isEmpty ? id : name;
}

/// 统一人员选择表单项（单选）。
class AppUserSelectField extends StatelessWidget {
  const AppUserSelectField({
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
  });

  final String label;
  final String hintText;
  final AppSelectedUser? value;
  final ValueChanged<AppSelectedUser?> onChanged;
  final bool required;
  final bool enabled;
  final bool clearable;
  final BorderRadius? borderRadius;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final selected = value;
    final hasValue = selected != null;
    final resolvedBorderRadius = borderRadius ?? AppFormStyles.borderRadius;
    final resolvedBorderColor = borderColor ?? AppFormStyles.borderColor;
    final backgroundColor = enabled ? AppFormStyles.fillColor : AppFormStyles.disabledFillColor;
    final titleColor = enabled ? const Color(0xFF2E3B4D) : AppFormStyles.disabledTextColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (required)
              const Text(
                '* ',
                style: TextStyle(color: Color(0xFFE55E59), fontWeight: FontWeight.w700),
              ),
            Text(
              label,
              style: TextStyle(color: titleColor, fontSize: AppDimens.sp12, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        SizedBox(height: AppDimens.dp8),
        InkWell(
          onTap: enabled
              ? () async {
                  final selectedUser = await showAppUserSelectDialog(context, initialValue: value);
                  if (selectedUser != null) {
                    onChanged(selectedUser);
                  }
                }
              : null,
          borderRadius: resolvedBorderRadius,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: AppDimens.dp12, vertical: AppDimens.dp12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: resolvedBorderRadius,
              border: Border.all(color: resolvedBorderColor),
              boxShadow: enabled ? const [BoxShadow(color: Color(0x080F172A), blurRadius: 10, offset: Offset(0, 4))] : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: AppDimens.dp30,
                  height: AppDimens.dp30,
                  decoration: BoxDecoration(color: enabled ? const Color(0xFFF2F6FD) : const Color(0xFFE9EEF5), borderRadius: BorderRadius.circular(AppDimens.dp9)),
                  child: Icon(Icons.person_search_rounded, size: 18, color: enabled ? const Color(0xFF5A6C84) : const Color(0xFF98A5B5)),
                ),
                SizedBox(width: AppDimens.dp10),
                Expanded(
                  child: hasValue
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    selected.displayName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: AppDimens.sp13, color: enabled ? const Color(0xFF223146) : AppFormStyles.disabledTextColor, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                if (selected.companyName.isNotEmpty) ...[SizedBox(width: AppDimens.dp6), _MetaTag(text: '已选择', enabled: enabled)],
                              ],
                            ),
                            if (selected.postName.isNotEmpty || selected.phone.isNotEmpty || selected.companyName.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: AppDimens.dp4),
                                child: Text(
                                  _buildSubLine(selected),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: AppDimens.sp11, color: enabled ? const Color(0xFF8A97A8) : AppFormStyles.disabledHintColor, height: 1.45),
                                ),
                              ),
                          ],
                        )
                      : Text(
                          hintText,
                          style: TextStyle(fontSize: AppDimens.sp12, color: enabled ? AppFormStyles.hintColor : AppFormStyles.disabledHintColor, fontWeight: FontWeight.w500),
                        ),
                ),
                if (hasValue && clearable && enabled)
                  GestureDetector(
                    onTap: () => onChanged(null),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: AppDimens.dp24,
                      height: AppDimens.dp24,
                      margin: EdgeInsets.only(right: AppDimens.dp8),
                      decoration: BoxDecoration(color: const Color(0xFFF2F5FA), borderRadius: BorderRadius.circular(AppDimens.dp12)),
                      child: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF90A0B3)),
                    ),
                  ),
                Container(
                  width: AppDimens.dp24,
                  height: AppDimens.dp24,
                  decoration: BoxDecoration(color: enabled ? const Color(0xFFF2F5FA) : const Color(0xFFE9EEF5), borderRadius: BorderRadius.circular(AppDimens.dp12)),
                  child: Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: enabled ? const Color(0xFF7E8EA4) : const Color(0xFFB7C0CE)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _buildSubLine(AppSelectedUser selected) {
    final parts = <String>[];
    if (selected.postName.isNotEmpty) {
      parts.add('岗位：${selected.postName}');
    }
    if (selected.phone.isNotEmpty) {
      parts.add('电话：${selected.phone}');
    }
    if (selected.companyName.isNotEmpty) {
      parts.add('单位：${selected.companyName}');
    }
    return parts.join('  ');
  }
}

class _MetaTag extends StatelessWidget {
  const _MetaTag({required this.text, required this.enabled});

  final String text;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp8, vertical: AppDimens.dp3),
      decoration: BoxDecoration(color: enabled ? const Color(0xFFE9F1FF) : const Color(0xFFEAEFF5), borderRadius: BorderRadius.circular(999)),
      child: Text(
        text,
        style: TextStyle(color: enabled ? const Color(0xFF3A78F2) : const Color(0xFF8FA0B4), fontSize: AppDimens.sp10, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// 打开统一人员选择弹窗。
Future<AppSelectedUser?> showAppUserSelectDialog(BuildContext context, {AppSelectedUser? initialValue, String title = '选择人员'}) {
  return Navigator.of(context).push<AppSelectedUser>(
    MaterialPageRoute<AppSelectedUser>(
      builder: (_) => _AppUserSelectPage(title: title, initialValue: initialValue),
    ),
  );
}

enum _UserTreeType { organization, role }

class _AppUserSelectPage extends StatefulWidget {
  const _AppUserSelectPage({required this.title, this.initialValue});

  final String title;
  final AppSelectedUser? initialValue;

  @override
  State<_AppUserSelectPage> createState() => _AppUserSelectPageState();
}

class _AppUserSelectPageState extends State<_AppUserSelectPage> {
  static const String _allOptionValue = '__all__';

  final WorkbenchRepository _repository = WorkbenchRepository();
  final TextEditingController _keywordController = TextEditingController();

  _UserTreeType _treeType = _UserTreeType.organization;

  bool _loadingFilter = false;
  bool _loadingUsers = false;

  List<_FilterOption> _departmentOptions = const <_FilterOption>[];
  String _selectedDepartmentId = _allOptionValue;

  List<SystemPostItemModel> _posts = const <SystemPostItemModel>[];
  String _selectedPostId = _allOptionValue;

  List<SystemUserItemModel> _users = const <SystemUserItemModel>[];

  AppSelectedUser? _selectedUser;

  @override
  void initState() {
    super.initState();
    _selectedUser = widget.initialValue;
    _initData();
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    setState(() {
      _loadingFilter = true;
    });

    await Future.wait<void>([_loadDepartmentTree(), _loadPostList()]);

    if (!mounted) return;
    setState(() {
      _loadingFilter = false;
    });
    await _loadUsers();
  }

  Future<void> _loadDepartmentTree() async {
    final result = await _repository.getSystemDepartmentTree();
    result.when(
      success: (list) {
        final options = <_FilterOption>[const _FilterOption(value: _allOptionValue, label: '全部部门')];
        for (final node in list) {
          options.addAll(_flattenDepartments(node, depth: 0));
        }
        _departmentOptions = options;
      },
      failure: (error) {
        AppToast.showError(error.message);
        _departmentOptions = const <_FilterOption>[_FilterOption(value: _allOptionValue, label: '全部部门')];
      },
    );
  }

  Future<void> _loadPostList() async {
    final result = await _repository.getSystemPostList();
    result.when(
      success: (list) {
        _posts = list;
      },
      failure: (error) {
        AppToast.showError(error.message);
        _posts = const <SystemPostItemModel>[];
      },
    );
  }

  List<_FilterOption> _flattenDepartments(SystemDepartmentTreeModel node, {required int depth}) {
    final id = (node.id ?? '').trim();
    if (id.isEmpty) return const <_FilterOption>[];

    final name = (node.departmentName ?? '').trim();
    final prefix = List<String>.filled(depth, '  ').join();
    final label = name.isEmpty ? id : '$prefix$name';

    final options = <_FilterOption>[_FilterOption(value: id, label: label)];

    for (final child in node.children) {
      options.addAll(_flattenDepartments(child, depth: depth + 1));
    }
    return options;
  }

  Future<void> _loadUsers() async {
    setState(() {
      _loadingUsers = true;
    });

    final keyword = _keywordController.text.trim();
    final departmentId = _treeType == _UserTreeType.organization ? _normalizeAllValue(_selectedDepartmentId) : null;
    final postId = _treeType == _UserTreeType.role ? _normalizeAllValue(_selectedPostId) : null;

    final result = await _repository.getSystemUserPage(current: 1, size: 1000, keywords: keyword.isEmpty ? null : keyword, departmentId: departmentId, postId: postId);

    if (!mounted) return;
    result.when(
      success: (page) {
        setState(() {
          _users = page.items;
          _loadingUsers = false;
        });
      },
      failure: (error) {
        AppToast.showError(error.message);
        setState(() {
          _users = const <SystemUserItemModel>[];
          _loadingUsers = false;
        });
      },
    );
  }

  String? _normalizeAllValue(String? value) {
    if (value == null || value == _allOptionValue) return null;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      backgroundColor: const Color(0xFFF6F8FC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(AppDimens.dp12, AppDimens.dp10, AppDimens.dp12, AppDimens.dp12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTypeSwitcher(),
              SizedBox(height: AppDimens.dp10),
              AppStandardCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SelectSectionTitle(text: '筛选条件'),
                    SizedBox(height: AppDimens.dp12),
                    _buildFilterPanel(),
                    SizedBox(height: AppDimens.dp10),
                    _buildSearchBar(),
                  ],
                ),
              ),
              SizedBox(height: AppDimens.dp10),
              Expanded(
                child: AppStandardCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SelectSectionTitle(text: '人员列表', suffix: '${_users.length}人'),
                      SizedBox(height: AppDimens.dp12),
                      Expanded(child: _buildUserList()),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                  onPressed: () => Navigator.of(context).pop(),
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
                  onPressed: () {
                    final selected = _selectedUser;
                    if (selected == null) {
                      AppToast.showWarning('请选择人员');
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

  Widget _buildTypeSwitcher() {
    return Row(
      children: [
        Expanded(
          child: FilledButton.tonal(
            onPressed: () {
              if (_treeType == _UserTreeType.role) return;
              setState(() {
                _treeType = _UserTreeType.role;
              });
              _loadUsers();
            },
            style: FilledButton.styleFrom(
              backgroundColor: _treeType == _UserTreeType.role ? const Color(0xFF3A78F2) : const Color(0xFFEFF3FA),
              foregroundColor: _treeType == _UserTreeType.role ? Colors.white : const Color(0xFF4A5A70),
              padding: EdgeInsets.symmetric(vertical: AppDimens.dp12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp12)),
            ),
            child: const Text('按岗位'),
          ),
        ),
        SizedBox(width: AppDimens.dp8),
        Expanded(
          child: FilledButton.tonal(
            onPressed: () {
              if (_treeType == _UserTreeType.organization) return;
              setState(() {
                _treeType = _UserTreeType.organization;
              });
              _loadUsers();
            },
            style: FilledButton.styleFrom(
              backgroundColor: _treeType == _UserTreeType.organization ? const Color(0xFF3A78F2) : const Color(0xFFEFF3FA),
              foregroundColor: _treeType == _UserTreeType.organization ? Colors.white : const Color(0xFF4A5A70),
              padding: EdgeInsets.symmetric(vertical: AppDimens.dp12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp12)),
            ),
            child: const Text('按组织架构'),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterPanel() {
    if (_loadingFilter) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
    }

    if (_treeType == _UserTreeType.organization) {
      return DropdownButtonFormField<String>(
        initialValue: _selectedDepartmentId,
        isExpanded: true,
        itemHeight: null,
        borderRadius: AppFormStyles.dropdownBorderRadius,
        dropdownColor: AppFormStyles.dropdownBackgroundColor,
        menuMaxHeight: AppFormStyles.dropdownMenuMaxHeight,
        items: _departmentOptions.map((item) => DropdownMenuItem<String>(value: item.value, child: AppDropdownMenuText(item.label))).toList(),
        selectedItemBuilder: (context) {
          return _departmentOptions.map((item) => AppDropdownSelectedText(item.label)).toList();
        },
        onChanged: (value) {
          if (value == null) return;
          setState(() {
            _selectedDepartmentId = value;
          });
          _loadUsers();
        },
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7B8798)),
        decoration: AppFormStyles.editableInputDecoration(
          hintText: '部门筛选',
          prefixIcon: const Icon(Icons.account_tree_outlined, size: 18, color: Color(0xFF7B8798)),
        ),
      );
    }

    final postItems = <DropdownMenuItem<String>>[
      const DropdownMenuItem<String>(value: _allOptionValue, child: AppDropdownMenuText('全部岗位')),
      ..._posts
          .map((item) {
            final id = (item.id ?? '').trim();
            final postName = (item.postName ?? '').trim();
            if (id.isEmpty) {
              return const DropdownMenuItem<String>(value: '', child: SizedBox());
            }
            return DropdownMenuItem<String>(value: id, child: AppDropdownMenuText(postName.isEmpty ? id : postName));
          })
          .where((item) => item.value != ''),
    ];

    return DropdownButtonFormField<String>(
      initialValue: _selectedPostId,
      isExpanded: true,
      itemHeight: null,
      borderRadius: AppFormStyles.dropdownBorderRadius,
      dropdownColor: AppFormStyles.dropdownBackgroundColor,
      menuMaxHeight: AppFormStyles.dropdownMenuMaxHeight,
      items: postItems,
      selectedItemBuilder: (context) {
        return postItems.map((item) => AppDropdownSelectedText(_dropdownItemText(item))).toList();
      },
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          _selectedPostId = value;
        });
        _loadUsers();
      },
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7B8798)),
      decoration: AppFormStyles.editableInputDecoration(
        hintText: '岗位筛选',
        prefixIcon: const Icon(Icons.badge_outlined, size: 18, color: Color(0xFF7B8798)),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _keywordController,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _loadUsers(),
      decoration: AppFormStyles.editableInputDecoration(
        hintText: '请输入姓名/关键字',
        prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF7B8798)),
        suffixIcon: IconButton(onPressed: _loadUsers, icon: const Icon(Icons.arrow_forward_rounded), tooltip: '查询'),
      ),
    );
  }

  Widget _buildUserList() {
    if (_loadingUsers) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_users.isEmpty) {
      return const _UserEmptyState();
    }

    return ListView.separated(
      itemCount: _users.length,
      separatorBuilder: (_, index) => SizedBox(height: AppDimens.dp8),
      itemBuilder: (context, index) {
        final row = _users[index];
        final id = (row.id ?? '').trim();
        final selected = _selectedUser?.id == id && id.isNotEmpty;

        return InkWell(
          onTap: id.isEmpty
              ? null
              : () {
                  setState(() {
                    _selectedUser = AppSelectedUser.fromSystemUser(row);
                  });
                },
          borderRadius: BorderRadius.circular(AppDimens.dp12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.all(AppDimens.dp12),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFEAF1FF) : Colors.white,
              borderRadius: BorderRadius.circular(AppDimens.dp12),
              border: Border.all(color: selected ? const Color(0xFF3A78F2) : const Color(0xFFDCE3EE)),
              boxShadow: [BoxShadow(color: selected ? const Color(0x143A78F2) : const Color(0x080F172A), blurRadius: selected ? 12 : 8, offset: const Offset(0, 3))],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppDimens.dp36,
                  height: AppDimens.dp36,
                  decoration: BoxDecoration(color: selected ? const Color(0xFFDDEAFF) : const Color(0xFFF3F6FB), borderRadius: BorderRadius.circular(AppDimens.dp12)),
                  child: Icon(Icons.person_outline_rounded, size: 20, color: selected ? const Color(0xFF3A78F2) : const Color(0xFF8DA0B5)),
                ),
                SizedBox(width: AppDimens.dp10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _nonEmpty((row.userName ?? '').trim(), fallback: id),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: AppDimens.sp13, color: const Color(0xFF223146), fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            width: AppDimens.dp24,
                            height: AppDimens.dp24,
                            decoration: BoxDecoration(color: selected ? const Color(0xFFE1ECFF) : const Color(0xFFF3F6FB), borderRadius: BorderRadius.circular(AppDimens.dp12)),
                            child: Icon(
                              selected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                              size: 18,
                              color: selected ? const Color(0xFF3A78F2) : const Color(0xFF9AA7B8),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimens.dp4),
                      _UserMetaLine(label: '岗位', value: _nonEmpty((row.postName ?? '').trim())),
                      SizedBox(height: AppDimens.dp3),
                      _UserMetaLine(label: '手机', value: _nonEmpty((row.phone ?? '').trim())),
                      SizedBox(height: AppDimens.dp3),
                      _UserMetaLine(label: '单位', value: _nonEmpty((row.companyName ?? '').trim())),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _nonEmpty(String value, {String fallback = '--'}) {
    if (value.trim().isEmpty) return fallback;
    return value;
  }

  String _dropdownItemText(DropdownMenuItem<String> item) {
    final child = item.child;
    if (child is AppDropdownMenuText) {
      return child.text;
    }
    if (child is Text) {
      return child.data ?? '';
    }
    return item.value ?? '';
  }
}

class _SelectSectionTitle extends StatelessWidget {
  const _SelectSectionTitle({required this.text, this.suffix});

  final String text;
  final String? suffix;

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
        if ((suffix ?? '').isNotEmpty) ...[
          SizedBox(width: AppDimens.dp8),
          Text(
            suffix!,
            style: TextStyle(color: const Color(0xFF7B8798), fontSize: AppDimens.sp11),
          ),
        ],
      ],
    );
  }
}

class _UserMetaLine extends StatelessWidget {
  const _UserMetaLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppDimens.dp34,
          child: Text(
            '$label：',
            style: TextStyle(fontSize: AppDimens.sp11, color: const Color(0xFF8A97A8)),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: AppDimens.sp11, color: const Color(0xFF66768B)),
          ),
        ),
      ],
    );
  }
}

class _UserEmptyState extends StatelessWidget {
  const _UserEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppDimens.dp54,
            height: AppDimens.dp54,
            decoration: BoxDecoration(color: const Color(0xFFEFF4FB), borderRadius: BorderRadius.circular(AppDimens.dp18)),
            child: const Icon(Icons.inbox_outlined, color: Color(0xFF8A97A8), size: 28),
          ),
          SizedBox(height: AppDimens.dp12),
          Text(
            '暂无人员数据',
            style: TextStyle(fontSize: AppDimens.sp13, color: const Color(0xFF223146), fontWeight: FontWeight.w700),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '请调整筛选条件后重试',
            style: TextStyle(fontSize: AppDimens.sp11, color: const Color(0xFF8A97A8)),
          ),
        ],
      ),
    );
  }
}

class _FilterOption {
  const _FilterOption({required this.value, required this.label});

  final String value;
  final String label;
}
