import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/task.dart';
import '../services/api_service.dart';
import 'task_detail_screen.dart';
import 'add_edit_task_screen.dart';
import 'profile_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> _tasks = [];
  bool _isLoading = true;
  String? _error;

  String _searchQuery = '';
  String? _activeFilter;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final tasks = await ApiService.getTasks();
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Impossible de charger les tâches.\nVérifiez que le serveur (task_apis) est démarré.";
        _isLoading = false;
      });
    }
  }

  List<Task> get _filteredTasks {
    return _tasks.where((t) {
      final matchesSearch = t.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _activeFilter == null || t.priority == _activeFilter;
      return matchesSearch && matchesFilter;
    }).toList();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('BONJOUR, AMINATA',
                          style: TextStyle(color: AppColors.accent, fontSize: 11, letterSpacing: 1)),
                      SizedBox(height: 4),
                      Text('Vos tâches',
                          style: TextStyle(color: AppColors.text, fontSize: 22, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      );
                    },
                    child: const CircleAvatar(
                      backgroundColor: AppColors.surface2,
                      child: Text('AD', style: TextStyle(color: AppColors.text, fontSize: 13)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Rechercher une tâche...',
                  hintStyle: TextStyle(color: AppColors.muted),
                  prefixIcon: Icon(Icons.search, color: AppColors.muted),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                children: [
                  _buildFilterChip('Élevée', AppColors.high),
                  _buildFilterChip('Moyenne', AppColors.med),
                  _buildFilterChip('Basse', AppColors.low),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.ink,
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
          );
          _loadTasks(); // on recharge depuis l'API après un ajout
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.accent));
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: const TextStyle(color: AppColors.muted), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _loadTasks, child: const Text('Réessayer')),
          ],
        ),
      );
    }
    if (_filteredTasks.isEmpty) {
      return const Center(
        child: Text('Aucune tâche trouvée', style: TextStyle(color: AppColors.muted)),
      );
    }
    return ListView.builder(
      itemCount: _filteredTasks.length,
      itemBuilder: (context, index) => _buildTaskCard(_filteredTasks[index]),
    );
  }

  Widget _buildFilterChip(String label, Color color) {
    final isSelected = _activeFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = isSelected ? null : label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
          color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
        ),
        child: Text('● $label', style: TextStyle(color: color, fontSize: 11)),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)),
        );
        _loadTasks(); // on recharge après retour (modif ou suppression éventuelle)
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              width: 10,
              height: 10,
              decoration: BoxDecoration(shape: BoxShape.circle, color: priorityColor(task.priority)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title,
                      style: const TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(
                    '${task.date.day}/${task.date.month} · ${task.priority.toUpperCase()}',
                    style: const TextStyle(color: AppColors.muted, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}