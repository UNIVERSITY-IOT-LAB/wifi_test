import 'package:wifi_led_controller/features/wifi/models/wifi_network.dart';

extension WiFiNetworkInfoX on WiFiNetworkInfo {
  int get signalLevel {
    if (signalStrength >= -50) return 4;
    if (signalStrength >= -60) return 3;
    if (signalStrength >= -70) return 2;
    return 1;
  }

  String get signalDescription {
    switch (signalLevel) {
      case 4:
        return '매우 강함';
      case 3:
        return '강함';
      case 2:
        return '보통';
      default:
        return '약함';
    }
  }

  bool get isESP32Device {
    return ssid.toLowerCase().contains('esp32');
  }

  String get displayName {
    if (ssid.isEmpty) return 'Unknown Network';
    return ssid;
  }
}