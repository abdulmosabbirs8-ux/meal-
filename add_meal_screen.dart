import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/member.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final FirebaseService _service = FirebaseService();
  Member? _selected;
  DateTime _date = DateTime.now();
  int _breakfast = 0, _lunch = 0, _dinner = 0;

  void _save() async {
    if (_selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a member')));
      return;
    }
    await _service.addMeal(_selected!.id, _date, _breakfast, _lunch, _dinner);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Meal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StreamBuilder<List<Member>>(
              stream: _service.streamMembers(),
              builder: (context, snap) {
                if (!snap.hasData) return const CircularProgressIndicator();
                final members = snap.data!;
                return DropdownButton<Member>(
                  hint: const Text('Select member'),
                  value: _selected,
                  items: members.map((m) => DropdownMenuItem(value: m, child: Text(m.name))).toList(),
                  onChanged: (v) => setState(() => _selected = v),
                );
              },
            ),
            const SizedBox(height: 10),
            Row(children: [const Text('Date: '), Text('${_date.toLocal()}'.split(' ')[0]), IconButton(icon: const Icon(Icons.calendar_month), onPressed: () async { final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime(2100)); if (d!=null) setState(()=>_date=d); })]),
            const SizedBox(height: 10),
            Row(children: [const Text('Breakfast: '), IconButton(onPressed: () => setState(() => _breakfast = (_breakfast-1).clamp(0, 10)), icon: const Icon(Icons.remove)), Text('$_breakfast'), IconButton(onPressed: () => setState(() => _breakfast = (_breakfast+1).clamp(0, 10)), icon: const Icon(Icons.add))]),
            Row(children: [const Text('Lunch:     '), IconButton(onPressed: () => setState(() => _lunch = (_lunch-1).clamp(0, 10)), icon: const Icon(Icons.remove)), Text('$_lunch'), IconButton(onPressed: () => setState(() => _lunch = (_lunch+1).clamp(0, 10)), icon: const Icon(Icons.add))]),
            Row(children: [const Text('Dinner:    '), IconButton(onPressed: () => setState(() => _dinner = (_dinner-1).clamp(0, 10)), icon: const Icon(Icons.remove)), Text('$_dinner'), IconButton(onPressed: () => setState(() => _dinner = (_dinner+1).clamp(0, 10)), icon: const Icon(Icons.add))]),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}
