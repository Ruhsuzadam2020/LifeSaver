import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class ChatSession {
  final String id;
  final String title;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime lastModified;

  ChatSession({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.lastModified,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
    };
  }

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      title: json['title'],
      messages: (json['messages'] as List)
          .map((msg) => ChatMessage.fromJson(msg))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      lastModified: DateTime.parse(json['lastModified']),
    );
  }
}

class ChatService {
  static const String _sessionsKey = 'chat_sessions';
  static const String _currentSessionKey = 'current_session_id';
  static Map<String, ChatSession> _sessions = {};
  static String? _currentSessionId;
  static List<ChatMessage> _currentMessages = [];

  // Mevcut sohbeti al
  static Future<List<ChatMessage>> getMessages() async {
    if (_currentSessionId == null) {
      await _loadCurrentSession();
    }
    return _currentMessages;
  }

  // Mesaj kaydet
  static Future<void> saveMessage(ChatMessage message) async {
    if (_currentSessionId == null) {
      await _loadCurrentSession();
    }
    
    _currentMessages.add(message);
    await _saveCurrentSession();
  }

  // Yeni sohbet oluştur
  static Future<void> createNewSession() async {
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    final newSession = ChatSession(
      id: sessionId,
      title: 'Yeni Sohbet',
      messages: [],
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
    );

    _sessions[sessionId] = newSession;
    _currentSessionId = sessionId;
    _currentMessages = [];
    
    await _saveSessions();
    await _saveCurrentSessionId();
  }

  // Belirli bir sohbete geç
  static Future<void> switchToSession(String sessionId) async {
    if (_sessions.containsKey(sessionId)) {
      _currentSessionId = sessionId;
      _currentMessages = List.from(_sessions[sessionId]!.messages);
      await _saveCurrentSessionId();
    }
  }

  // Sohbet başlığını güncelle
  static Future<void> updateSessionTitle(String sessionId, String newTitle) async {
    if (_sessions.containsKey(sessionId)) {
      final session = _sessions[sessionId]!;
      _sessions[sessionId] = ChatSession(
        id: session.id,
        title: newTitle,
        messages: session.messages,
        createdAt: session.createdAt,
        lastModified: DateTime.now(),
      );
      await _saveSessions();
    }
  }

  // Sohbeti sil
  static Future<void> deleteSession(String sessionId) async {
    _sessions.remove(sessionId);
    if (_currentSessionId == sessionId) {
      _currentSessionId = null;
      _currentMessages = [];
    }
    await _saveSessions();
    await _saveCurrentSessionId();
  }

  // Tüm sohbetleri al
  static Future<List<ChatSession>> getAllSessions() async {
    await _loadSessions();
    return _sessions.values.toList()
      ..sort((a, b) => b.lastModified.compareTo(a.lastModified));
  }

  // Mevcut sohbet ID'sini al
  static String? getCurrentSessionId() => _currentSessionId;

  // Sohbetleri SharedPreferences'a kaydet
  static Future<void> _saveSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionsJson = _sessions.values.map((session) => session.toJson()).toList();
      await prefs.setString(_sessionsKey, jsonEncode(sessionsJson));
    } catch (e) {
      debugPrint('Sohbetler kaydedilirken hata oluştu: $e');
    }
  }

  // Sohbetleri SharedPreferences'tan yükle
  static Future<void> _loadSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionsJson = prefs.getString(_sessionsKey);
      
      if (sessionsJson != null) {
        final List<dynamic> decoded = jsonDecode(sessionsJson);
        _sessions = Map.fromEntries(
          decoded.map((json) {
            final session = ChatSession.fromJson(json);
            return MapEntry(session.id, session);
          }),
        );
      }
    } catch (e) {
      debugPrint('Sohbetler yüklenirken hata oluştu: $e');
    }
  }

  // Mevcut sohbet ID'sini kaydet
  static Future<void> _saveCurrentSessionId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_currentSessionId != null) {
        await prefs.setString(_currentSessionKey, _currentSessionId!);
      } else {
        await prefs.remove(_currentSessionKey);
      }
    } catch (e) {
      debugPrint('Mevcut sohbet ID kaydedilirken hata oluştu: $e');
    }
  }

  // Mevcut sohbet ID'sini yükle
  static Future<void> _loadCurrentSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentSessionId = prefs.getString(_currentSessionKey);
      
      if (_currentSessionId != null && _sessions.containsKey(_currentSessionId)) {
        _currentMessages = List.from(_sessions[_currentSessionId]!.messages);
      } else {
        // Eğer mevcut sohbet yoksa yeni bir tane oluştur
        await createNewSession();
      }
    } catch (e) {
      debugPrint('Mevcut sohbet yüklenirken hata oluştu: $e');
      await createNewSession();
    }
  }

  // Mevcut sohbeti kaydet
  static Future<void> _saveCurrentSession() async {
    if (_currentSessionId != null) {
      _sessions[_currentSessionId!] = ChatSession(
        id: _currentSessionId!,
        title: _sessions[_currentSessionId!]?.title ?? 'Yeni Sohbet',
        messages: List.from(_currentMessages),
        createdAt: _sessions[_currentSessionId!]?.createdAt ?? DateTime.now(),
        lastModified: DateTime.now(),
      );
      await _saveSessions();
    }
  }

  // Geriye uyumluluk için eski metodlar
  static Future<void> saveMessages(List<ChatMessage> messages) async {
    _currentMessages = messages;
    await _saveCurrentSession();
  }

  static Future<void> clearMessages() async {
    await createNewSession();
  }
} 