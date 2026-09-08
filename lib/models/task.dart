import 'package:flutter/material.dart';
import '../theme.dart';

class Task {
  int? id; // null tant que l'API ne l'a pas encore créée
  String title;
  String content;
  DateTime date;
  String priority;

  Task({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.priority,
  });

  /// Construit une Task à partir de la réponse JSON de l'API.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      priority: json['priority'] ?? 'Élevée',
      date: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : DateTime.now(),
    );
  }

  /// Convertit la Task en JSON pour l'envoyer à l'API.
  /// La couleur est calculée automatiquement à partir de la priorité.
  Map<String, dynamic> toJson() {
    final color = priorityColor(priority);
    final hex = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
    return {
      'title': title,
      'content': content,
      'priority': priority,
      'color': hex,
      'dueDate': date.toIso8601String(),
    };
  }
}