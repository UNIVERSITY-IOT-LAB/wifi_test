import 'package:flutter/material.dart';
import 'package:wifi_led_controller/features/wifi/models/wifi_network.dart';

class WifiNetworkTile extends StatelessWidget {
  final WifiNetwork network;
  final VoidCallback onTap;
  final bool isConnected;
  final bool isConnecting;

  const WifiNetworkTile({
    super.key,
    required this.network,
    required this.onTap,
    this.isConnected = false,
    this.isConnecting = false,
  });

  Color _getSignalColor(BuildContext context, int strength) {
    final colorScheme = Theme.of(context).colorScheme;
    if (strength >= -50) {
      return colorScheme.primary;
    } else if (strength >= -60) {
      return colorScheme.primary.withOpacity(0.8);
    } else if (strength >= -70) {
      return colorScheme.primary.withOpacity(0.6);
    } else {
      return colorScheme.primary.withOpacity(0.4);
    }
  }

  Widget _buildSignalIndicator(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _getSignalColor(context, network.signalStrength).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            _getSignalIcon(),
            color: _getSignalColor(context, network.signalStrength),
            size: 20,
          ),
          if (isConnecting)
            CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }

  IconData _getSignalIcon() {
    if (network.signalStrength >= -50) {
      return Icons.wifi;
    } else if (network.signalStrength >= -60) {
      return Icons.network_wifi_3_bar;
    } else if (network.signalStrength >= -70) {
      return Icons.network_wifi_2_bar;
    } else {
      return Icons.network_wifi_1_bar;
    }
  }

  Widget _buildNetworkInfo(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  network.ssid,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: isConnected ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isConnected)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '연결됨',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                network.isSecure ? Icons.lock_outline : Icons.lock_open_outlined,
                size: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                network.isSecure ? '보안됨' : '보안되지 않음',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.signal_cellular_alt,
                size: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                '${network.signalStrength} dBm',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: isConnecting ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildSignalIndicator(context),
              const SizedBox(width: 12),
              _buildNetworkInfo(context),
              if (!isConnected && !isConnecting)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}