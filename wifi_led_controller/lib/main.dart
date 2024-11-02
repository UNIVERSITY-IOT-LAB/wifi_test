import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wifi_led_controller/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 권한 요청 등 초기화 로직을 여기에 추가할 수 있습니다
  
  runApp(
    const ProviderScope(
      child: WifiLedApp(),
    ),
  );
}