import 'package:file_picker/file_picker.dart';

class UserModel {
  final int id;
  final String empCode;
  final String scanCode;
  final String macID;
  final String empName;
  final String empPhone;
  final String empEmail;
  final String empDesignation;
  final String empPicture;
  final String taggedImei;
  final String password;

  UserModel(
      {required this.id,
      required this.empCode,
      required this.scanCode,
      required this.macID,
      required this.empName,
      required this.empPhone,
      required this.empEmail,
      required this.empDesignation,
      required this.empPicture,
      required this.taggedImei,
      required this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        empCode: json['emp_code'],
        scanCode: json['scan_code'],
        macID: json['mac_id'],
        empName: json['emp_name'],
        empPhone: json['emp_phone'],
        empEmail: json['emp_email'],
        empDesignation: json['emp_designation'],
        empPicture: json['emp_picture'],
        taggedImei: json['tagged_imei'],
        password: json['password']);
  }

  Map<String, dynamic> toJson() {
    return {
      'emp_code': empCode,
      'scan_code': scanCode,
      'mac_id': macID,
      'emp_name': empName,
      'emp_phone': empPhone,
      'emp_email': empEmail,
      'emp_designation': empDesignation,
      'emp_picture': empPicture,
      'tagged_imei': taggedImei,
    };
  }
}
