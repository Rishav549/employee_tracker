import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:trackme/config.dart';
import 'package:trackme/utilities/logger.dart';

import '../model/device.dart';

final Dio _dio =  GetIt.I<Dio>();

Future<DeviceModel> getMacId(String scanCode) async{
  try{
    Response response = await _dio.get("${UrlConfig.baseurl}/device/get?skip=0&limit=1&scan_code=$scanCode");
    if (response.data is List && response.data.isNotEmpty) {
      return DeviceModel.fromJson(response.data[0]);
    } else {
      throw Exception("QR Not Registered");
    }
  }catch(e){
    CustomLogger.error(e);
    rethrow;
  }
}
