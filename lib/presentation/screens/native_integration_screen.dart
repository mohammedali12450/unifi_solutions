import 'package:flutter/material.dart';

import '../../platform/device_storage_channel.dart';
import '../../platform/permission_handler_channel.dart';

class NativeIntegrationScreen extends StatefulWidget {
  const NativeIntegrationScreen({super.key});

  @override
  _NativeIntegrationScreenState createState() => _NativeIntegrationScreenState();
}

class _NativeIntegrationScreenState extends State<NativeIntegrationScreen> {
  final DeviceStorageChannel _storageChannel = DeviceStorageChannel();
  final PermissionHandlerChannel _permissionChannel = PermissionHandlerChannel();

  String _storageInfo = 'Press button to get storage info';
  String _permissionStatus = 'Press button to request camera permission';

  Future<void> _fetchStorageInfo() async {
    final info = await _storageChannel.getStorageInfo();
    setState(() {
      if (info.isNotEmpty) {
        final free = info['freeSpace']!.toStringAsFixed(2);
        final total = info['totalSpace']!.toStringAsFixed(2);
        _storageInfo = '$free GB free of $total GB';
      } else {
        _storageInfo = 'Failed to get storage info';
      }
    });
  }

  Future<void> _requestPermission() async {
    final status = await _permissionChannel.requestCameraPermission();
    setState(() {
      _permissionStatus = 'Camera permission: ${status.toUpperCase()}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Integration'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Storage Info ---
              const Text('Task 1: Device Storage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_storageInfo, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _fetchStorageInfo,
                child: const Text('Get Storage Info'),
              ),
              const Divider(height: 40),

              // --- Permission Handling ---
              const Text('Task 2: Native Permissions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_permissionStatus, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _requestPermission,
                child: const Text('Request Camera Permission'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}