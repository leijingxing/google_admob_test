import 'package:flutter/material.dart';

import '../../../data/models/workbench/system_department_tree_model.dart';
import '../../../data/models/workbench/system_post_item_model.dart';
import '../../../data/models/workbench/system_user_item_model.dart';
import '../../../data/repository/workbench_repository.dart';
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
    final resolvedBorderRadius = borderRadius ?? BorderRadius.circular(AppDimens.dp6);
    final resolvedBorderColor = borderColor ?? const Color(0xFFC9D2DF);

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
            Text(label, style: TextStyle(fontSize: AppDimens.sp12)),
          ],
        ),
        SizedBox(height: AppDimens.dp4),
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
            padding: EdgeInsets.symmetric(horizontal: AppDimens.dp10, vertical: AppDimens.dp10),
            decoration: BoxDecoration(
              color: enabled ? Colors.white : const Color(0xFFF5F6F8),
              borderRadius: resolvedBorderRadius,
              border: Border.all(color: resolvedBorderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: hasValue
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selected.displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: AppDimens.sp13, color: const Color(0xFF2B3A4F), fontWeight: FontWeight.w600),
                            ),
                            if (selected.postName.isNotEmpty || selected.phone.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: AppDimens.dp2),
                                child: Text(
                                  _buildSubLine(selected),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: AppDimens.sp11, color: const Color(0xFF8A97A8)),
                                ),
                              ),
                          ],
                        )
                      : Text(
                          hintText,
                          style: TextStyle(fontSize: AppDimens.sp12, color: const Color(0xFF9AA7B8)),
                        ),
                ),
                if (hasValue && clearable && enabled)
                  GestureDetector(
                    onTap: () => onChanged(null),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.only(right: AppDimens.dp8),
                      child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF9AA7B8)),
                    ),
                  ),
                Icon(Icons.keyboard_arrow_down_rounded, color: enabled ? const Color(0xFF7E8EA4) : const Color(0xFFB7C0CE)),
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
    return parts.join('  ');
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
              _buildFilterPanel(),
              SizedBox(height: AppDimens.dp10),
              _buildSearchBar(),
              SizedBox(height: AppDimens.dp10),
              Expanded(child: _buildUserList()),
              SizedBox(height: AppDimens.dp10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('取消')),
                  ),
                  SizedBox(width: AppDimens.dp10),
                  Expanded(
                    child: FilledButton(
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
        items: _departmentOptions
            .map(
              (item) => DropdownMenuItem<String>(
                value: item.value,
                child: Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value == null) return;
          setState(() {
            _selectedDepartmentId = value;
          });
          _loadUsers();
        },
        decoration: const InputDecoration(isDense: true, labelText: '部门筛选', border: OutlineInputBorder()),
      );
    }

    final postItems = <DropdownMenuItem<String>>[
      const DropdownMenuItem<String>(value: _allOptionValue, child: Text('全部岗位')),
      ..._posts
          .map((item) {
            final id = (item.id ?? '').trim();
            final postName = (item.postName ?? '').trim();
            if (id.isEmpty) {
              return const DropdownMenuItem<String>(value: '', child: SizedBox());
            }
            return DropdownMenuItem<String>(value: id, child: Text(postName.isEmpty ? id : postName));
          })
          .where((item) => item.value != ''),
    ];

    return DropdownButtonFormField<String>(
      initialValue: _selectedPostId,
      items: postItems,
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          _selectedPostId = value;
        });
        _loadUsers();
      },
      decoration: const InputDecoration(isDense: true, labelText: '岗位筛选', border: OutlineInputBorder()),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _keywordController,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _loadUsers(),
            decoration: InputDecoration(
              hintText: '请输入姓名/关键字',
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimens.dp6)),
              suffixIcon: IconButton(onPressed: _loadUsers, icon: const Icon(Icons.search_rounded), tooltip: '查询'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserList() {
    if (_loadingUsers) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_users.isEmpty) {
      return Center(
        child: Text(
          '暂无人员数据',
          style: TextStyle(fontSize: AppDimens.sp12, color: const Color(0xFF8A97A8)),
        ),
      );
    }

    return ListView.separated(
      itemCount: _users.length,
      separatorBuilder: (_, _) => SizedBox(height: AppDimens.dp8),
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
          borderRadius: BorderRadius.circular(AppDimens.dp8),
          child: Container(
            padding: EdgeInsets.all(AppDimens.dp10),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFEAF1FF) : Colors.white,
              borderRadius: BorderRadius.circular(AppDimens.dp8),
              border: Border.all(color: selected ? const Color(0xFF3A78F2) : const Color(0xFFDCE3EE)),
            ),
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
                        style: TextStyle(fontSize: AppDimens.sp13, color: const Color(0xFF2E3B4D), fontWeight: FontWeight.w700),
                      ),
                    ),
                    Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded, size: 18, color: selected ? const Color(0xFF3A78F2) : const Color(0xFF9AA7B8)),
                  ],
                ),
                SizedBox(height: AppDimens.dp4),
                Text(
                  '岗位：${_nonEmpty((row.postName ?? '').trim())}   手机：${_nonEmpty((row.phone ?? '').trim())}',
                  style: TextStyle(fontSize: AppDimens.sp11, color: const Color(0xFF7E8DA1)),
                ),
                SizedBox(height: AppDimens.dp2),
                Text(
                  '单位：${_nonEmpty((row.companyName ?? '').trim())}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: AppDimens.sp11, color: const Color(0xFF7E8DA1)),
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
}

class _FilterOption {
  const _FilterOption({required this.value, required this.label});

  final String value;
  final String label;
}
