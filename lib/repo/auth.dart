import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:trackme/config.dart';
import 'package:trackme/utilities/logger.dart';

final Dio _dio = GetIt.I<Dio>();

Future<void> logIn(String email, String password) async {
  try {
    final Map<String, dynamic> data = {
      'emp_email': email,
      'password': password
    };
    await _dio.post('${UrlConfig.baseurl}/auth/login/', data: data);
    CustomLogger.debug(
        await _dio.post('${UrlConfig.baseurl}/auth/login/', data: data));
  } catch (e) {
    CustomLogger.error(e);
  }
}
