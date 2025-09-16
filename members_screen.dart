import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/member.dart';

class MembersScreen extends StatelessWidget {
  MembersScreen({super.key});
  final FirebaseService _service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Members')),
      body: StreamBuilder<List<Member>>(
        stream: _service.streamMembers(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final members = snap.data!;
          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final m = members[index];
              return ListTile(
                title: Text(m.name),
                subtitle: Text('Phone: ${m.phone} — Deposit: ${m.deposit} Tk'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => AddMemberDialog(service: _service));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddMemberDialog extends StatefulWidget {
  final FirebaseService service;
  const AddMemberDialog({required this.service, super.key});

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _deposit = TextEditingController();
  bool _loading = false;

  void _save() async {
    setState(() => _loading = true);
    final name = _name.text.trim();
    final phone = _phone.text.trim();
    final deposit = double.tryParse(_deposit.text.trim()) ?? 0;
    await widget.service.addMember(name, phone, deposit);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Member'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone')),
          TextField(controller: _deposit, decoration: const InputDecoration(labelText: 'Deposit (Tk)'), keyboardType: TextInputType.number),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: _loading ? null : _save, child: _loading ? const CircularProgressIndicator() : const Text('Save')),
      ],
    );
  }
}
