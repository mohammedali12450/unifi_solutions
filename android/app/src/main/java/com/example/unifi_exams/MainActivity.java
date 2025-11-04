package com.example.unifi_exams;

import android.widget.Toast;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String STORAGE_CHANNEL = "com.flutter.exam/device_storage";
    private com.example.your_project_name.PermissionHandlerManager permissionHandlerManager;
    private static final String PERMISSION_CHANNEL = "com.flutter.exam/permission_handler";
    private static final String TOAST_CHANNEL = "com.flutter.exam/native_toast";
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // Setup the MethodChannel
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), STORAGE_CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Check which method is being called from Flutter
                            if (call.method.equals("getStorageInfo")) {
                                com.example.your_project_name.DeviceStorageManager storageManager = new com.example.your_project_name.DeviceStorageManager();
                                result.success(storageManager.getStorageInfo());
                            } else {
                                result.notImplemented();
                            }
                        }
                );
        permissionHandlerManager = new com.example.your_project_name.PermissionHandlerManager(this);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), PERMISSION_CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("requestCameraPermission")) {
                                permissionHandlerManager.requestCameraPermission(result);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), TOAST_CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // 4. Check if the method name from Flutter matches "showToast"
                            if (call.method.equals("showToast")) {
                                // 5. Extract the 'message' argument sent from Flutter
                                final String message = call.argument("message");

                                // 6. Create and show the native Android Toast
                                Toast.makeText(getContext(), message, Toast.LENGTH_LONG).show();

                                // 7. Send a success result back to Flutter (in this case, null is fine)
                                result.success(null);
                            } else {
                                // If the method name is unknown, report it
                                result.notImplemented();
                            }
                        }
                );
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (permissionHandlerManager != null) {
            permissionHandlerManager.onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }
}