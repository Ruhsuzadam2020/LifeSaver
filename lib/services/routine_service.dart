import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class RoutineModel {
  final String text;
  final String? frequency;

  RoutineModel({required this.text, this.frequency});

  Map<String, dynamic> toJson() => {
    'text': text,
    'frequency': frequency,
  };

  factory RoutineModel.fromJson(Map<String, dynamic> json) => RoutineModel(
    text: json['text'],
    frequency: json['frequency'],
  );
}

class RoutineService {
  static const String _routinesKey = 'routines_list';
  static List<RoutineModel> _currentRoutines = [];

  static Future<void> addRoutine(RoutineModel routine) async {
    _currentRoutines.add(routine);
    await _saveRoutines();
  }

  static Future<void> removeRoutine(RoutineModel routine) async {
    _currentRoutines.remove(routine);
    await _saveRoutines();
  }

  static Future<void> setRoutines(List<RoutineModel> routines) async {
    _currentRoutines = routines;
    await _saveRoutines();
  }

  static Future<void> _saveRoutines() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_routinesKey, jsonEncode(_currentRoutines.map((e) => e.toJson()).toList()));
    } catch (e) {
      debugPrint('Rutinler kaydedilirken hata oluştu: $e');
    }
  }

  static Future<List<RoutineModel>> getRoutines() async {
    if (_currentRoutines.isNotEmpty) return _currentRoutines;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.get(_routinesKey);
      if (raw is List) {
        // Eski format, temizle
        await prefs.remove(_routinesKey);
        return [];
      }
      final routinesJson = prefs.getString(_routinesKey);
      if (routinesJson == null) return [];
      final List<dynamic> decoded = jsonDecode(routinesJson);
      _currentRoutines = decoded.map((json) => RoutineModel.fromJson(json)).toList();
      return _currentRoutines;
    } catch (e) {
      debugPrint('Rutinler yüklenirken hata oluştu: $e');
      return [];
    }
  }

  static Future<String?> getRoutinesPrompt() async {
    final routines = await getRoutines();
    if (routines.isEmpty) return null;
    return '''\nMevcut Rutinler:\n${routines.asMap().entries.map((entry) => '${entry.key + 1}. ${entry.value.text}${entry.value.frequency != null ? ' (Sıklık: ${entry.value.frequency})' : ''}').join('\\n')}\n''';
  }
} 