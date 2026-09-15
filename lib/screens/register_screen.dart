import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_nomController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Merci de remplir tous les champs obligatoires')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.register(
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        email: _emailController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de l'inscription")),
        );
      }
    }
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
                  child: const Row(children: [
                    Icon(Icons.arrow_back, color: AppColors.muted, size: 18),
                    SizedBox(width: 8),
                    Text('Retour', style: TextStyle(color: AppColors.muted, fontSize: 13)),
                  ]),
                ),
                const SizedBox(height: 20),
                Text('Inscription', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 6),
                const Text('Créez votre compte en 30 secondes.', style: TextStyle(color: AppColors.muted, fontSize: 13)),
                const SizedBox(height: 28),
                const Text('NOM', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                const SizedBox(height: 6),
                TextField(controller: _nomController, decoration: const InputDecoration(hintText: 'Diop')),
                const SizedBox(height: 16),
                const Text('PRÉNOM', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                const SizedBox(height: 6),
                TextField(controller: _prenomController, decoration: const InputDecoration(hintText: 'Aminata')),
                const SizedBox(height: 16),
                const Text('EMAIL', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                const SizedBox(height: 6),
                TextField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(hintText: 'vous@exemple.com')),
                const SizedBox(height: 16),
                const Text("NOM D'UTILISATEUR", style: TextStyle(color: AppColors.muted, fontSize: 11)),
                const SizedBox(height: 6),
                TextField(controller: _usernameController, decoration: const InputDecoration(hintText: 'aminata')),
                const SizedBox(height: 16),
                const Text('MOT DE PASSE', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                const SizedBox(height: 6),
                TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(hintText: '••••••••')),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.ink))
                        : const Text("S'inscrire"),
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
                          TextSpan(text: "Se connecter", style: TextStyle(color: AppColors.accent, decoration: TextDecoration.underline)),
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