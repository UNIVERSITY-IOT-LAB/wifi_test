// lib/services/wifi_service.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class WifiService extends ChangeNotifier {
  bool _isConnected = false;
  String _error = '';

  bool get isConnected => _isConnected;
  String get error => _error;

  Future<void> checkConnection() async {
    try {
      // URL 형식 수정
      final url = Uri.parse('http://192.168.10.102:80');
      print('Checking connection to: $url');

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('Connection timed out');
          throw TimeoutException('Connection timed out');
        },
      );

      print('Response status: ${response.statusCode}');
      _isConnected = response.statusCode == 200;
      _error = '';
    } catch (e) {
      print('Connection check error: $e');
      _isConnected = false;
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<void> sendShape(String shape) async {
    try {
      String command;
      switch (shape) {
        case 'Ci':
          command = 'Ci';
          break;
        case 'Tr':
          command = 'Tr';
          break;
        case 'Sq':
          command = 'Sq';
          break;
        default:
          throw Exception('Unknown shape');
      }

      // URL 형식 수정
      final url = Uri.parse('http://192.168.10.102:80/$command');
      print('Sending request to: $url');

      final response = await http.get(url);
      print('Response received: ${response.statusCode}');

      if (response.statusCode == 200) {
        _isConnected = true;
        _error = '';
      } else {
        throw Exception('Failed to send shape');
      }
    } catch (e) {
      print('Error sending shape: $e');
      _isConnected = false;
      _error = e.toString();
    }
    notifyListeners();
  }
}