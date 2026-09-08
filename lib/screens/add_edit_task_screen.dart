import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late DateTime _selectedDate;
  late String _selectedPriority;
  bool _isSaving = false;

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _contentController = TextEditingController(text: widget.task?.content ?? '');
    _selectedDate = widget.task?.date ?? DateTime.now();
    _selectedPriority = widget.task?.priority ?? 'Élevée';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_selectedDate));
    if (time == null) return;

    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le titre est obligatoire')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final task = Task(
      id: widget.task?.id,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      date: _selectedDate,
      priority: _selectedPriority,
    );

    try {
      if (isEditing) {
        await ApiService.updateTask(widget.task!.id!, task);
      } else {
        await ApiService.createTask(task);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur : impossible d'enregistrer la tâche")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Row(
                    children: [
                      Icon(Icons.close, color: AppColors.muted, size: 18),
                      SizedBox(width: 8),
                      Text('Annuler', style: TextStyle(color: AppColors.muted, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isEditing ? 'Modifier la tâche' : 'Nouvelle tâche',
                  style: const TextStyle(color: AppColors.text, fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                const Text('Ajoutez les détails ci-dessous.', style: TextStyle(color: AppColors.muted, fontSize: 13)),
                const SizedBox(height: 24),
                const Text('TITRE', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                const SizedBox(height: 6),
                TextField(controller: _titleController, decoration: const InputDecoration(hintText: 'Ex : Appeler le fournisseur')),
                const SizedBox(height: 16),
                const Text('CONTENU', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                const SizedBox(height: 6),
                TextField(controller: _contentController, maxLines: 4, decoration: const InputDecoration(hintText: 'Détails de la tâche...')),
                const SizedBox(height: 16),
                const Text('DATE ET HEURE', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _pickDateTime,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: AppColors.muted),
                        const SizedBox(width: 10),
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} — '
                          '${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(color: AppColors.text, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('PRIORITÉ', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildPriorityOption('Élevée', AppColors.high),
                    const SizedBox(width: 8),
                    _buildPriorityOption('Moyenne', AppColors.med),
                    const SizedBox(width: 8),
                    _buildPriorityOption('Basse', AppColors.low),
                  ],
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.ink),
                          )
                        : const Text('Enregistrer'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityOption(String label, Color color) {
    final isSelected = _selectedPriority == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPriority = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? color : AppColors.line),
            color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          ),
          child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: isSelected ? color : AppColors.muted, fontSize: 12)),
        ),
      ),
    );
  }
}