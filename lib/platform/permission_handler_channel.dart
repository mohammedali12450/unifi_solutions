import 'package:flutter/services.dart';
import 'dart:async';

class PermissionHandlerChannel {
  static const MethodChannel _channel = MethodChannel('com.flutter.exam/permission_handler');

  // Returns the status as a string: "granted" or "denied"
  Future<String> requestCameraPermission() async {
    try {
      final String status = await _channel.invokeMethod('requestCameraPermission');
      return status;
    } on PlatformException catch (e) {
      print("Failed to request camera permission: '${e.message}'.");
      return "denied";
    }
  }
}