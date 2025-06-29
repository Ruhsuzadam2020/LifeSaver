import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';
import 'screens/profile_screen.dart';
import 'services/chat_service.dart';
import 'screens/routines_screen.dart';
import 'screens/plans_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/auth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Saver',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
      ),
      home: const EntryGate(),
    );
  }
}

class EntryGate extends StatefulWidget {
  const EntryGate({super.key});

  @override
  State<EntryGate> createState() => _EntryGateState();
}

class _EntryGateState extends State<EntryGate> {
  bool _loading = true;
  bool _hasProfile = false;

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  Future<void> _checkProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final hasProfile = prefs.containsKey('user_data');
    setState(() {
      _hasProfile = hasProfile;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
    );
    }
    if (_hasProfile) {
      return const MainScreen();
    } else {
      return const AuthScreen();
    }
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ChatSession> _chatSessions = [];
  Key _chatScreenKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _screens = [
      ChatScreen(key: _chatScreenKey),
      const ProfileScreen(),
      const PlansScreen(),
      const RoutinesScreen(),
    ];
    _loadChatSessions();
  }

  Future<void> _loadChatSessions() async {
    final sessions = await ChatService.getAllSessions();
    if (mounted) {
      setState(() {
        _chatSessions = sessions;
      });
    }
  }

  void _onMenuIconPressed() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onActionIconPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _createNewChat() async {
    await ChatService.createNewSession();
    if (mounted) {
      setState(() {
        _selectedIndex = 0;
        _chatScreenKey = UniqueKey();
        _screens[0] = ChatScreen(key: _chatScreenKey);
      });
      _loadChatSessions();
    }
  }

  void _switchToChat(String sessionId) async {
    await ChatService.switchToSession(sessionId);
    if (mounted) {
      setState(() {
        _selectedIndex = 0;
        _chatScreenKey = UniqueKey();
        _screens[0] = ChatScreen(key: _chatScreenKey);
      });
    }
  }

  void _deleteChat(String sessionId) async {
    await ChatService.deleteSession(sessionId);
    if (mounted) {
      _loadChatSessions();
      // Eğer silinen sohbet mevcut sohbetse, yeni bir sohbet oluştur
      if (ChatService.getCurrentSessionId() == null) {
        _createNewChat();
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Bugün';
    } else if (difference.inDays == 1) {
      return 'Dün';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text('Sohbetler', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Yeni Sohbet'),
              onTap: () {
                _createNewChat();
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ..._chatSessions.map((session) {
              final isCurrentSession = session.id == ChatService.getCurrentSessionId();
              return ListTile(
                leading: Icon(
                  isCurrentSession ? Icons.chat_bubble : Icons.chat_bubble_outline,
                  color: isCurrentSession ? Colors.deepPurple : null,
                ),
                title: Text(
                  session.title,
                  style: TextStyle(
                    fontWeight: isCurrentSession ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  '${session.messages.length} mesaj • ${_formatDate(session.lastModified)}',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      _deleteChat(session.id);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Sil'),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _switchToChat(session.id);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: _selectedIndex == 0
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: _onMenuIconPressed,
              )
            : IconButton(
                icon: const Icon(Icons.chat),
                tooltip: 'Ana Sayfa',
                onPressed: () => setState(() => _selectedIndex = 0),
              ),
        title: const Text('Life Saver'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profil',
            onPressed: () => _onActionIconPressed(1),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: 'Planlar',
            onPressed: () => _onActionIconPressed(2),
          ),
          IconButton(
            icon: const Icon(Icons.schedule),
            tooltip: 'Rutinler',
            onPressed: () => _onActionIconPressed(3),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
    );
  }
} 