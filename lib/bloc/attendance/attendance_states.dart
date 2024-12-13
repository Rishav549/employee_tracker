part of 'attendance_bloc.dart';

abstract class AttendanceStates {}

class AttendanceInitialState extends AttendanceStates {}

class AttendanceLoadingState extends AttendanceStates {}

class AttendanceLoadedState extends AttendanceStates {}

class AttendanceErrorState extends AttendanceStates {
  final ErrorModel error;

  AttendanceErrorState({required this.error});
}
