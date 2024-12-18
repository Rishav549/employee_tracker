class DeviceModel {
  final String scanCode;
  final String macId;

  DeviceModel({
    required this.scanCode,
    required this.macId,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      scanCode: json['scan_code'] as String,
      macId: json['mac_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scan_code': scanCode,
      'mac_id': macId,
    };
  }
}
