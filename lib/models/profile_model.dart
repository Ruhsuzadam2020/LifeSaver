class ProfileModel {
  // Kişisel Bilgiler
  final String name;
  final String birthDate;
  final String zodiacSign;
  final String personality;
  final List<String> regrets;
  final List<String> dreams;
  // Sosyal Bilgiler
  final String socialLife;
  // Ekonomik Bilgiler
  final String economicStatus;
  final String style;
  // Akademik Bilgiler
  final String educationLevel;
  final String school;
  final String department;
  final String academicAchievements;
  // Sağlık Bilgileri
  final String height;
  final String weight;
  final String bloodType;
  final String chronicDiseases;
  final String medications;
  final String allergies;

  ProfileModel({
    required this.name,
    required this.birthDate,
    required this.zodiacSign,
    required this.personality,
    required this.regrets,
    required this.dreams,
    required this.socialLife,
    required this.economicStatus,
    required this.style,
    required this.educationLevel,
    required this.school,
    required this.department,
    required this.academicAchievements,
    required this.height,
    required this.weight,
    required this.bloodType,
    required this.chronicDiseases,
    required this.medications,
    required this.allergies,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthDate': birthDate,
      'zodiacSign': zodiacSign,
      'personality': personality,
      'regrets': regrets,
      'dreams': dreams,
      'socialLife': socialLife,
      'economicStatus': economicStatus,
      'style': style,
      'educationLevel': educationLevel,
      'school': school,
      'department': department,
      'academicAchievements': academicAchievements,
      'height': height,
      'weight': weight,
      'bloodType': bloodType,
      'chronicDiseases': chronicDiseases,
      'medications': medications,
      'allergies': allergies,
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] ?? '',
      birthDate: json['birthDate'] ?? '',
      zodiacSign: json['zodiacSign'] ?? '',
      personality: json['personality'] ?? '',
      regrets: List<String>.from(json['regrets'] ?? []),
      dreams: List<String>.from(json['dreams'] ?? []),
      socialLife: json['socialLife'] ?? '',
      economicStatus: json['economicStatus'] ?? '',
      style: json['style'] ?? '',
      educationLevel: json['educationLevel'] ?? '',
      school: json['school'] ?? '',
      department: json['department'] ?? '',
      academicAchievements: json['academicAchievements'] ?? '',
      height: json['height'] ?? '',
      weight: json['weight'] ?? '',
      bloodType: json['bloodType'] ?? '',
      chronicDiseases: json['chronicDiseases'] ?? '',
      medications: json['medications'] ?? '',
      allergies: json['allergies'] ?? '',
    );
  }

  String toPrompt() {
    return '''
Kişisel Bilgiler:
Ad Soyad: $name
Doğum Tarihi: $birthDate
Burç: $zodiacSign
Kişilik Özellikleri: $personality
Pişmanlıklar: ${regrets.join(', ')}
Hayaller: ${dreams.join(', ')}
Sosyal Bilgiler:
Sosyal İlişkiler: $socialLife
Ekonomik Bilgiler:
Ekonomik Durum: $economicStatus
Tarz: $style
Akademik Bilgiler:
Eğitim Düzeyi: $educationLevel
Okul: $school
Bölüm: $department
Akademik Başarılar: $academicAchievements
Sağlık Bilgileri:
Boy: $height
Kilo: $weight
Kan Grubu: $bloodType
Kronik Hastalıklar: $chronicDiseases
Kullandığı İlaçlar: $medications
Alerjiler: $allergies
''';
  }
} 