import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:trackme/config.dart';
import 'package:trackme/utilities/logger.dart';

import '../utilities/localStorage.dart';

final Dio _dio = GetIt.I<Dio>();

Future<void> logIn(String email, String password) async {
  try {
    final Map<String, dynamic> data = {
      'emp_email': email,
      'password': password
    };
    Response response = await _dio.post('${UrlConfig.baseurl}/auth/login/', data: data);
    CustomLogger.info(response.data['access_token']);
    SecureLocalStorage.setValue("Access_Token", response.data['access_token']);
  } catch (e) {
    CustomLogger.error(e);
  }
}
