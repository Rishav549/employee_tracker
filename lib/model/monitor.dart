class Monitor {
  final int empId;
  final String timestamp;
  final String lat;
  final String lan;
  final String tagScanned;

  Monitor(
      {required this.empId,
      required this.timestamp,
      required this.lat,
      required this.lan,
      required this.tagScanned});

  factory Monitor.fromJson(Map<String, dynamic> json) {
    return Monitor(
        empId: json['emp_id'] as int,
        timestamp: json['Timestamp'] as String,
        lat: json['lat'] as String,
        lan: json['lan'] as String,
        tagScanned: json['tag_scanned'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'emp_id': empId,
      'Timestamp': timestamp,
      'lat': lat,
      'lan': lan,
      'tag_scanned': tagScanned
    };
  }
}
