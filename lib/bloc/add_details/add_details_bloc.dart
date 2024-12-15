library add_details_bloc;

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackme/model/error.dart';
import 'package:trackme/model/user.dart';
import 'package:trackme/repo/sign_in.dart';
import 'package:trackme/utilities/localStorage.dart';
import 'package:trackme/utilities/logger.dart';

part 'add_details_event.dart';

part 'add_details_states.dart';

class AddDetailsBloc extends Bloc<AddDetailsEvent, AddDetailsStates> {
  String? _empCode;

  AddDetailsBloc() : super(AddDetailsInitialState()) {
    on<AddEmployeeDetailsEvent>(_signIn);
    on<FetchEmployeeDetailsEvent>(_fetch);
  }

  Future<void> _signIn(AddEmployeeDetailsEvent event, emit) async {
    emit(AddDetailsLoadingState());
    try {
      _empCode = event.empCode;
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
      SecureLocalStorage.setValue("password", event.password);
      emit(AddDetailsLoadedState());
    } catch (e) {
      CustomLogger.error(e);
      emit(AddDetailsErrorState(
          error:
              ErrorModel(message: "Error Occurred In Uploading Data", e: e)));
    }
  }

  Future<void> _fetch(FetchEmployeeDetailsEvent event, emit) async {
    emit(FetchDetailsLoadingState());
    try {
      CustomLogger.debug(_empCode!);
      UserModel user = await fetch(_empCode!);
      await SecureLocalStorage.setValue("emp_id", user.id.toString());
      await SecureLocalStorage.setValue("scan_code", user.scanCode);
      await SecureLocalStorage.setValue("mac_id", user.macID);
      await SecureLocalStorage.setValue("emp_code", user.empCode);
      await SecureLocalStorage.setValue("emp_name", user.empName);
      await SecureLocalStorage.setValue("emp_phone", user.empPhone);
      await SecureLocalStorage.setValue("emp_email", user.empEmail);
      await SecureLocalStorage.setValue("emp_designation", user.empDesignation);
      await SecureLocalStorage.setValue("emp_picture", user.empPicture);
      await SecureLocalStorage.setValue("tagged_imei", user.taggedImei);
      emit(FetchDetailsLoadedState());
    } catch (e) {
      CustomLogger.error(e);
    }
  }
}
