import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_saver/models/user_profile.dart';

class UserService {
  static const String _userKey = 'user_data';

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(userData));
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData != null) {
      return jsonDecode(userData) as Map<String, dynamic>;
    }
    return null;
  }

  final SharedPreferences _prefs;

  UserService(this._prefs);

  Future<void> saveUserProfile(UserProfile profile) async {
    final json = profile.toJson();
    await _prefs.setString(_userKey, jsonEncode(json));
  }

  Future<UserProfile?> getUserProfile() async {
    final jsonString = _prefs.getString(_userKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserProfile.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    await saveUserProfile(profile);
  }

  Future<void> deleteUserProfile() async {
    await _prefs.remove(_userKey);
  }

  Future<bool> hasUserProfile() async {
    return _prefs.containsKey(_userKey);
  }
} 