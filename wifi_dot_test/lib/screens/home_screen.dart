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
          _buildConnectionStatus(context),
        ],
      ),
      body: Consumer<WifiService>(
        builder: (context, wifiService, child) {
          if (!wifiService.isConnected) {
            return _buildConnectionError(context, wifiService);
          }
          return _buildShapeControls(context, wifiService);
        },
      ),
    );
  }

  Widget _buildConnectionStatus(BuildContext context) {
    return Consumer<WifiService>(
      builder: (context, wifiService, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                wifiService.isConnected ? Icons.check_circle : Icons.error,
                color: wifiService.isConnected ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                wifiService.isConnected ? '연결됨' : '연결 안됨',
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

  Widget _buildConnectionError(BuildContext context, WifiService wifiService) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            wifiService.error.isEmpty 
                ? '연결 끊김' 
                : '오류: ${wifiService.error}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            // reconnect 대신 checkConnection 사용
            onPressed: () => wifiService.checkConnection(),
            child: const Text('다시 연결'),
          ),
        ],
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
              _buildShapeButton(context, wifiService, 'Ci', Icons.circle_outlined, '원'),
              _buildShapeButton(context, wifiService, 'Tr', Icons.change_history, '삼각형'),
              _buildShapeButton(context, wifiService, 'Sq', Icons.square_outlined, '사각형'),
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