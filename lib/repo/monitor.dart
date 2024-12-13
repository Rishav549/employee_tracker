import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:trackme/config.dart';
import 'package:trackme/model/monitor.dart';
import 'package:trackme/utilities/logger.dart';

final Dio _dio = GetIt.I<Dio>();

Future<void> uploadLog(Monitor data) async {
  try {
    await _dio.post("${UrlConfig.baseurl}/monitor/", data: data.toJson());
  } catch (e) {
    CustomLogger.error(e);
  }
}
