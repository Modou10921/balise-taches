import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  // Sur Chrome/web : localhost fonctionne.
  // Sur un émulateur Android : remplacez par 10.0.2.2
  static const String baseUrl = 'https://glorious-space-fiesta-gxv7v4xrw54h9j4p-3000.app.github.dev';

  static Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/task'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Task.fromJson(json)).toList();
    }
    throw Exception('Erreur lors du chargement des tâches');
  }

  static Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/task'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );
    if (response.statusCode == 201) {
      return Task.fromJson(jsonDecode(response.body));
    }
    throw Exception('Erreur lors de la création de la tâche');
  }

  static Future<Task> updateTask(int id, Task task) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/task/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );
    if (response.statusCode == 200) {
      return Task.fromJson(jsonDecode(response.body));
    }
    throw Exception('Erreur lors de la modification de la tâche');
  }

  static Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/task/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erreur lors de la suppression de la tâche');
    }
  }
}