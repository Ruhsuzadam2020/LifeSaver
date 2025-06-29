import 'package:flutter/material.dart';
import 'package:life_saver/theme/app_theme.dart';
import 'package:life_saver/screens/chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Yaşam Koçu'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 20),
            _buildQuickActions(),
            const SizedBox(height: 20),
            _buildDailyTasks(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hoş Geldiniz!',
              style: AppTheme.headingStyle,
            ),
            SizedBox(height: 8),
            Text(
              'Bugün nasıl hissediyorsunuz?',
              style: AppTheme.bodyStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hızlı Erişim',
          style: AppTheme.headingStyle,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButton(
              icon: Icons.psychology,
              label: 'AI Koç',
              onTap: () {},
            ),
            _buildActionButton(
              icon: Icons.assignment,
              label: 'Görevler',
              onTap: () {},
            ),
            _buildActionButton(
              icon: Icons.trending_up,
              label: 'İlerleme',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTheme.bodyStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Günlük Görevler',
          style: AppTheme.headingStyle,
        ),
        const SizedBox(height: 12),
        Card(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text('Görev ${index + 1}'),
                subtitle: Text('Açıklama ${index + 1}'),
                trailing: const Icon(Icons.arrow_forward_ios),
              );
            },
          ),
        ),
      ],
    );
  }
} 