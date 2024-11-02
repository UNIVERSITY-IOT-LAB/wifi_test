import 'package:freezed_annotation/freezed_annotation.dart';

part 'wifi_network.freezed.dart';
part 'wifi_network.g.dart';

@freezed
class WifiNetwork with _$WifiNetwork {
  const factory WifiNetwork({
    required String ssid,
    required String bssid,
    required int signalStrength,
    required bool isSecure,
  }) = _WifiNetwork;

  factory WifiNetwork.fromJson(Map<String, dynamic> json) => 
    _$WifiNetworkFromJson(json);

  get signalStrength => null;

  String get ssid => null;

  get isSecure => null;
}