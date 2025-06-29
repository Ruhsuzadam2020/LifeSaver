import 'package:flutter/material.dart';
import 'profile_setup_screen.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş veya Kayıt'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
                  ).then((value) {
                    if (value == true) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const EntryGate()),
                      );
                    }
                  });
                },
                child: const Text('Kayıt Ol'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => const LoginDialog(),
                  );
                },
                child: const Text('Giriş Yap'),
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () {
                  // Misafir olarak devam et: direkt ana ekrana yönlendir
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                },
                child: const Text('Misafir olarak devam et'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData == null) {
      setState(() {
        _error = 'Kayıtlı kullanıcı bulunamadı.';
      });
      return;
    }
    final user = Map<String, dynamic>.from(jsonDecode(userData));
    if (user['email'] == _emailController.text && user['password'] == _passwordController.text) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      setState(() {
        _error = 'E-posta veya şifre hatalı.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Giriş Yap'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-posta'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'E-posta girin';
                }
                if (!RegExp(r'^.+@.+\..+').hasMatch(value)) {
                  return 'Geçerli bir e-posta girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Şifre'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Şifre girin';
                }
                if (value.length < 6) {
                  return 'Şifre en az 6 karakter olmalı';
                }
                return null;
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: _login,
          child: const Text('Giriş Yap'),
        ),
      ],
    );
  }
} 