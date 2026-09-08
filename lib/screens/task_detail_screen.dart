import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/task.dart';
import '../services/api_service.dart';
import 'add_edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  Future<void> _delete(BuildContext context) async {
    try {
      await ApiService.deleteTask(task.id!);
      if (context.mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la suppression')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = priorityColor(task.priority);

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
                    Text('Retour à la liste', style: TextStyle(color: AppColors.muted, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                child: Text('● Priorité ${task.priority.toLowerCase()}',
                    style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 14),
              Text(task.title,
                  style: const TextStyle(color: AppColors.text, fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                '📅 ${task.date.day}/${task.date.month}/${task.date.year} · ${task.date.hour.toString().padLeft(2, '0')}:${task.date.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.line),
                ),
                child: Text(task.content, style: const TextStyle(color: AppColors.text, fontSize: 13, height: 1.6)),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final updated = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
                        );
                        if (updated == true && context.mounted) {
                          Navigator.of(context).pop(true);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.line),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      icon: const Icon(Icons.edit, size: 16, color: AppColors.text),
                      label: const Text('Modifier', style: TextStyle(color: AppColors.text)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _delete(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.high),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      icon: const Icon(Icons.delete, size: 16, color: AppColors.high),
                      label: const Text('Supprimer', style: TextStyle(color: AppColors.high)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Partage — fonctionnalité à venir')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.line),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  icon: const Icon(Icons.share, size: 16, color: AppColors.text),
                  label: const Text('Partager', style: TextStyle(color: AppColors.text)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}