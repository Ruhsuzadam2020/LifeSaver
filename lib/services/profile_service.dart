import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';
import 'package:flutter/foundation.dart';

class ProfileService {
  static const String _profileKey = 'user_profile';
  static ProfileModel? _currentProfile;

  static Future<void> setProfile(ProfileModel profile) async {
    _currentProfile = profile;
    final prefs = await SharedPreferences.getInstance();
    final profileJson = jsonEncode({
      'name': profile.name,
      'birthDate': profile.birthDate,
      'zodiacSign': profile.zodiacSign,
      'personality': profile.personality,
      'regrets': profile.regrets,
      'dreams': profile.dreams,
      'socialLife': profile.socialLife,
      'economicStatus': profile.economicStatus,
      'style': profile.style,
      'educationLevel': profile.educationLevel,
      'school': profile.school,
      'department': profile.department,
      'academicAchievements': profile.academicAchievements,
      'height': profile.height,
      'weight': profile.weight,
      'bloodType': profile.bloodType,
      'chronicDiseases': profile.chronicDiseases,
      'medications': profile.medications,
      'allergies': profile.allergies,
    });
    await prefs.setString(_profileKey, profileJson);
  }

  static Future<ProfileModel?> getProfile() async {
    if (_currentProfile != null) return _currentProfile;

    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_profileKey);
    
    if (profileJson == null) return null;

    try {
      final Map<String, dynamic> data = jsonDecode(profileJson);
      _currentProfile = ProfileModel(
        name: data['name'] ?? '',
        birthDate: data['birthDate'] ?? '',
        zodiacSign: data['zodiacSign'] ?? '',
        personality: data['personality'] ?? '',
        regrets: List<String>.from(data['regrets'] ?? []),
        dreams: List<String>.from(data['dreams'] ?? []),
        socialLife: data['socialLife'] ?? '',
        economicStatus: data['economicStatus'] ?? '',
        style: data['style'] ?? '',
        educationLevel: data['educationLevel'] ?? '',
        school: data['school'] ?? '',
        department: data['department'] ?? '',
        academicAchievements: data['academicAchievements'] ?? '',
        height: data['height'] ?? '',
        weight: data['weight'] ?? '',
        bloodType: data['bloodType'] ?? '',
        chronicDiseases: data['chronicDiseases'] ?? '',
        medications: data['medications'] ?? '',
        allergies: data['allergies'] ?? '',
      );
      return _currentProfile;
    } catch (e) {
      debugPrint('Profil yüklenirken hata oluştu: $e');
      return null;
    }
  }

  static Future<String?> getProfilePrompt() async {
    final profile = await getProfile();
    return profile?.toPrompt();
  }
} 