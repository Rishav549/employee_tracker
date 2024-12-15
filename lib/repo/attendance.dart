import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:trackme/config.dart';
import 'package:trackme/model/attendance.dart';
import 'package:trackme/utilities/logger.dart';

final Dio _dio = GetIt.I<Dio>();

Future<void> upload(AttendanceModel data) async {
  try {
    await _dio.post("${UrlConfig.baseurl}/attendance/", data: data.toJson());
  } on DioException catch (e) {
    if (e.response?.statusCode == 422) {
      CustomLogger.error("Unprocessable Entity: ${e.response?.data}");
    } else {
      CustomLogger.error("Unexpected error: ${e.message}");
    }
  }
}
