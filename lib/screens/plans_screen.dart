import 'package:flutter/material.dart';
import '../services/plan_service.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  final List<PlanModel> _plans = [];
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    final plans = await PlanService.getPlans();
    setState(() {
      _plans.clear();
      _plans.addAll(plans);
    });
  }

  void _addPlan() async {
    if (_controller.text.trim().isEmpty) return;
    final plan = PlanModel(text: _controller.text.trim(), untilDate: _selectedDate);
    await PlanService.addPlan(plan);
    _controller.clear();
    setState(() {
      _selectedDate = null;
    });
    _loadPlans();
  }

  void _removePlan(PlanModel plan) async {
    await PlanService.removePlan(plan);
    _loadPlans();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
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
        title: const Text('Planlar'),
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
                      labelText: 'Yeni Plan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.date_range),
                  tooltip: 'Tarihe kadar',
                  onPressed: _pickDate,
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addPlan,
                  child: const Text('Ekle'),
                ),
              ],
            ),
            if (_selectedDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.event, size: 18),
                    const SizedBox(width: 4),
                    Text('Tarihe kadar: ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            Expanded(
              child: _plans.isEmpty
                  ? const Center(child: Text('Henüz plan eklenmedi.'))
                  : ListView.builder(
                      itemCount: _plans.length,
                      itemBuilder: (context, index) {
                        final plan = _plans[index];
                        return Card(
                          child: ListTile(
                            title: Text(plan.text),
                            subtitle: plan.untilDate != null
                                ? Text('Tarihe kadar: ${plan.untilDate!.toLocal().toString().split(' ')[0]}')
                                : null,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removePlan(plan),
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