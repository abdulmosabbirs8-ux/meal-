import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/member.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final FirebaseService _service = FirebaseService();
  Member? _selected;
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  DateTime _date = DateTime.now();

  void _save() async {
    if (_selected == null) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select payer'))); return; }
    final amt = double.tryParse(_amount.text.trim()) ?? 0;
    await _service.addExpense(_desc.text.trim(), amt, _selected!.id, _date);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
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
                  hint: const Text('Select payer'),
                  value: _selected,
                  items: members.map((m) => DropdownMenuItem(value: m, child: Text(m.name))).toList(),
                  onChanged: (v) => setState(() => _selected = v),
                );
              },
            ),
            TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Description')),
            TextField(controller: _amount, decoration: const InputDecoration(labelText: 'Amount (Tk)'), keyboardType: TextInputType.number),
            Row(children: [const Text('Date: '), Text('${_date.toLocal()}'.split(' ')[0]), IconButton(icon: const Icon(Icons.calendar_month), onPressed: () async { final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime(2100)); if (d!=null) setState(()=>_date=d); })]),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}
