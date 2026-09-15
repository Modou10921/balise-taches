import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await AuthService.getProfile();
      _nomController.text = profile['nom'] ?? '';
      _prenomController.text = profile['prenom'] ?? '';
      _emailController.text = profile['email'] ?? '';
    } catch (e) {
      // silencieux : si ça échoue, les champs restent vides
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    try {
      await AuthService.updateProfile({
        'nom': _nomController.text.trim(),
        'prenom': _prenomController.text.trim(),
        'email': _emailController.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil mis à jour')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la mise à jour')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.accent)));
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
              const SizedBox(height: 24),
              Center(
                child: Column(children: const [
                  CircleAvatar(radius: 42, backgroundColor: AppColors.surface2, child: Icon(Icons.person, color: AppColors.text, size: 36)),
                ]),
              ),
              const SizedBox(height: 28),
              const Text('NOM', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              const SizedBox(height: 6),
              TextField(controller: _nomController),
              const SizedBox(height: 16),
              const Text('PRÉNOM', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              const SizedBox(height: 6),
              TextField(controller: _prenomController),
              const SizedBox(height: 16),
              const Text('EMAIL', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              const SizedBox(height: 6),
              TextField(controller: _emailController),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  child: _isSaving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.ink))
                      : const Text('Enregistrer les modifications'),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _logout,
                  child: const Text('⎋ Se déconnecter', style: TextStyle(color: AppColors.high, fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}