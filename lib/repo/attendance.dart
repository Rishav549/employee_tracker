import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:trackme/config.dart';
import 'package:trackme/model/attendance.dart';
import 'package:trackme/utilities/logger.dart';

import '../utilities/localStorage.dart';

final Dio _dio = GetIt.I<Dio>();

Future<void> upload(AttendanceModel data) async {
  try {
    String token = await SecureLocalStorage.getValue("Access_Token");
    await _dio.post("${UrlConfig.baseurl}/attendance/",
        data: data.toJson(),
        options: Options(headers: {"Authorization": token}));
  } catch (e) {
    CustomLogger.error(e);
  }
}
