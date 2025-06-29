import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class PlanModel {
  final String text;
  final DateTime? untilDate;

  PlanModel({required this.text, this.untilDate});

  Map<String, dynamic> toJson() => {
    'text': text,
    'untilDate': untilDate?.toIso8601String(),
  };

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
    text: json['text'],
    untilDate: json['untilDate'] != null ? DateTime.parse(json['untilDate']) : null,
  );
}

class PlanService {
  static const String _plansKey = 'plans_list';
  static List<PlanModel> _currentPlans = [];

  static Future<void> addPlan(PlanModel plan) async {
    _currentPlans.add(plan);
    await _savePlans();
  }

  static Future<void> removePlan(PlanModel plan) async {
    _currentPlans.remove(plan);
    await _savePlans();
  }

  static Future<void> setPlans(List<PlanModel> plans) async {
    _currentPlans = plans;
    await _savePlans();
  }

  static Future<void> _savePlans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_plansKey, jsonEncode(_currentPlans.map((e) => e.toJson()).toList()));
    } catch (e) {
      debugPrint('Planlar kaydedilirken hata oluştu: $e');
    }
  }

  static Future<List<PlanModel>> getPlans() async {
    if (_currentPlans.isNotEmpty) return _currentPlans;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.get(_plansKey);
      if (raw is List) {
        // Eski format, temizle
        await prefs.remove(_plansKey);
        return [];
      }
      final plansJson = prefs.getString(_plansKey);
      if (plansJson == null) return [];
      final List<dynamic> decoded = jsonDecode(plansJson);
      _currentPlans = decoded.map((json) => PlanModel.fromJson(json)).toList();
      return _currentPlans;
    } catch (e) {
      debugPrint('Planlar yüklenirken hata oluştu: $e');
      return [];
    }
  }

  static Future<String?> getPlansPrompt() async {
    final plans = await getPlans();
    if (plans.isEmpty) return null;
    return '''\nMevcut Planlar:\n${plans.asMap().entries.map((entry) => '${entry.key + 1}. ${entry.value.text}${entry.value.untilDate != null ? ' (Tarihe kadar: ${entry.value.untilDate!.toLocal().toString().split(' ')[0]})' : ''}').join('\\n')}\n''';
  }
} 