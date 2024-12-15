class AttendanceModel {
  final String empId;
  final String attnDate;
  final String loginDate;
  final String loginLat;
  final String loginLan;
  final String tagSignedIn;
  final String logoutDate;
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
      empId: json['emp_id'],
      attnDate: json['attn_date'],
      loginDate: json['login_datestamp'],
      loginLat: json['login_lat'] as String,
      loginLan: json['login_lan'] as String,
      tagSignedIn: json['tag_scanned_in'] as String,
      logoutDate: json['logout_datestamp'],
      logoutLat: json['logout_lat'] as String,
      logoutLan: json['logout_lan'] as String,
      tagSignedOut: json['tag_scanned_out'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emp_id': empId,
      'attn_date': attnDate,
      'login_datestamp': loginDate,
      'login_lat': loginLat,
      'login_lan': loginLan,
      'tag_scanned_in': tagSignedIn,
      'logout_datestamp': logoutDate,
      'logout_lat': logoutLat,
      'logout_lan': logoutLan,
      'tag_scanned_out': tagSignedOut,
    };
  }
}
