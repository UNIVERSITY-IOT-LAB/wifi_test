import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wifi_led_controller/features/wifi/models/wifi_network.dart';
import 'package:wifi_led_controller/features/wifi/widgets/wifi_network_tile.dart';
import 'package:wifi_led_controller/core/services/wifi_service.dart';

final wifiServiceProvider = Provider((ref) => WifiService());

final wifiNetworksProvider = FutureProvider<List<WifiNetwork>>((ref) async {
  final wifiService = ref.read(wifiServiceProvider);
  await wifiService.checkPermissions();
  return wifiService.scanNetworks();
});

class WifiScanScreen extends ConsumerWidget {
  const WifiScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networksAsync = ref.watch(wifiNetworksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi 네트워크'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(wifiNetworksProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ESP32 연결하기',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ESP32 기기의 WiFi 네트워크를 선택하여 연결해주세요.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: networksAsync.when(
              data: (networks) => ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: networks.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final network = networks[index];
                  return WifiNetworkTile(
                    network: network,
                    onTap: () => _showPasswordDialog(context, network),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: ${error.toString()}'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPasswordDialog(BuildContext context, WifiNetwork network) async {
    final passwordController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${network.ssid}에 연결'),
        content: TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: '비밀번호',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement connection logic
              Navigator.pop(context);
            },
            child: const Text('연결'),
          ),
        ],
      ),
    );
  }
}