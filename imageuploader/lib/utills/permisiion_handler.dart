import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> handlePermission() async {
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    final androidVersion = androidInfo.version.sdkInt;
    if (androidVersion >= 33) {
      // Android 13+ (API 33 and above)
      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      } else {
        // Open app settings to grant the permission
        await openAppSettings();
        return false;
      }
    } else if (androidVersion >= 29) {
      if (await Permission.storage.request().isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      // Android 9 and below (API 28 and below)
      if (await Permission.storage.request().isGranted) {
        return true;
      } else {
        return false;
      }
    }
  }
  return false;
}
