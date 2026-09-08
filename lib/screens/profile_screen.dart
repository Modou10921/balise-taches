import 'package:flutter/material.dart';
import '../theme.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    // Données statiques pour l'instant — remplacées par l'API au Livrable 4
    _nameController = TextEditingController(text: 'Aminata Diop');
    _phoneController = TextEditingController(text: '+221 77 000 00 00');
    _emailController = TextEditingController(text: 'aminata@exemple.com');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false, // vide toute la pile de navigation
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
              const SizedBox(height: 24),

              // Photo de profil
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surface2,
                            border: Border.all(color: AppColors.accent, width: 2),
                          ),
                          child: const Center(
                            child: Text('AD',
                                style: TextStyle(
                                    color: AppColors.text,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Sélection de photo — à venir')),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accent,
                              ),
                              child: const Icon(Icons.camera_alt,
                                  size: 14, color: AppColors.ink),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('Modifier la photo',
                        style: TextStyle(color: AppColors.text, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              const Text('NOM COMPLET', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              const SizedBox(height: 6),
              TextField(controller: _nameController),
              const SizedBox(height: 16),

              const Text('TÉLÉPHONE', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              const SizedBox(height: 6),
              TextField(controller: _phoneController),
              const SizedBox(height: 16),

              const Text('EMAIL', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              const SizedBox(height: 6),
              TextField(controller: _emailController),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profil mis à jour')),
                    );
                  },
                  child: const Text('Enregistrer les modifications'),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: GestureDetector(
                  onTap: _logout,
                  child: const Text('⎋ Se déconnecter',
                      style: TextStyle(color: AppColors.high, fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}