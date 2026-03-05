/// 审批闸机区域选项。
class CheckpointAreaOption {
  const CheckpointAreaOption({
    required this.districtId,
    required this.districtName,
    required this.deviceList,
  });

  final String districtId;
  final String districtName;
  final List<CheckpointDeviceOption> deviceList;

  factory CheckpointAreaOption.fromJson(Map<String, dynamic> json) {
    final deviceListRaw = json['deviceList'];
    return CheckpointAreaOption(
      districtId: (json['districtId'] ?? '').toString(),
      districtName: (json['districtName'] ?? '').toString(),
      deviceList: deviceListRaw is List
          ? deviceListRaw
                .map(
                  (device) => CheckpointDeviceOption.fromJson(
                    Map<String, dynamic>.from(device as Map),
                  ),
                )
                .toList()
          : const <CheckpointDeviceOption>[],
    );
  }
}

/// 审批闸机设备选项。
class CheckpointDeviceOption {
  const CheckpointDeviceOption({
    required this.deviceCode,
    required this.deviceName,
  });

  final String deviceCode;
  final String deviceName;

  factory CheckpointDeviceOption.fromJson(Map<String, dynamic> json) {
    return CheckpointDeviceOption(
      deviceCode: (json['deviceCode'] ?? '').toString(),
      deviceName: (json['deviceName'] ?? '').toString(),
    );
  }
}
