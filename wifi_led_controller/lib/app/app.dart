import 'package:flutter/material.dart';
import 'package:wifi_led_controller/app/theme.dart';
import 'package:wifi_led_controller/features/wifi/screens/wifi_scan_screen.dart';

class WifiLedApp extends StatelessWidget {
  const WifiLedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WiFi LED Controller',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const WifiScanScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}