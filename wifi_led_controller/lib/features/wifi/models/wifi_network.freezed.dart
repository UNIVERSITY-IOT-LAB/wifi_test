// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wifi_network.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WiFiNetworkInfo _$WiFiNetworkInfoFromJson(Map<String, dynamic> json) {
  return _WiFiNetworkInfo.fromJson(json);
}

/// @nodoc
mixin _$WiFiNetworkInfo {
  String get ssid => throw _privateConstructorUsedError;
  String get bssid => throw _privateConstructorUsedError;
  int get signalStrength => throw _privateConstructorUsedError;
  bool get isSecure => throw _privateConstructorUsedError;
  bool get isConnected => throw _privateConstructorUsedError;

  /// Serializes this WiFiNetworkInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WiFiNetworkInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WiFiNetworkInfoCopyWith<WiFiNetworkInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WiFiNetworkInfoCopyWith<$Res> {
  factory $WiFiNetworkInfoCopyWith(
          WiFiNetworkInfo value, $Res Function(WiFiNetworkInfo) then) =
      _$WiFiNetworkInfoCopyWithImpl<$Res, WiFiNetworkInfo>;
  @useResult
  $Res call(
      {String ssid,
      String bssid,
      int signalStrength,
      bool isSecure,
      bool isConnected});
}

/// @nodoc
class _$WiFiNetworkInfoCopyWithImpl<$Res, $Val extends WiFiNetworkInfo>
    implements $WiFiNetworkInfoCopyWith<$Res> {
  _$WiFiNetworkInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WiFiNetworkInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ssid = null,
    Object? bssid = null,
    Object? signalStrength = null,
    Object? isSecure = null,
    Object? isConnected = null,
  }) {
    return _then(_value.copyWith(
      ssid: null == ssid
          ? _value.ssid
          : ssid // ignore: cast_nullable_to_non_nullable
              as String,
      bssid: null == bssid
          ? _value.bssid
          : bssid // ignore: cast_nullable_to_non_nullable
              as String,
      signalStrength: null == signalStrength
          ? _value.signalStrength
          : signalStrength // ignore: cast_nullable_to_non_nullable
              as int,
      isSecure: null == isSecure
          ? _value.isSecure
          : isSecure // ignore: cast_nullable_to_non_nullable
              as bool,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WiFiNetworkInfoImplCopyWith<$Res>
    implements $WiFiNetworkInfoCopyWith<$Res> {
  factory _$$WiFiNetworkInfoImplCopyWith(_$WiFiNetworkInfoImpl value,
          $Res Function(_$WiFiNetworkInfoImpl) then) =
      __$$WiFiNetworkInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String ssid,
      String bssid,
      int signalStrength,
      bool isSecure,
      bool isConnected});
}

/// @nodoc
class __$$WiFiNetworkInfoImplCopyWithImpl<$Res>
    extends _$WiFiNetworkInfoCopyWithImpl<$Res, _$WiFiNetworkInfoImpl>
    implements _$$WiFiNetworkInfoImplCopyWith<$Res> {
  __$$WiFiNetworkInfoImplCopyWithImpl(
      _$WiFiNetworkInfoImpl _value, $Res Function(_$WiFiNetworkInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of WiFiNetworkInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ssid = null,
    Object? bssid = null,
    Object? signalStrength = null,
    Object? isSecure = null,
    Object? isConnected = null,
  }) {
    return _then(_$WiFiNetworkInfoImpl(
      ssid: null == ssid
          ? _value.ssid
          : ssid // ignore: cast_nullable_to_non_nullable
              as String,
      bssid: null == bssid
          ? _value.bssid
          : bssid // ignore: cast_nullable_to_non_nullable
              as String,
      signalStrength: null == signalStrength
          ? _value.signalStrength
          : signalStrength // ignore: cast_nullable_to_non_nullable
              as int,
      isSecure: null == isSecure
          ? _value.isSecure
          : isSecure // ignore: cast_nullable_to_non_nullable
              as bool,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WiFiNetworkInfoImpl extends _WiFiNetworkInfo {
  const _$WiFiNetworkInfoImpl(
      {required this.ssid,
      required this.bssid,
      required this.signalStrength,
      required this.isSecure,
      this.isConnected = false})
      : super._();

  factory _$WiFiNetworkInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WiFiNetworkInfoImplFromJson(json);

  @override
  final String ssid;
  @override
  final String bssid;
  @override
  final int signalStrength;
  @override
  final bool isSecure;
  @override
  @JsonKey()
  final bool isConnected;

  @override
  String toString() {
    return 'WiFiNetworkInfo(ssid: $ssid, bssid: $bssid, signalStrength: $signalStrength, isSecure: $isSecure, isConnected: $isConnected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WiFiNetworkInfoImpl &&
            (identical(other.ssid, ssid) || other.ssid == ssid) &&
            (identical(other.bssid, bssid) || other.bssid == bssid) &&
            (identical(other.signalStrength, signalStrength) ||
                other.signalStrength == signalStrength) &&
            (identical(other.isSecure, isSecure) ||
                other.isSecure == isSecure) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, ssid, bssid, signalStrength, isSecure, isConnected);

  /// Create a copy of WiFiNetworkInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WiFiNetworkInfoImplCopyWith<_$WiFiNetworkInfoImpl> get copyWith =>
      __$$WiFiNetworkInfoImplCopyWithImpl<_$WiFiNetworkInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WiFiNetworkInfoImplToJson(
      this,
    );
  }
}

abstract class _WiFiNetworkInfo extends WiFiNetworkInfo {
  const factory _WiFiNetworkInfo(
      {required final String ssid,
      required final String bssid,
      required final int signalStrength,
      required final bool isSecure,
      final bool isConnected}) = _$WiFiNetworkInfoImpl;
  const _WiFiNetworkInfo._() : super._();

  factory _WiFiNetworkInfo.fromJson(Map<String, dynamic> json) =
      _$WiFiNetworkInfoImpl.fromJson;

  @override
  String get ssid;
  @override
  String get bssid;
  @override
  int get signalStrength;
  @override
  bool get isSecure;
  @override
  bool get isConnected;

  /// Create a copy of WiFiNetworkInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WiFiNetworkInfoImplCopyWith<_$WiFiNetworkInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
