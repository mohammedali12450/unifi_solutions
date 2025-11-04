package com.example.your_project_name;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class PermissionHandlerManager implements PluginRegistry.RequestPermissionsResultListener {
    private static final int CAMERA_PERMISSION_REQUEST_CODE = 101;
    private final Activity activity;
    private MethodChannel.Result pendingResult;

    public PermissionHandlerManager(Activity activity) {
        this.activity = activity;
    }

    public void requestCameraPermission(MethodChannel.Result result) {
        this.pendingResult = result;
        // Check if permission is already granted
        if (ContextCompat.checkSelfPermission(activity, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
            result.success("granted");
        } else {
            // Request the permission
            ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.CAMERA}, CAMERA_PERMISSION_REQUEST_CODE);
        }
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode == CAMERA_PERMISSION_REQUEST_CODE && pendingResult != null) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                pendingResult.success("granted");
            } else {
                pendingResult.success("denied");
            }
            pendingResult = null; // Clear the pending result
            return true;
        }
        return false;
    }
}