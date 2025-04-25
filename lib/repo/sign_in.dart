import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:mime/mime.dart';
import 'package:trackme/model/user.dart';
import 'package:trackme/repo/auth.dart';
import 'package:trackme/utilities/localStorage.dart';

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
    MultipartFile? multipartImage;

    if (image != null) {
      final mimeType = lookupMimeType(image.path!);
      final fileName = image.path!.split('/').last;

      multipartImage = await MultipartFile.fromFile(
        image.path!,
        filename: fileName,
        contentType: mimeType != null ? DioMediaType.parse(mimeType!) : null,
      );
    }
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
      if (multipartImage != null) 'emp_picture': multipartImage,
    });
    await _dio.post("${UrlConfig.baseurl}/auth/register", data: formData);
    await logIn(email, password);
  }catch (e) {
    CustomLogger.error(e);
  }
}

Future<UserModel> fetch(String empCode) async {
  try {
    CustomLogger.info(empCode);
    final response = await _dio.get(
        '${UrlConfig.baseurl}/auth/$empCode');
    if (response.data!=null && response.data.isNotEmpty) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception("No user data found");
    }
  } catch (e) {
    CustomLogger.error(e);
    throw Exception("Failed to fetch user details: $e");
  }
}
