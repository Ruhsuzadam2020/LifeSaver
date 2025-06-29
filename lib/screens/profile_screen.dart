import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';
import '../services/user_service.dart';
import '../models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _zodiacSignController = TextEditingController();
  final _personalityController = TextEditingController();
  final _regretsController = TextEditingController();
  final _dreamsController = TextEditingController();
  final _socialLifeController = TextEditingController();
  final _economicStatusController = TextEditingController();
  final _styleController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _bloodTypeController = TextEditingController();
  final _chronicDiseasesController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _educationLevelController = TextEditingController();
  final _schoolController = TextEditingController();
  final _departmentController = TextEditingController();
  final _academicAchievementsController = TextEditingController();
  String? _userEmail;
  bool _isGuest = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadMembership();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _zodiacSignController.dispose();
    _personalityController.dispose();
    _regretsController.dispose();
    _dreamsController.dispose();
    _socialLifeController.dispose();
    _economicStatusController.dispose();
    _styleController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bloodTypeController.dispose();
    _chronicDiseasesController.dispose();
    _medicationsController.dispose();
    _allergiesController.dispose();
    _educationLevelController.dispose();
    _schoolController.dispose();
    _departmentController.dispose();
    _academicAchievementsController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileService.getProfile();
    if (profile != null) {
      setState(() {
        _nameController.text = profile.name;
        _birthDateController.text = profile.birthDate;
        _zodiacSignController.text = profile.zodiacSign;
        _personalityController.text = profile.personality;
        _regretsController.text = profile.regrets.join(', ');
        _dreamsController.text = profile.dreams.join(', ');
        _socialLifeController.text = profile.socialLife;
        _economicStatusController.text = profile.economicStatus;
        _styleController.text = profile.style;
        _heightController.text = profile.height;
        _weightController.text = profile.weight;
        _bloodTypeController.text = profile.bloodType;
        _chronicDiseasesController.text = profile.chronicDiseases;
        _medicationsController.text = profile.medications;
        _allergiesController.text = profile.allergies;
        _educationLevelController.text = profile.educationLevel;
        _schoolController.text = profile.school;
        _departmentController.text = profile.department;
        _academicAchievementsController.text = profile.academicAchievements;
      });
    }
  }

  Future<void> _loadMembership() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      final user = UserProfile.fromJson(Map<String, dynamic>.from(jsonDecode(userData)));
      setState(() {
        _userEmail = user.email.isNotEmpty ? user.email : null;
        _isGuest = user.email.isEmpty;
      });
    } else {
      setState(() {
        _userEmail = null;
        _isGuest = true;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final profile = ProfileModel(
        name: _nameController.text,
        birthDate: _birthDateController.text,
        zodiacSign: _zodiacSignController.text,
        personality: _personalityController.text,
        regrets: _regretsController.text.split(',').map((e) => e.trim()).toList(),
        dreams: _dreamsController.text.split(',').map((e) => e.trim()).toList(),
        socialLife: _socialLifeController.text,
        economicStatus: _economicStatusController.text,
        style: _styleController.text,
        educationLevel: _educationLevelController.text,
        school: _schoolController.text,
        department: _departmentController.text,
        academicAchievements: _academicAchievementsController.text,
        height: _heightController.text,
        weight: _weightController.text,
        bloodType: _bloodTypeController.text,
        chronicDiseases: _chronicDiseasesController.text,
        medications: _medicationsController.text,
        allergies: _allergiesController.text,
      );

      await ProfileService.setProfile(profile);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil kaydedildi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.deepPurple.shade700,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(_isGuest ? Icons.person_outline : Icons.verified_user, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isGuest ? 'Misafir' : 'Üye: $_userEmail',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ExpansionTile(
                    title: const Text('Kişisel Bilgiler'),
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Ad Soyad',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen adınızı girin';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _birthDateController,
                        decoration: const InputDecoration(
                          labelText: 'Doğum Tarihi',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen doğum tarihinizi girin';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _zodiacSignController,
                        decoration: const InputDecoration(
                          labelText: 'Burç',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen burcunuzu girin';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _personalityController,
                        decoration: const InputDecoration(
                          labelText: 'Kişilik Özellikleri',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen kişilik özelliklerinizi girin';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _regretsController,
                        decoration: const InputDecoration(
                          labelText: 'Pişmanlıklar (virgülle ayırın)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen pişmanlıklarınızı girin';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _dreamsController,
                        decoration: const InputDecoration(
                          labelText: 'Hayaller (virgülle ayırın)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen hayallerinizi girin';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ExpansionTile(
                    title: const Text('Ekonomik Bilgiler'),
                    children: [
                      TextFormField(
                        controller: _economicStatusController,
                        decoration: const InputDecoration(
                          labelText: 'Ekonomik Durum',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen ekonomik durumunuzu girin';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _styleController,
                        decoration: const InputDecoration(
                          labelText: 'Tarz',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen tarzınızı girin';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ExpansionTile(
                    title: const Text('Sosyal Bilgiler'),
                    children: [
                      TextFormField(
                        controller: _socialLifeController,
                        decoration: const InputDecoration(
                          labelText: 'Sosyal İlişkiler',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen sosyal ilişkilerinizi girin';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ExpansionTile(
                    title: const Text('Akademik Bilgiler'),
                    children: [
                      TextFormField(
                        controller: _educationLevelController,
                        decoration: const InputDecoration(
                          labelText: 'Eğitim Düzeyi',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _schoolController,
                        decoration: const InputDecoration(
                          labelText: 'Okul',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _departmentController,
                        decoration: const InputDecoration(
                          labelText: 'Bölüm',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _academicAchievementsController,
                        decoration: const InputDecoration(
                          labelText: 'Akademik Başarılar',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ExpansionTile(
                    title: const Text('Sağlık Bilgileri'),
                    children: [
                      TextFormField(
                        controller: _heightController,
                        decoration: const InputDecoration(
                          labelText: 'Boy (cm)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _weightController,
                        decoration: const InputDecoration(
                          labelText: 'Kilo (kg)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _bloodTypeController,
                        decoration: const InputDecoration(
                          labelText: 'Kan Grubu',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _chronicDiseasesController,
                        decoration: const InputDecoration(
                          labelText: 'Kronik Hastalıklar',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _medicationsController,
                        decoration: const InputDecoration(
                          labelText: 'Kullandığı İlaçlar',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _allergiesController,
                        decoration: const InputDecoration(
                          labelText: 'Alerjiler',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Kaydet'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 