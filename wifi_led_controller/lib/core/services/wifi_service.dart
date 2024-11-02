import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart' as wifi_scan;
import 'package:wifi_iot/wifi_iot.dart' as wifi_iot;
import 'package:wifi_led_controller/features/wifi/models/wifi_network.dart';

class WifiService {
  Future<bool> checkPermissions() async {
    final locationStatus = await Permission.locationWhenInUse.request();
    if (locationStatus.isDenied) {
      return false;
    }
    return true;
  }

  Future<List<WiFiNetworkInfo>> scanNetworks() async {
    final canScan = await wifi_scan.WiFiScan.instance.canStartScan();
    if (canScan != wifi_scan.CanStartScan.yes) {
      throw Exception('Cannot scan for networks');
    }

    await wifi_scan.WiFiScan.instance.startScan();
    final results = await wifi_scan.WiFiScan.instance.getScannedResults();

    return results
        .map((result) => WiFiNetworkInfo(
              ssid: result.ssid,
              bssid: result.bssid,
              signalStrength: result.level,
              isSecure: result.capabilities.contains("WPA"),
            ))
        .toList();
  }

  Future<bool> connectToNetwork(String ssid, String password) async {
    return await wifi_iot.WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      security: wifi_iot.NetworkSecurity.WPA,
    );
  }

  Future<bool> disconnectFromNetwork() async {
    return await wifi_iot.WiFiForIoTPlugin.disconnect();
  }

  Future<String?> getCurrentNetwork() async {
    return await wifi_iot.WiFiForIoTPlugin.getSSID();
  }
}