import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_led_controller/features/wifi/models/wifi_network.dart';

class WifiService {
  Future<bool> checkPermissions() async {
    final locationStatus = await Permission.locationWhenInUse.request();
    if (locationStatus.isDenied) {
      return false;
    }
    return true;
  }

  Future<List<WifiNetwork>> scanNetworks() async {
    final canScan = await WiFiScan.instance.canStartScan();
    if (canScan != CanStartScan.yes) {
      throw Exception('Cannot scan for networks');
    }

    await WiFiScan.instance.startScan();
    final results = await WiFiScan.instance.getScannedResults();

    return results
        .map((result) => WifiNetwork(
              ssid: result.ssid,
              bssid: result.bssid,
              signalStrength: result.level,
              isSecure: result.capabilities.contains("WPA"),
            ))
        .toList();
  }

  Future<bool> connectToNetwork(String ssid, String password) async {
    return await WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      security: NetworkSecurity.WPA,
    );
  }

  Future<bool> disconnectFromNetwork() async {
    return await WiFiForIoTPlugin.disconnect();
  }

  Future<String?> getCurrentNetwork() async {
    return await WiFiForIoTPlugin.getSSID();
  }
}