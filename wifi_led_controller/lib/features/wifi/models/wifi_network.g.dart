// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wifi_network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WiFiNetworkInfoImpl _$$WiFiNetworkInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$WiFiNetworkInfoImpl(
      ssid: json['ssid'] as String,
      bssid: json['bssid'] as String,
      signalStrength: (json['signalStrength'] as num).toInt(),
      isSecure: json['isSecure'] as bool,
      isConnected: json['isConnected'] as bool? ?? false,
    );

Map<String, dynamic> _$$WiFiNetworkInfoImplToJson(
        _$WiFiNetworkInfoImpl instance) =>
    <String, dynamic>{
      'ssid': instance.ssid,
      'bssid': instance.bssid,
      'signalStrength': instance.signalStrength,
      'isSecure': instance.isSecure,
      'isConnected': instance.isConnected,
    };
