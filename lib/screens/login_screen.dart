import 'package:flutter/material.dart';
import '../theme.dart';
import 'register_screen.dart';
import 'task_list_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'BALISETÂCHES',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text('Connexion', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 6),
              const Text(
                "Retrouvez vos tâches en un instant.",
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 32),

              const Text('EMAIL OU NOM D\'UTILISATEUR', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              const SizedBox(height: 6),
              const TextField(
                decoration: InputDecoration(hintText: 'vous@exemple.com'),
              ),
              const SizedBox(height: 16),

              const Text('MOT DE PASSE', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              const SizedBox(height: 6),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(hintText: '••••••••'),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const TaskListScreen()),
                    );
                  },
                  child: const Text('Se connecter'),
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: AppColors.muted, fontSize: 13),
                      children: [
                        TextSpan(text: "Pas encore de compte ? "),
                        TextSpan(
                          text: "Créer un compte",
                          style: TextStyle(color: AppColors.accent, decoration: TextDecoration.underline),
                        ),
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