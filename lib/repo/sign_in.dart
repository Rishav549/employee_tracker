import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:trackme/model/user.dart';

import '../config.dart';
import '../utilities/logger.dart';

final Dio _dio = GetIt.I<Dio>();

Future<void> createUser({
  required String qr,
  required String macId,
  required String code,
  required String name,
  required String phone,
  required String email,
  required String designation,
  required String taggedIMEI,
  required String password,
  PlatformFile? image,
}) async {
  try {
    final formData = FormData.fromMap({
      'scan_code': qr,
      'mac_id': macId,
      'emp_code': code,
      'emp_name': name,
      'emp_phone': phone,
      'emp_email': email,
      'emp_designation': designation,
      'tagged_imei': taggedIMEI,
      'password': password,
      if (image != null)
        'emp_picture': await MultipartFile.fromFile(
          image.path!,
          filename: image.name,
        ),
    });

    await _dio.post("${UrlConfig.baseurl}/auth/register/", data: formData);
  } catch (e) {
    CustomLogger.error(e);
  }
}

Future<UserModel> fetch(String empCode) async {
  try {
    final response = await _dio.get(
        '${UrlConfig.baseurl}/employee/get?skip=0&limit=1&emp_code=$empCode');
    if (response.data is List && response.data.isNotEmpty) {
      return UserModel.fromJson(response.data[0]);
    } else {
      throw Exception("No user data found");
    }
  } catch (e) {
    CustomLogger.error(e);
    throw Exception("Failed to fetch user details: $e");
  }
}
