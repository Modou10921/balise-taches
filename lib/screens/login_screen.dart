import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'task_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await AuthService.login(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const TaskListScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _error = 'Identifiants incorrects';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('BALISETÂCHES',
                  style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
              const SizedBox(height: 8),
              Text('Connexion', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 6),
              const Text("Retrouvez vos tâches en un instant.", style: TextStyle(color: AppColors.muted, fontSize: 13)),
              const SizedBox(height: 32),
              const Text("NOM D'UTILISATEUR", style: TextStyle(color: AppColors.muted, fontSize: 11)),
              const SizedBox(height: 6),
              TextField(controller: _usernameController, decoration: const InputDecoration(hintText: 'aminata')),
              const SizedBox(height: 16),
              const Text('MOT DE PASSE', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              const SizedBox(height: 6),
              TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(hintText: '••••••••')),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(color: AppColors.high, fontSize: 12)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.ink))
                      : const Text('Se connecter'),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen())),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: AppColors.muted, fontSize: 13),
                      children: [
                        TextSpan(text: "Pas encore de compte ? "),
                        TextSpan(text: "Créer un compte", style: TextStyle(color: AppColors.accent, decoration: TextDecoration.underline)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}