
import 'package:network_info_plus/network_info_plus.dart';

class WifiService {
  static final _instance = WifiService._();
  final _networkInfo = NetworkInfo();
  
  WifiService._();
  static WifiService get instance => _instance;

  Future<String?> getConnectedWifi() async {
    return await _networkInfo.getWifiName();
  }
}