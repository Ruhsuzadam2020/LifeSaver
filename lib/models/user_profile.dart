class UserProfile {
  final String id;
  final String name;
  final int age;
  final String occupation;
  final List<String> goals;
  final Map<String, dynamic> preferences;
  final Map<String, dynamic> lifeAreas;
  final String email;
  final String password;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.occupation,
    required this.goals,
    required this.preferences,
    required this.lifeAreas,
    required this.email,
    required this.password,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      occupation: json['occupation'] as String,
      goals: List<String>.from(json['goals'] as List),
      preferences: json['preferences'] as Map<String, dynamic>,
      lifeAreas: json['lifeAreas'] as Map<String, dynamic>,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'occupation': occupation,
      'goals': goals,
      'preferences': preferences,
      'lifeAreas': lifeAreas,
      'email': email,
      'password': password,
    };
  }

  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? occupation,
    List<String>? goals,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? lifeAreas,
    String? email,
    String? password,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      occupation: occupation ?? this.occupation,
      goals: goals ?? this.goals,
      preferences: preferences ?? this.preferences,
      lifeAreas: lifeAreas ?? this.lifeAreas,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
} 