// lib/services/wifi_service.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wifi_dot_test/utils/constants.dart';

class WifiService extends ChangeNotifier {
  bool _isConnected = false;
  String _error = '';

  bool get isConnected => _isConnected;
  String get error => _error;

  // HTTP 요청 보내기
  Future<void> sendShape(String shape) async {
    try {
      String command;
      switch (shape) {
        case 'circle':
          command = 'Ci';
          break;
        case 'triangle':
          command = 'Tr';
          break;
        case 'square':
          command = 'Sq';
          break;
        default:
          throw Exception('Unknown shape');
      }

      print('Sending shape command: $command'); // 로그 추가
      print('URL: http://${AppConstants.raspberryPiAddress}/$command'); // 로그 추가

      final response = await http.get(
        Uri.parse('http://${AppConstants.raspberryPiAddress}/$command'),
      );

      print('Response status: ${response.statusCode}'); // 로그 추가
      print('Response body: ${response.body}'); // 로그 추가

      if (response.statusCode == 200) {
        _isConnected = true;
        _error = '';
      } else {
        throw Exception('Failed to send shape');
      }
    } catch (e) {
      print('Error sending shape: $e'); // 로그 추가
      _isConnected = false;
      _error = e.toString();
    }
    notifyListeners();
  }

  // 연결 상태 확인
  Future<void> checkConnection() async {
    try {
      print('Checking connection to: http://${AppConstants.raspberryPiAddress}'); // 로그 추가

      final response = await http.get(
        Uri.parse('http://${AppConstants.raspberryPiAddress}'),
      );

      print('Connection check response status: ${response.statusCode}'); // 로그 추가
      print('Connection check response body: ${response.body}'); // 로그 추가

      _isConnected = response.statusCode == 200;
      _error = '';
    } catch (e) {
      print('Connection check error: $e'); // 로그 추가
      _isConnected = false;
      _error = e.toString();
    }
    notifyListeners();
  }
}