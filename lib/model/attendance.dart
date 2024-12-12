class AttendanceModel {
  final int empId;
  final DateTime attnDate;
  final DateTime loginDate;
  final String loginLat;
  final String loginLan;
  final String tagSignedIn;
  final DateTime logoutDate;
  final String logoutLat;
  final String logoutLan;
  final String tagSignedOut;

  AttendanceModel(
      {required this.empId,
      required this.attnDate,
      required this.loginDate,
      required this.loginLat,
      required this.loginLan,
      required this.tagSignedIn,
      required this.logoutDate,
      required this.logoutLat,
      required this.logoutLan,
      required this.tagSignedOut});

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      empId: json['emp_id'] as int,
      attnDate: DateTime.parse(json['attn_date']),
      loginDate: DateTime.parse(json['login_datestamp']),
      loginLat: json['login_lat'] as String,
      loginLan: json['login_lan'] as String,
      tagSignedIn: json['tag_scanned_in'] as String,
      logoutDate: DateTime.parse(json['logout_datestamp']),
      logoutLat: json['logout_lat'] as String,
      logoutLan: json['logout_lan'] as String,
      tagSignedOut: json['tag_scanned_out'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emp_id': empId,
      'attn_date': attnDate.toIso8601String(),
      'login_datestamp': loginDate.toIso8601String(),
      'login_lat': loginLat,
      'login_lan': loginLan,
      'tag_scanned_in': tagSignedIn,
      'logout_datestamp': logoutDate.toIso8601String(),
      'logout_lat': logoutLat,
      'logout_lan': logoutLan,
      'tag_scanned_out': tagSignedOut,
    };
  }
}
