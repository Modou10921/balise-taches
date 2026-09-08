import 'package:flutter/material.dart';
import '../theme.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Merci de remplir tous les champs obligatoires')),
      );
      return;
    }

    // Pour l'instant : simulation. L'inscription réelle sera branchée sur
    // l'API au Livrable 4 (Authentification).
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back, color: AppColors.muted, size: 18),
                      SizedBox(width: 8),
                      Text('Retour', style: TextStyle(color: AppColors.muted, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Text('Inscription', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 6),
                const Text('Créez votre compte en 30 secondes.',
                    style: TextStyle(color: AppColors.muted, fontSize: 13)),
                const SizedBox(height: 28),

                const Text('NOM COMPLET', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                const SizedBox(height: 6),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'Aminata Diop'),
                ),
                const SizedBox(height: 16),

                const Text('TÉLÉPHONE', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                const SizedBox(height: 6),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(hintText: '+221 77 000 00 00'),
                ),
                const SizedBox(height: 16),

                const Text('EMAIL', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                const SizedBox(height: 6),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'vous@exemple.com'),
                ),
                const SizedBox(height: 16),

                const Text('MOT DE PASSE', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                const SizedBox(height: 6),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: '••••••••'),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _register,
                    child: const Text("S'inscrire"),
                  ),
                ),
                const SizedBox(height: 16),

                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: AppColors.muted, fontSize: 13),
                        children: [
                          TextSpan(text: "Déjà inscrit ? "),
                          TextSpan(
                            text: "Se connecter",
                            style: TextStyle(
                                color: AppColors.accent,
                                decoration: TextDecoration.underline),
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
      ),
    );
  }
}