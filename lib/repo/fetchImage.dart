import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:trackme/config.dart';
import 'package:trackme/utilities/logger.dart';

import '../utilities/localStorage.dart';

final Dio _dio = GetIt.I<Dio>();

Future<String> fetchImageURL() async {
  try {
    //String token = await SecureLocalStorage.getValue("Access_Token");
    Response response = await _dio.get("${UrlConfig.baseurl}/auth/image",
        //options: Options(headers: {"Authorization": token})
    );
    CustomLogger.debug(response.data["url"]);
    return response.data["url"];
  } catch (e) {
    CustomLogger.error(e);
    rethrow;
  }
}
