import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:app_settings/app_settings.dart';
import 'dart:io' show Platform;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WiFi Connect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WifiScreen(),
    );
  }
}

class WifiScreen extends StatefulWidget {
  const WifiScreen({super.key});

  @override
  State<WifiScreen> createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {
  List<WifiNetwork> accessPoints = [];
  String? connectedWifi;
  final _networkInfo = NetworkInfo();
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _checkPermissions();
    }
    _updateConnectedWifi();
  }

  Future<void> _updateConnectedWifi() async {
    try {
      final connected = await _networkInfo.getWifiName();
      setState(() {
        connectedWifi = connected?.replaceAll('"', '').replaceAll('<', '').replaceAll('>', '');
      });
      debugPrint('Connected WiFi: $connectedWifi');
    } catch (e) {
      debugPrint('Error getting connected WiFi: $e');
    }
  }

  Future<void> _checkPermissions() async {
    if (!await Permission.location.isGranted) {
      await Permission.location.request();
    }
    if (!await Permission.nearbyWifiDevices.isGranted) {
      await Permission.nearbyWifiDevices.request();
    }
    _scanWifi();
  }

  Future<void> _scanWifi() async {
    setState(() {
      isScanning = true;
    });

    try {
      final results = await WiFiForIoTPlugin.loadWifiList();
      setState(() {
        accessPoints = results;
      });
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() {
        isScanning = false;
      });
    }
  }

  void _openWiFiSettings() async {
    if (Platform.isIOS) {
      const url = 'App-Prefs:root=WIFI';
      try {
        await launchUrlString(url);
      } catch (e) {
        await AppSettings.openAppSettings(type: AppSettingsType.wifi);
      }
    }
  }

  void _connectToWifi(WifiNetwork ap) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connect to ${ap.ssid}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    try {
                      final result = await WiFiForIoTPlugin.connect(
                        ap.ssid!,
                        password: controller.text,
                        security: NetworkSecurity.WPA,
                      );
                      if (result) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Connected to ${ap.ssid}')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to connect')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                    await _updateConnectedWifi();
                  },
                  child: const Text('Connect'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('WiFi Status'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.wifi, color: Colors.blue),
                  title: Text(connectedWifi ?? 'Not connected'),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _openWiFiSettings,
                child: const Text('Open WiFi Settings'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi Networks'),
        actions: [
          if (isScanning)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _scanWifi,
            ),
        ],
      ),
      body: Column(
        children: [
          if (connectedWifi != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.wifi_lock, color: Colors.green),
                  title: Text('Connected to: $connectedWifi'),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: accessPoints.length,
              itemBuilder: (context, index) {
                final ap = accessPoints[index];
                final isConnected = connectedWifi == ap.ssid;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: Icon(
                      Icons.wifi,
                      color: isConnected ? Colors.blue : null,
                    ),
                    title: Text(ap.ssid!),
                    subtitle: Text('Signal: ${ap.level} dBm'),
                    trailing: isConnected
                        ? const Icon(Icons.check, color: Colors.green)
                        : IconButton(
                            icon: const Icon(Icons.login),
                            onPressed: () => _connectToWifi(ap),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}