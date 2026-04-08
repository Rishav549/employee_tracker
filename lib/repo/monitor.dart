import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:trackme/config.dart';
import 'package:trackme/model/monitor.dart';
import 'package:trackme/utilities/logger.dart';

import '../utilities/localStorage.dart';

final Dio _dio = GetIt.I<Dio>();

Future<void> uploadLog(Dio dio, Monitor data) async {
  try {
    //String token = await SecureLocalStorage.getValue("Access_Token");
    await dio.post("${UrlConfig.baseurl}/monitor/",
        data: data.toJson(),
        //options: Options(headers: {"Authorization": token})
    );
  } catch (e) {
    CustomLogger.error(e);
  }
}
