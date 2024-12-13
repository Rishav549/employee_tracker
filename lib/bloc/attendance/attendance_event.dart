part of 'attendance_bloc.dart';

abstract class AttendanceEvent {}

class UploadAttendanceEvent extends AttendanceEvent {
  final AttendanceModel att;

  UploadAttendanceEvent({required this.att});
}
