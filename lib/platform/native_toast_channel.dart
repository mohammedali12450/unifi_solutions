import 'package:flutter/services.dart';
import 'dart:async';

/// A class to manage communication with the native side for showing toasts.
class NativeToastChannel {
  // 1. Define the MethodChannel.
  // This name MUST be unique and identical on the Android and iOS sides.
  static const MethodChannel _channel = MethodChannel('com.flutter.exam/native_toast');

  /// Invokes the native method 'showToast' to display a message.
  Future<void> showToast(String message) async {
    try {
      // 2. Invoke the method, passing the message as an argument in a map.
      await _channel.invokeMethod('showToast', {'message': message});
    } on PlatformException catch (e) {
      // 3. Handle any errors that occur during the platform call.
      print("Failed to show native toast: '${e.message}'.");
    }
  }
}