import 'package:freezed_annotation/freezed_annotation.dart';

part 'wifi_network.freezed.dart';
part 'wifi_network.g.dart';

@freezed
class WiFiNetworkInfo with _$WiFiNetworkInfo {
  const factory WiFiNetworkInfo({
    required String ssid,
    required String bssid,
    required int signalStrength,
    required bool isSecure,
    @Default(false) bool isConnected,
  }) = _WiFiNetworkInfo;

  factory WiFiNetworkInfo.fromJson(Map<String, dynamic> json) => 
      _$WiFiNetworkInfoFromJson(json);

  const WiFiNetworkInfo._();
}