part of 'add_details_bloc.dart';

abstract class AddDetailsEvent {}

class AddEmployeeDetailsEvent extends AddDetailsEvent {
  final String empCode;
  final String scanCode;
  final String macID;
  final String empName;
  final String empPhone;
  final String empEmail;
  final String empDesignation;
  final String taggedImei;
  final String password;
  PlatformFile? image;

  AddEmployeeDetailsEvent(
      {required this.empCode,
      required this.scanCode,
      required this.macID,
      required this.empName,
      required this.empPhone,
      required this.empEmail,
      required this.empDesignation,
      required this.taggedImei,
      required this.image,
      required this.password});
}
