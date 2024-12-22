import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:async';

class WifiService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  final NetworkInfo _networkInfo = NetworkInfo();
  IOWebSocketChannel? _channel;
  
  bool _isConnected = false;
  String _currentSSID = '';
  String _error = '';
  StreamSubscription? _connectivitySubscription;

  bool get isConnected => _isConnected;
  String get currentSSID => _currentSSID;
  String get error => _error;
  bool get isWebSocketConnected => _channel != null;

  WifiService() {
    _initConnectivity();
    _setupConnectivityStream();
  }

  // 초기 연결 상태 확인
  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.wifi) {
        await _updateConnectionInfo();
      } else {
        _isConnected = false;
        _currentSSID = '';
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to get connectivity: $e';
      notifyListeners();
    }
  }

  // 연결 상태 변화 감지
  void _setupConnectivityStream() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) async {
      if (result == ConnectivityResult.wifi) {
        await _updateConnectionInfo();
      } else {
        _isConnected = false;
        _currentSSID = '';
        await disconnectWebSocket();
      }
      notifyListeners();
    });
  }

  // 현재 와이파이 정보 업데이트
  Future<void> _updateConnectionInfo() async {
    try {
      final ssid = await _networkInfo.getWifiName();
      _currentSSID = ssid ?? '';
      _isConnected = _currentSSID.isNotEmpty;
      
      // SSID에서 따옴표 제거
      if (_currentSSID.startsWith('"') && _currentSSID.endsWith('"')) {
        _currentSSID = _currentSSID.substring(1, _currentSSID.length - 1);
      }

      // 라즈베리파이 AP에 연결되었다면 웹소켓 연결 시도
      if (_isConnected && _currentSSID == 'DotMatrix_AP') {
        await connectWebSocket();
      }
    } catch (e) {
      _error = 'Failed to get WiFi name: $e';
      _isConnected = false;
      _currentSSID = '';
    }
    notifyListeners();
  }

  // 웹소켓 연결
  Future<void> connectWebSocket() async {
    try {
      _channel = IOWebSocketChannel.connect('ws://192.168.4.1:8080');
      _channel?.stream.listen(
        (message) {
          print('Received: $message');
        },
        onError: (error) {
          print('WebSocket Error: $error');
          _channel = null;
          notifyListeners();
        },
        onDone: () {
          print('WebSocket Connection Closed');
          _channel = null;
          notifyListeners();
        },
      );
    } catch (e) {
      _error = 'WebSocket connection failed: $e';
      _channel = null;
      notifyListeners();
    }
  }

  // 도형 데이터 전송
  Future<void> sendShape(String shape) async {
    if (_channel != null) {
      try {
        final data = {
          'type': 'shape',
          'shape': shape,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };
        _channel?.sink.add(data.toString());
      } catch (e) {
        _error = 'Failed to send shape: $e';
        notifyListeners();
      }
    }
  }

  // 웹소켓 연결 해제
  Future<void> disconnectWebSocket() async {
    await _channel?.sink.close();
    _channel = null;
    notifyListeners();
  }

  // 서비스 정리
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    disconnectWebSocket();
    super.dispose();
  }

  // 연결 상태 수동 새로고침
  Future<void> refreshConnection() async {
    await _initConnectivity();
  }
}