import 'package:flutter/material.dart';
import '../services/routine_service.dart';

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({super.key});

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  final List<RoutineModel> _routines = [];
  final TextEditingController _controller = TextEditingController();
  String? _selectedFrequency;

  final List<String> _frequencyOptions = [
    'Her gün',
    'Haftada 3',
    'Haftada 1',
    'Ayda 1',
    'Opsiyonel',
  ];

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    final routines = await RoutineService.getRoutines();
    setState(() {
      _routines.clear();
      _routines.addAll(routines);
    });
  }

  void _addRoutine() async {
    if (_controller.text.trim().isEmpty) return;
    final routine = RoutineModel(text: _controller.text.trim(), frequency: _selectedFrequency);
    await RoutineService.addRoutine(routine);
    _controller.clear();
    setState(() {
      _selectedFrequency = null;
    });
    _loadRoutines();
  }

  void _removeRoutine(RoutineModel routine) async {
    await RoutineService.removeRoutine(routine);
    _loadRoutines();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutinler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Yeni Rutin',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedFrequency,
                  hint: const Text('Sıklık'),
                  items: _frequencyOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFrequency = value;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addRoutine,
                  child: const Text('Ekle'),
                ),
              ],
            ),
            if (_selectedFrequency != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.repeat, size: 18),
                    const SizedBox(width: 4),
                    Text('Sıklık: $_selectedFrequency'),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            Expanded(
              child: _routines.isEmpty
                  ? const Center(child: Text('Henüz rutin eklenmedi.'))
                  : ListView.builder(
                      itemCount: _routines.length,
                      itemBuilder: (context, index) {
                        final routine = _routines[index];
                        return Card(
                          child: ListTile(
                            title: Text(routine.text),
                            subtitle: routine.frequency != null
                                ? Text('Sıklık: ${routine.frequency}')
                                : null,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeRoutine(routine),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
} 