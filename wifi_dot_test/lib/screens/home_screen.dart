import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_dot_test/services/wifi_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도트 매트릭스 컨트롤'),
        actions: [
          _buildWifiStatus(context),  // context 추가
        ],
      ),
      body: Consumer<WifiService>(
        builder: (context, wifiService, child) {
          if (!wifiService.isConnected) {
            return _buildConnectionGuide(context);  // context 추가
          }
          if (wifiService.currentSSID != 'DotMatrix_AP') {
            return _buildWrongNetworkMessage(context);  // context 추가
          }
          return _buildShapeControls(context, wifiService);
        },
      ),
    );
  }

  Widget _buildWifiStatus(BuildContext context) {  // context 매개변수 추가
    return Consumer<WifiService>(
      builder: (context, wifiService, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                wifiService.isConnected ? Icons.wifi : Icons.wifi_off,
                color: wifiService.isConnected ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                wifiService.isConnected ? wifiService.currentSSID : '연결 안됨',
                style: TextStyle(
                  color: wifiService.isConnected ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConnectionGuide(BuildContext context) {  // context 매개변수 추가
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
            const SizedBox(height: 24),
            const Text(
              '와이파이 연결이 필요합니다',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. 설정 앱을 열어주세요\n'
              '2. Wi-Fi 설정으로 이동해주세요\n'
              '3. "DotMatrix_AP" 네트워크를 찾아 연결해주세요\n'
              '4. 앱으로 돌아와주세요',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Provider.of<WifiService>(context, listen: false).refreshConnection();
              },
              child: const Text('연결 상태 새로고침'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWrongNetworkMessage(BuildContext context) {  // context 매개변수 추가
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // wifi_alert를 network_check로 변경
            const Icon(Icons.network_check, size: 64, color: Colors.orange),
            const SizedBox(height: 24),
            const Text(
              '잘못된 네트워크에 연결됨',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '"DotMatrix_AP" 네트워크에 연결해주세요',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShapeControls(BuildContext context, WifiService wifiService) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '표시할 도형을 선택하세요',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _buildShapeButton(context, wifiService, 'circle', Icons.circle_outlined, '원'),
              _buildShapeButton(context, wifiService, 'triangle', Icons.change_history, '삼각형'),
              _buildShapeButton(context, wifiService, 'square', Icons.square_outlined, '사각형'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShapeButton(
    BuildContext context, 
    WifiService wifiService, 
    String shape, 
    IconData icon,
    String label,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () async {
              try {
                await wifiService.sendShape(shape);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$label 전송 완료')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('전송 실패: $e')),
                  );
                }
              }
            },
            child: Icon(icon, size: 48),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}