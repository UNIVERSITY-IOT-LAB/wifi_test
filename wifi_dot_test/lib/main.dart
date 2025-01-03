import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_dot_test/services/wifi_service.dart';
import 'package:wifi_dot_test/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WifiService(),
      child: MaterialApp(
        title: 'Dot Matrix Control',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}