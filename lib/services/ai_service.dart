import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'profile_service.dart';
import 'routine_service.dart';
import 'plan_service.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  Future<String> getAIResponse(String message) async {
    try {
      // Tüm kullanıcı bilgilerini topla
      final profilePrompt = await ProfileService.getProfilePrompt();
      final routinesPrompt = await RoutineService.getRoutinesPrompt();
      final plansPrompt = await PlanService.getPlansPrompt();

      // System mesajını oluştur
      String systemMessage = 'Sen bir yaşam koçusun. Kullanıcıya yardımcı olmak için buradasın.';
      
      if (profilePrompt != null) {
        systemMessage += '\n\nKullanıcının profil bilgileri:\n$profilePrompt';
      }
      
      if (routinesPrompt != null) {
        systemMessage += '\n\n$routinesPrompt';
      }
      
      if (plansPrompt != null) {
        systemMessage += '\n\n$plansPrompt';
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiConfig.apiKey}',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini-2024-07-18',
          'messages': [
            {'role': 'system', 'content': systemMessage},
            {'role': 'user', 'content': message},
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('API Hatası (${response.statusCode}): ${errorData['error']?['message'] ?? response.body}');
      }
    } catch (e) {
      throw Exception('AI yanıtı alınamadı: $e');
    }
  }
} 