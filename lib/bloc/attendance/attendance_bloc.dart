library attendance_bloc;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackme/model/attendance.dart';
import 'package:trackme/model/error.dart';
import 'package:trackme/utilities/logger.dart';

import '../../repo/attendance.dart';

part 'attendance_event.dart';

part 'attendance_states.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceStates> {
  AttendanceBloc() : super(AttendanceInitialState()) {
    on<UploadAttendanceEvent>(_upload);
  }

  Future<void> _upload(UploadAttendanceEvent event, emit) async {
    emit(AttendanceLoadingState());
    try {
      // AttendanceModel data = await upload(event.att);
      // CustomLogger.debug(data);
      emit(AttendanceLoadedState());
    } catch (e) {
      CustomLogger.error(e);
      emit(AttendanceErrorState(
          error: ErrorModel(message: "Error Uploading Data", e: e)));
    }
  }
}
