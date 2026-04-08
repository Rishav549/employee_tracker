import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trackme/model/monitor.dart';
import 'package:trackme/repo/monitor.dart';
import 'package:trackme/utilities/localStorage.dart';
import 'package:trackme/utilities/logger.dart';

import '../config.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  late Dio dio;
  Timer? _timer;
  bool isRunning = true;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    if (!isRunning) return;
    CustomLogger.info("Background Service Started");
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      try {
        dio = Dio(
          BaseOptions(
            baseUrl: UrlConfig.baseurl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );
        final empIdStr = await SecureLocalStorage.getValue("emp_id");
        final scanCode = await SecureLocalStorage.getValue("scan_code");
        if (empIdStr == null || scanCode == null) {
          CustomLogger.error("Missing empId or scanCode");
          return;
        }
        final empId = int.parse(empIdStr);
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        final monitorData = Monitor(
          empId: empId,
          timestamp: DateTime.now().toUtc(),
          lat: position.latitude.toString(),
          lan: position.longitude.toString(),
          tagScanned: scanCode,
        );
        await uploadLog(dio, monitorData);
        FlutterForegroundTask.sendDataToMain({
          "timestampMillis": DateTime.now().millisecondsSinceEpoch,
        });

      } catch (e) {
        CustomLogger.error("Background error: $e");
      }
    });
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    _timer?.cancel();
    isRunning = false;
    CustomLogger.info("Background Service Stopped");
  }

  @override
  void onReceiveData(Object data) {
    if (data == "stop") {
      _timer?.cancel();
      isRunning = false;
    }
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp();
  }
}