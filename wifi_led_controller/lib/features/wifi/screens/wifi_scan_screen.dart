import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_led_controller/core/services/wifi_service.dart';
import 'package:wifi_led_controller/features/wifi/models/wifi_network.dart';
import 'package:wifi_led_controller/features/wifi/widgets/wifi_network_tile.dart';

final wifiServiceProvider = Provider((ref) => WifiService());

final wifiScanProvider = FutureProvider.autoDispose<List<WiFiNetworkInfo>>((ref) async {
  final wifiService = ref.read(wifiServiceProvider);
  ref.keepAlive();
  return wifiService.scanNetworks();
});

final selectedNetworkProvider = StateProvider<WiFiNetworkInfo?>((ref) => null);
final isConnectingProvider = StateProvider<bool>((ref) => false);

class WifiScanScreen extends ConsumerStatefulWidget {
  const WifiScanScreen({super.key});

  @override
  ConsumerState<WifiScanScreen> createState() => _WifiScanScreenState();
}

class _WifiScanScreenState extends ConsumerState<WifiScanScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    final locationStatus = await Permission.locationWhenInUse.status;
    if (locationStatus.isDenied) {
      await Permission.locationWhenInUse.request();
    }
  }

  void _showPasswordDialog(WiFiNetworkInfo network) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  network.ssid,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isPasswordVisible,
              autofocus: true,
              onSubmitted: (_) => _connectToNetwork(network),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _connectToNetwork(network),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('연결'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _connectToNetwork(WiFiNetworkInfo network) async {
    final password = _passwordController.text;
    if (password.isEmpty) return;

    Navigator.pop(context);
    _passwordController.clear();

    ref.read(isConnectingProvider.notifier).state = true;
    ref.read(selectedNetworkProvider.notifier).state = network;

    try {
      final wifiService = ref.read(wifiServiceProvider);
      final success = await wifiService.connectToNetwork(
        network.ssid,
        password,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${network.ssid}에 연결되었습니다')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('연결에 실패했습니다. 비밀번호를 확인해주세요.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('오류가 발생했습니다: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        ref.read(isConnectingProvider.notifier).state = false;
      }
    }
  }

  Widget _buildNetworkList(List<WiFiNetworkInfo> networks) {
    final selectedNetwork = ref.watch(selectedNetworkProvider);
    final isConnecting = ref.watch(isConnectingProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.refresh(wifiScanProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: networks.length + 1, // +1 for header
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ESP32 장치 연결',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '주변의 ESP32 장치를 검색하여 연결합니다.\n장치의 전원이 켜져있는지 확인해주세요.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final network = networks[index - 1];
          return WifiNetworkTile(
            network: network,
            isConnected: selectedNetwork?.ssid == network.ssid && !isConnecting,
            isConnecting: selectedNetwork?.ssid == network.ssid && isConnecting,
            onTap: () {
              if (network.isSecure) {
                _showPasswordDialog(network);
              } else {
                _connectToNetwork(network);
              }
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final networksAsync = ref.watch(wifiScanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi 연결'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(wifiScanProvider),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _checkPermissions(),
        builder: (context, snapshot) {
          return networksAsync.when(
            data: _buildNetworkList,
            loading: () => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('WiFi 네트워크 검색 중...'),
                ],
              ),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '오류가 발생했습니다\n${error.toString()}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => ref.refresh(wifiScanProvider),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}