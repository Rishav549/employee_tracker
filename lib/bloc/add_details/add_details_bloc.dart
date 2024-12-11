library add_details_bloc;

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackme/model/error.dart';
import 'package:trackme/repo/sign_in.dart';
import 'package:trackme/utilities/logger.dart';

part 'add_details_event.dart';

part 'add_details_states.dart';

class AddDetailsBloc extends Bloc<AddDetailsEvent, AddDetailsStates> {
  AddDetailsBloc() : super(AddDetailsInitialState()) {
    on<AddEmployeeDetailsEvent>(_signIn);
  }

  Future<void> _signIn(AddEmployeeDetailsEvent event, emit) async {
    emit(AddDetailsLoadingState());
    try {
      await createUser(
          qr: event.scanCode,
          macId: event.macID,
          code: event.empCode,
          name: event.empName,
          phone: event.empPhone,
          email: event.empEmail,
          designation: event.empDesignation,
          taggedIMEI: event.taggedImei,
          image: event.image,
          password: event.password);
      emit(AddDetailsLoadedState());
    } catch (e) {
      CustomLogger.error(e);
      emit(AddDetailsErrorState(
          error:
              ErrorModel(message: "Error Occurred In Uploading Data", e: e)));
    }
  }
}
