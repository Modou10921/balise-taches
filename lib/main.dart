import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme.dart';
import 'screens/login_screen.dart';
import 'screens/task_list_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
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
      home: const _StartupGate(),
    );
  }
}

/// Décide au démarrage : déjà connecté → liste des tâches, sinon → connexion.
class _StartupGate extends StatelessWidget {
  const _StartupGate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
          );
        }
        return snapshot.data == true ? const TaskListScreen() : const LoginScreen();
      },
    );
  }
}