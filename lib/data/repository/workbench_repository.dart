import '../../core/http/http_service.dart';
import '../../core/http/paginated_parser.dart';
import '../../core/http/result.dart';
import '../models/workbench/appointment_approval_item_model.dart';
import '../models/workbench/blacklist_approval_item_model.dart';
import '../models/workbench/checkpoint_area_option_model.dart';
import '../models/workbench/inspection_abnormal_item_model.dart';
import '../models/workbench/inspection_rectification_item_model.dart';
import '../models/workbench/spot_inspection_check_item_model.dart';
import '../models/workbench/spot_inspection_item_model.dart';
import '../models/workbench/system_department_tree_model.dart';
import '../models/workbench/system_post_item_model.dart';
import '../models/workbench/system_user_item_model.dart';
import '../models/workbench/whitelist_approval_item_model.dart';

/// 工作台模块数据仓库：统一处理工作台相关接口。
class WorkbenchRepository {
  final HttpService _httpService = HttpService();

  /// 获取任务进度跟踪百分比。
  ///
  /// 对齐前端 Vue 接口：
  /// `POST /api/closed-off/workbenchStatistics/taskProgressStatistics`
  /// 接口 `data` 预期为数字百分比（如 60）。
  Future<Result<double>> getTaskProgressPercent() {
    return _httpService.post<double>(
      '/api/closed-off/workbenchStatistics/taskProgressStatistics',
      data: const {},
      parser: (json) {
        if (json is num) {
          return json.toDouble();
        }
        if (json is String) {
          return double.tryParse(json) ?? 0;
        }
        return 0;
      },
    );
  }

  /// 获取预约审批分页列表。
  ///
  /// [approvePageType]：2-园区待审批；3-园区已审批。
  Future<Result<PaginatedResult<AppointmentApprovalItemModel>>>
  getReservationApprovePage({
    required int approvePageType,
    int current = 1,
    int size = 20,
    int? reservationType,
    int? parkCheckStatus,
    String? keywords,
    String? beginTime,
    String? endTime,
  }) async {
    final requestData = <String, dynamic>{
      'approvePageType': approvePageType,
      'pageIndex': current,
      'pageSize': size,
      'reservationType': reservationType,
      'parkCheckStatus': parkCheckStatus,
      'keywords': keywords,
      'beginTime': beginTime,
      'endTime': endTime,
    };
    requestData.removeWhere((_, value) {
      if (value == null) return true;
      if (value is String && value.isEmpty) return true;
      return false;
    });

    final postResult = await _httpService
        .post<PaginatedResult<AppointmentApprovalItemModel>>(
          '/api/closed-off/reservation/reservationApprovePage',
          data: requestData,
          parser: (json) => parsePaginatedResult<AppointmentApprovalItemModel>(
            json: json,
            requestPageIndex: current,
            requestPageSize: size,
            itemParser: (itemJson) =>
                AppointmentApprovalItemModel.fromJson(itemJson),
          ),
        );

    if (postResult is Success<PaginatedResult<AppointmentApprovalItemModel>>) {
      return postResult;
    }

    final error =
        (postResult as Failure<PaginatedResult<AppointmentApprovalItemModel>>)
            .error;
    if (error.code != 405) {
      return postResult;
    }

    return _httpService.get<PaginatedResult<AppointmentApprovalItemModel>>(
      '/api/closed-off/reservation/reservationApprovePage',
      queryParameters: requestData,
      parser: (json) => parsePaginatedResult<AppointmentApprovalItemModel>(
        json: json,
        requestPageIndex: current,
        requestPageSize: size,
        itemParser: (itemJson) =>
            AppointmentApprovalItemModel.fromJson(itemJson),
      ),
    );
  }

  /// 获取白名单审批分页列表。
  Future<Result<PaginatedResult<WhitelistApprovalItemModel>>>
  getWhitelistApprovePage({
    required int parkCheckStatus,
    int current = 1,
    int size = 20,
    int? type,
    String? validityBeginTime,
    String? validityEndTime,
    String? keyword,
  }) {
    final requestData = <String, dynamic>{
      ...buildPagePayload(pageIndex: current, pageSize: size),
      'parkCheckStatus': parkCheckStatus,
      'type': type,
      'validityBeginTime': validityBeginTime,
      'validityEndTime': validityEndTime,
      // 移动端先按统一关键词透传，后续若后端要求拆字段再细化。
      'keywords': keyword,
    };
    requestData.removeWhere((_, value) {
      if (value == null) return true;
      if (value is String && value.isEmpty) return true;
      return false;
    });

    return _httpService.post<PaginatedResult<WhitelistApprovalItemModel>>(
      '/api/closed-off/white/page',
      data: requestData,
      parser: (json) => parsePaginatedResult<WhitelistApprovalItemModel>(
        json: json,
        requestPageIndex: current,
        requestPageSize: size,
        itemParser: (itemJson) => WhitelistApprovalItemModel.fromJson(itemJson),
      ),
    );
  }

  /// 获取白名单详情。
  Future<Result<Map<String, dynamic>>> getWhitelistDetail({
    required String id,
  }) {
    return _httpService.get<Map<String, dynamic>>(
      '/api/closed-off/white/one',
      queryParameters: {'id': id},
      parser: (json) {
        if (json is Map) {
          return Map<String, dynamic>.from(json);
        }
        if (json is List && json.isNotEmpty && json.first is Map) {
          return Map<String, dynamic>.from(json.first as Map);
        }
        throw StateError('白名单详情解析失败，期望 Map，实际为 ${json.runtimeType}');
      },
    );
  }

  /// 获取黑名单审批分页列表。
  Future<Result<PaginatedResult<BlacklistApprovalItemModel>>>
  getBlacklistApprovePage({
    required int parkCheckStatus,
    int current = 1,
    int size = 20,
    int? type,
    String? validityBeginTime,
    String? validityEndTime,
    String? keyword,
  }) {
    final requestData = <String, dynamic>{
      ...buildPagePayload(pageIndex: current, pageSize: size),
      'parkCheckStatus': parkCheckStatus,
      'type': type,
      'validityBeginTime': validityBeginTime,
      'validityEndTime': validityEndTime,
      'keywords': keyword,
    };
    requestData.removeWhere((_, value) {
      if (value == null) return true;
      if (value is String && value.isEmpty) return true;
      return false;
    });

    return _httpService.post<PaginatedResult<BlacklistApprovalItemModel>>(
      '/api/closed-off/black/page',
      data: requestData,
      parser: (json) => parsePaginatedResult<BlacklistApprovalItemModel>(
        json: json,
        requestPageIndex: current,
        requestPageSize: size,
        itemParser: (itemJson) => BlacklistApprovalItemModel.fromJson(itemJson),
      ),
    );
  }

  /// 获取黑名单详情。
  Future<Result<Map<String, dynamic>>> getBlacklistDetail({
    required String id,
  }) {
    return _httpService.get<Map<String, dynamic>>(
      '/api/closed-off/black/one',
      queryParameters: {'id': id},
      parser: (json) {
        if (json is Map) {
          return Map<String, dynamic>.from(json);
        }
        if (json is List && json.isNotEmpty && json.first is Map) {
          return Map<String, dynamic>.from(json.first as Map);
        }
        throw StateError('黑名单详情解析失败，期望 Map，实际为 ${json.runtimeType}');
      },
    );
  }

  /// 黑名单审批。
  Future<Result<void>> reviewBlacklist({
    required List<String> ids,
    required int parkCheckStatus,
    required String approvalOpinion,
  }) async {
    final result = await _httpService.post<dynamic>(
      '/api/closed-off/black/review',
      data: {
        'id': ids,
        'parkCheckStatus': parkCheckStatus,
        'approvalOpinion': approvalOpinion,
      },
    );

    return result.when(
      success: (_) => const Success<void>(null),
      failure: (error) => Failure<void>(error),
    );
  }

  /// 黑名单更改授权。
  Future<Result<void>> authorizeBlacklist({
    required List<String> ids,
    required String validityBeginTime,
    required String validityEndTime,
  }) async {
    final result = await _httpService.post<dynamic>(
      '/api/closed-off/black/authorize',
      data: {
        'id': ids,
        'validityBeginTime': validityBeginTime,
        'validityEndTime': validityEndTime,
      },
    );

    return result.when(
      success: (_) => const Success<void>(null),
      failure: (error) => Failure<void>(error),
    );
  }

  /// 白名单审批。
  Future<Result<void>> approveWhitelist({
    required List<String> ids,
    required int type,
    required int parkCheckStatus,
    required String validityBeginTime,
    required String validityEndTime,
    required String parkCheckDesc,
    required List<String> inDistrictIds,
    required List<String> outDistrictIds,
    required List<String> inDeviceCodes,
    required List<String> outDeviceCodes,
  }) async {
    final result = await _httpService.put<dynamic>(
      '/api/closed-off/white/approval',
      data: {
        'ids': ids,
        'type': type,
        'parkCheckStatus': parkCheckStatus,
        'validityBeginTime': validityBeginTime,
        'validityEndTime': validityEndTime,
        'parkCheckDesc': parkCheckDesc,
        'inDistrictId': inDistrictIds.join(','),
        'outDistrictId': outDistrictIds.join(','),
        'inDeviceCode': inDeviceCodes.join(','),
        'outDeviceCode': outDeviceCodes.join(','),
      },
    );

    return result.when(
      success: (_) => const Success<void>(null),
      failure: (error) => Failure<void>(error),
    );
  }

  /// 获取预约审批详情。
  Future<Result<Map<String, dynamic>>> getReservationProgressInfo({
    required String id,
  }) {
    return _httpService.get<Map<String, dynamic>>(
      '/api/closed-off/reservation/reservationProgressInfo/$id',
      parser: (json) {
        if (json is Map) {
          return Map<String, dynamic>.from(json);
        }
        if (json is List && json.isNotEmpty && json.first is Map) {
          return Map<String, dynamic>.from(json.first as Map);
        }
        throw StateError('详情解析失败，期望 Map，实际为 ${json.runtimeType}');
      },
    );
  }

  /// 获取预约进度时间线（基本信息模块）。
  ///
  /// 后端返回的是“流程节点数组”，不是单个详情对象：
  /// - `typeCode`：节点类型，0-发起预约，1-企业审批，2-园区审批，3-司机自检，4-园区抽查
  /// - `time`：当前节点时间
  /// - `specificData`：节点自身的业务字段，不同 typeCode 字段结构不同
  ///
  /// 前端详情页会根据 `typeCode` 将 `specificData` 再整理成分组结构。
  Future<Result<List<Map<String, dynamic>>>> getReservationProgressTimeline({
    required String id,
  }) {
    return _httpService.get<List<Map<String, dynamic>>>(
      '/api/closed-off/reservation/reservationProgressInfo/$id',
      parser: (json) {
        if (json is List) {
          return json
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        }
        if (json is Map) {
          return <Map<String, dynamic>>[Map<String, dynamic>.from(json)];
        }
        return const <Map<String, dynamic>>[];
      },
    );
  }

  /// 获取出入记录（出入记录模块）。
  ///
  /// 接口返回分组数组，每一组通常包含：
  /// - `startDate`：入园时间
  /// - `endDate`：出园时间
  /// - `data`：当前分组下的节点数组
  ///
  /// `data` 内部常见字段：
  /// - `type`：1-入园，2-出园，3-园内抓拍
  /// - `address`：地点/闸机名称
  /// - `headPicUrl` / `tailPicUrl`：抓拍图片
  Future<Result<List<Map<String, dynamic>>>> getGateRecords({
    required String id,
    int idType = 1,
  }) {
    return _httpService.get<List<Map<String, dynamic>>>(
      '/api/closed-off/accessRecord/getGateRecords',
      queryParameters: {'id': id, 'idType': idType},
      parser: (json) {
        if (json is List) {
          return json
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        }
        return const <Map<String, dynamic>>[];
      },
    );
  }

  /// 获取违规记录分页（违规记录模块）。
  ///
  /// 该接口为标准分页结构，列表项当前主要使用：
  /// - `subModuleTypeName`：违规类型
  /// - `position`：违规地点
  /// - `createDate`：违规时间
  /// - `description`：违规内容
  /// - `fileUrl`：违规影像
  Future<Result<PaginatedResult<Map<String, dynamic>>>> getRiskWarningPage({
    required int pageIndex,
    required int pageSize,
    required String relationId,
    String? carNum,
  }) {
    final payload = buildPagePayload(pageIndex: pageIndex, pageSize: pageSize)
      ..addAll({'relationId': relationId, 'carNum': carNum})
      ..removeWhere((key, value) => value == null || value == '');

    return _httpService.post<PaginatedResult<Map<String, dynamic>>>(
      '/api/risk-warning/riskWarning/page',
      data: payload,
      parser: (json) => parsePaginatedResult<Map<String, dynamic>>(
        json: json,
        requestPageIndex: pageIndex,
        requestPageSize: pageSize,
        itemParser: (item) => Map<String, dynamic>.from(item),
      ),
    );
  }

  /// 园区审批预约。
  Future<Result<void>> parkApproveReservation({
    required String id,
    required int parkCheckStatus,
    required String parkCheckDesc,
    required String validityBeginTime,
    required String validityEndTime,
    required List<String> inDistrictIds,
    required List<String> outDistrictIds,
    required List<String> inDeviceCodes,
    required List<String> outDeviceCodes,
    required int sampleCheck,
  }) async {
    final result = await _httpService.post<dynamic>(
      '/api/closed-off/reservation/parkApproveReservation',
      data: {
        'dto': {
          'id': id,
          'parkCheckStatus': parkCheckStatus,
          'parkCheckDesc': parkCheckDesc,
          'validityBeginTime': validityBeginTime,
          'validityEndTime': validityEndTime,
          'inDistrictId': inDistrictIds.join(','),
          'outDistrictId': outDistrictIds.join(','),
          'inDeviceCode': inDeviceCodes.join(','),
          'outDeviceCode': outDeviceCodes.join(','),
          'sampleCheck': sampleCheck,
        },
      },
    );
    return result.when(
      success: (_) => const Success<void>(null),
      failure: (error) => Failure<void>(error),
    );
  }

  /// 获取审批闸机列表（授权入口/授权出口）。
  Future<Result<List<CheckpointAreaOption>>> getCheckPointDevice({
    required int inOrOut,
    required int deviceType,
    String? validityBeginTime,
    String? validityEndTime,
  }) {
    final data = <String, dynamic>{
      'inOrOut': inOrOut,
      'deviceClass': [1],
      'deviceType': deviceType,
    };
    if ((validityBeginTime ?? '').isNotEmpty &&
        (validityEndTime ?? '').isNotEmpty) {
      data['approvalDate'] = [validityBeginTime, validityEndTime];
    }

    return _httpService.post<List<CheckpointAreaOption>>(
      '/api/closed-off/device/getCheckPointDevice',
      data: data,
      parser: (json) => (json is List ? json : const <dynamic>[])
          .map(
            (item) => CheckpointAreaOption.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  /// 获取巡检异常分页列表。
  Future<Result<PaginatedResult<InspectionAbnormalItemModel>>>
  getInspectionAbnormalPage({
    int current = 1,
    int size = 20,
    String? keywords,
    String? abnormalStatus,
    String? isUrgent,
    String? beginTime,
    String? endTime,
  }) {
    final payload = <String, dynamic>{
      ...buildPagePayload(pageIndex: current, pageSize: size),
      'keywords': keywords,
      'abnormalStatus': abnormalStatus,
      'isUrgent': isUrgent,
      'beginTime': beginTime,
      'endTime': endTime,
    };
    payload.removeWhere((_, value) {
      if (value == null) return true;
      if (value is String && value.isEmpty) return true;
      return false;
    });

    return _httpService.post<PaginatedResult<InspectionAbnormalItemModel>>(
      '/api/closed-off/inspectionAbnormal/page',
      data: payload,
      parser: (json) => parsePaginatedResult<InspectionAbnormalItemModel>(
        json: json,
        requestPageIndex: current,
        requestPageSize: size,
        itemParser: (itemJson) =>
            InspectionAbnormalItemModel.fromJson(itemJson),
      ),
    );
  }

  /// 获取巡检点位名称映射（id -> pointName）。
  Future<Result<Map<String, String>>> getInspectionPointNameMap() {
    return _httpService.get<Map<String, String>>(
      '/api/closed-off/inspectionPoint/list',
      parser: (json) {
        final map = <String, String>{};
        final rawList = json is List ? json : const <dynamic>[];
        for (final item in rawList) {
          if (item is! Map) continue;
          final id = (item['id'] ?? '').toString().trim();
          if (id.isEmpty) continue;
          final name = (item['pointName'] ?? item['name'] ?? '')
              .toString()
              .trim();
          map[id] = name.isEmpty ? id : name;
        }
        return map;
      },
    );
  }

  /// 获取巡检细则名称映射（id -> ruleName）。
  Future<Result<Map<String, String>>> getInspectionRuleNameMap() {
    return _httpService.get<Map<String, String>>(
      '/api/closed-off/inspectionRule/list',
      parser: (json) {
        final map = <String, String>{};
        final rawList = json is List ? json : const <dynamic>[];
        for (final item in rawList) {
          if (item is! Map) continue;
          final id = (item['id'] ?? '').toString().trim();
          if (id.isEmpty) continue;
          final name = (item['ruleName'] ?? item['name'] ?? '')
              .toString()
              .trim();
          map[id] = name.isEmpty ? id : name;
        }
        return map;
      },
    );
  }

  /// 获取系统部门树。
  Future<Result<List<SystemDepartmentTreeModel>>> getSystemDepartmentTree({
    int pageIndex = 1,
    int pageSize = 10000,
    String? departmentName,
  }) {
    final payload = <String, dynamic>{
      'pageIndex': pageIndex,
      'pageSize': pageSize,
      'departmentName': departmentName,
    };
    payload.removeWhere((_, value) {
      if (value == null) return true;
      if (value is String && value.trim().isEmpty) return true;
      return false;
    });

    return _httpService.post<List<SystemDepartmentTreeModel>>(
      '/api/system/department/tree',
      data: payload,
      parser: (json) {
        final rawList = json is List
            ? json
            : (json is Map
                  ? (json['records'] ??
                        json['list'] ??
                        json['rows'] ??
                        json['data'] ??
                        const <dynamic>[])
                  : const <dynamic>[]);
        final list = rawList is List ? rawList : const <dynamic>[];
        return list
            .whereType<Map>()
            .map(
              (item) => SystemDepartmentTreeModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
      },
    );
  }

  /// 获取系统岗位列表。
  Future<Result<List<SystemPostItemModel>>> getSystemPostList({
    String? departmentId,
    String? postName,
  }) {
    final query = <String, dynamic>{
      'departmentId': departmentId,
      'postName': postName,
    };
    query.removeWhere((_, value) {
      if (value == null) return true;
      if (value is String && value.trim().isEmpty) return true;
      return false;
    });

    return _httpService.get<List<SystemPostItemModel>>(
      '/api/system/post/list',
      queryParameters: query.isEmpty ? null : query,
      parser: (json) {
        final rawList = json is List
            ? json
            : (json is Map
                  ? (json['records'] ??
                        json['list'] ??
                        json['rows'] ??
                        json['data'] ??
                        const <dynamic>[])
                  : const <dynamic>[]);
        final list = rawList is List ? rawList : const <dynamic>[];
        return list
            .whereType<Map>()
            .map(
              (item) =>
                  SystemPostItemModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();
      },
    );
  }

  /// 获取系统人员分页列表。
  Future<Result<PaginatedResult<SystemUserItemModel>>> getSystemUserPage({
    int current = 1,
    int size = 20,
    String? keywords,
    String? departmentId,
    String? postId,
  }) {
    final payload = <String, dynamic>{
      ...buildPagePayload(pageIndex: current, pageSize: size),
      'keywords': keywords,
      'departmentId': departmentId,
      'postId': postId,
    };
    payload.removeWhere((_, value) {
      if (value == null) return true;
      if (value is String && value.trim().isEmpty) return true;
      return false;
    });

    return _httpService.post<PaginatedResult<SystemUserItemModel>>(
      '/api/system/user/page',
      data: payload,
      parser: (json) => parsePaginatedResult<SystemUserItemModel>(
        json: json,
        requestPageIndex: current,
        requestPageSize: size,
        itemParser: (itemJson) => SystemUserItemModel.fromJson(itemJson),
      ),
    );
  }

  /// 获取异常的整改记录列表。
  Future<Result<List<InspectionRectificationItemModel>>>
  getInspectionRectifications({required String abnormalId}) {
    return _httpService.get<List<InspectionRectificationItemModel>>(
      '/api/closed-off/inspectionAbnormal/getRectifications',
      queryParameters: {'abnormalId': abnormalId},
      parser: (json) => (json is List ? json : const <dynamic>[])
          .whereType<Map>()
          .map(
            (item) => InspectionRectificationItemModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
    );
  }

  /// 确认异常。
  Future<Result<void>> confirmInspectionAbnormal({
    required String abnormalId,
    required String verifyResult,
    String? verifierId,
    String? verifierName,
    String? responsibleType,
    String? responsibleId,
    String? responsibleName,
    String? rectifyUserId,
    String? rectifyUserName,
    String? deadline,
  }) async {
    final payload = <String, dynamic>{
      'abnormalId': abnormalId,
      'verifyResult': verifyResult,
      'verifierId': verifierId,
      'verifierName': verifierName,
      'responsibleType': responsibleType,
      'responsibleId': responsibleId,
      'responsibleName': responsibleName,
      'rectifyUserId': rectifyUserId,
      'rectifyUserName': rectifyUserName,
      'deadline': deadline,
    };
    payload.removeWhere((_, value) {
      if (value == null) return true;
      if (value is String && value.trim().isEmpty) return true;
      return false;
    });

    final result = await _httpService.post<dynamic>(
      '/api/closed-off/inspectionAbnormal/confirm',
      data: payload,
    );
    return result.when(
      success: (_) => const Success<void>(null),
      failure: (error) => Failure<void>(error),
    );
  }

  /// 提交整改。
  Future<Result<void>> submitInspectionRectification({
    required String abnormalId,
    required String rectifyUserId,
    required String rectifyUserName,
    required String rectifyDesc,
    List<String>? photoUrls,
  }) async {
    final payload = <String, dynamic>{
      'abnormalId': abnormalId,
      'rectifyUserId': rectifyUserId,
      'rectifyUserName': rectifyUserName,
      'rectifyDesc': rectifyDesc,
      'photoUrls': photoUrls ?? const <String>[],
    };

    final result = await _httpService.post<dynamic>(
      '/api/closed-off/inspectionAbnormal/submitRectification',
      data: payload,
    );
    return result.when(
      success: (_) => const Success<void>(null),
      failure: (error) => Failure<void>(error),
    );
  }

  /// 核查整改。
  Future<Result<void>> verifyInspectionRectification({
    required String abnormalId,
    required String rectificationId,
    required String verifyResult,
    String? verifyComment,
    String? verifierId,
    String? verifierName,
  }) async {
    final payload = <String, dynamic>{
      'abnormalId': abnormalId,
      'rectificationId': rectificationId,
      'verifyResult': verifyResult,
      'verifyComment': verifyComment,
      'verifierId': verifierId,
      'verifierName': verifierName,
    };
    payload.removeWhere((_, value) {
      if (value == null) return true;
      if (value is String && value.trim().isEmpty) return true;
      return false;
    });

    final result = await _httpService.post<dynamic>(
      '/api/closed-off/inspectionAbnormal/verifyRectification',
      data: payload,
    );
    return result.when(
      success: (_) => const Success<void>(null),
      failure: (error) => Failure<void>(error),
    );
  }

  /// 重新指派。
  Future<Result<void>> reassignInspectionAbnormal({
    required String abnormalId,
    required String newRectifyUserId,
    required String newRectifyUserName,
    String? reassignReason,
  }) async {
    final payload = <String, dynamic>{
      'abnormalId': abnormalId,
      'newRectifyUserId': newRectifyUserId,
      'newRectifyUserName': newRectifyUserName,
      'reassignReason': reassignReason,
    };
    payload.removeWhere((_, value) {
      if (value == null) return true;
      if (value is String && value.trim().isEmpty) return true;
      return false;
    });

    final result = await _httpService.post<dynamic>(
      '/api/closed-off/inspectionAbnormal/reassign',
      data: payload,
    );
    return result.when(
      success: (_) => const Success<void>(null),
      failure: (error) => Failure<void>(error),
    );
  }

  /// 获取车辆抽检分页列表。
  Future<Result<PaginatedResult<SpotInspectionItemModel>>>
  getSpotInspectionPage({
    int current = 1,
    int size = 20,
    String? keyword,
    String? strCheckTime,
    String? endCheckTime,
    String? checkType,
    String? enter,
    String? securityCheckResults,
  }) {
    final payload = <String, dynamic>{
      ...buildPagePayload(pageIndex: current, pageSize: size),
      'keywords': keyword,
      'strCheckTime': strCheckTime,
      'endCheckTime': endCheckTime,
      'checkType': checkType,
      'enter': enter,
      'securityCheckResults': securityCheckResults,
    };
    payload.removeWhere((_, value) {
      if (value == null) return true;
      if (value is String && value.isEmpty) return true;
      return false;
    });

    return _httpService.post<PaginatedResult<SpotInspectionItemModel>>(
      '/api/closed-off/securityCheckList/getToBeCheckedList',
      data: payload,
      parser: (json) => parsePaginatedResult<SpotInspectionItemModel>(
        json: json,
        requestPageIndex: current,
        requestPageSize: size,
        itemParser: (itemJson) => SpotInspectionItemModel.fromJson(itemJson),
      ),
    );
  }

  /// 获取车辆抽检统计。
  Future<Result<Map<String, dynamic>>> getSpotInspectionStatistics() {
    return _httpService.get<Map<String, dynamic>>(
      '/api/closed-off/securityCheckResult/samplingLedgersStatistics',
      parser: (json) {
        if (json is Map) return Map<String, dynamic>.from(json);
        return const <String, dynamic>{};
      },
    );
  }

  /// 获取车辆抽检详情。
  Future<Result<Map<String, dynamic>>> getSpotInspectionDetail({
    required String id,
  }) {
    return _httpService.get<Map<String, dynamic>>(
      '/api/closed-off/securityCheckResult/one',
      queryParameters: {'id': id},
      parser: (json) {
        if (json is Map) {
          return Map<String, dynamic>.from(json);
        }
        if (json is List && json.isNotEmpty && json.first is Map) {
          return Map<String, dynamic>.from(json.first as Map);
        }
        throw StateError('车辆抽检详情解析失败，期望 Map，实际为 ${json.runtimeType}');
      },
    );
  }

  /// 获取车辆抽检检查项列表。
  Future<Result<List<SpotInspectionCheckItemModel>>>
  getSpotInspectionCheckList({required String reservationId}) {
    return _httpService.get<List<SpotInspectionCheckItemModel>>(
      '/api/closed-off/securityCheckList/list',
      queryParameters: {'reservationId': reservationId},
      parser: (json) => (json is List ? json : const <dynamic>[])
          .map(
            (item) => SpotInspectionCheckItemModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  /// 获取抽检员待抽检检查项列表。
  Future<Result<List<SpotInspectionCheckItemModel>>>
  getWaitingInspectorCheckItemList({required String reservationId}) {
    return _httpService.get<List<SpotInspectionCheckItemModel>>(
      '/api/closed-off/templateCheckItem/selWaitingInspectorCheckItem',
      queryParameters: {'reservationId': reservationId},
      parser: (json) => (json is List ? json : const <dynamic>[])
          .map(
            (item) => SpotInspectionCheckItemModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  /// 获取检查项详情。
  Future<Result<SpotInspectionCheckItemModel>> getCheckItemDetail({
    required String id,
  }) {
    return _httpService.get<SpotInspectionCheckItemModel>(
      '/api/closed-off/templateCheckItem/one',
      queryParameters: {'id': id},
      parser: (json) {
        if (json is Map) {
          return SpotInspectionCheckItemModel.fromJson(
            Map<String, dynamic>.from(json),
          );
        }
        throw StateError('检查项详情解析失败，期望 Map，实际为 ${json.runtimeType}');
      },
    );
  }

  /// 提交抽检结果。
  Future<Result<void>> submitSelfCheckList({
    required Map<String, dynamic> payload,
  }) async {
    final result = await _httpService.post<dynamic>(
      '/api/closed-off/securityCheckList/add',
      data: payload,
    );

    return result.when(
      success: (_) => const Success<void>(null),
      failure: (error) => Failure<void>(error),
    );
  }

  /// 提交车辆抽检结果。
  Future<Result<void>> submitSpotInspection({
    required Map<String, dynamic> payload,
  }) async {
    final result = await _httpService.put<dynamic>(
      '/api/closed-off/securityCheckResult',
      data: payload,
    );

    return result.when(
      success: (_) => const Success<void>(null),
      failure: (error) => Failure<void>(error),
    );
  }
}
