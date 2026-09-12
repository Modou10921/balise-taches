import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

class CacheService {
  static const String boxName = 'tasksBox';
  static const String tasksKey = 'tasks';

  /// Sauvegarde la liste complète des tâches dans le stockage local.
  static Future<void> saveTasks(List<Task> tasks) async {
    final box = await Hive.openBox(boxName);
    final jsonList = tasks.map((t) => {
          ...t.toJson(),
          'id': t.id, // toJson() ne contient pas l'id (l'API le génère), on l'ajoute pour le cache
        }).toList();
    await box.put(tasksKey, jsonEncode(jsonList));
  }

  /// Relit la dernière liste connue depuis le stockage local.
  static Future<List<Task>> getTasks() async {
    final box = await Hive.openBox(boxName);
    final raw = box.get(tasksKey);
    if (raw == null) return [];
    final List<dynamic> jsonList = jsonDecode(raw);
    return jsonList.map((json) => Task.fromJson(json)).toList();
  }
}