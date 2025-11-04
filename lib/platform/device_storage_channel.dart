import 'package:flutter/services.dart';
import 'dart:async';

class DeviceStorageChannel {
  // Define the channel. The name must be unique and match the native side.
  static const MethodChannel _channel = MethodChannel('com.flutter.exam/device_storage');

  Future<Map<String, double>> getStorageInfo() async {
    try {
      // Invoke the method 'getStorageInfo' on the native side.
      // We expect a Map in return, e.g., {'freeSpace': 12.3, 'totalSpace': 64.0}
      final result = await _channel.invokeMethod<Map>('getStorageInfo');

      // Safely cast the result.
      return Map<String, double>.from(result ?? {});
    } on PlatformException catch (e) {
      // Handle any exceptions that occur during the platform call.
      print("Failed to get storage info: '${e.message}'.");
      return {};
    }
  }
}