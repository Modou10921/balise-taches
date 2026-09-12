import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // initialise le stockage local, une seule fois
  runApp(const BaliseTachesApp());
}

class BaliseTachesApp extends StatelessWidget {
  const BaliseTachesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BaliseTâches',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const LoginScreen(),
    );
  }
}