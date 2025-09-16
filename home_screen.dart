import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../models/member.dart';
import '../models/meal.dart';
import '../models/expense.dart';
import 'members_screen.dart';
import 'add_meal_screen.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _service = FirebaseService();

  double _totalExpense = 0;
  int _totalMeals = 0;
  double _mealRate = 0;

  @override
  void initState() {
    super.initState();
    // We'll listen to streams and calculate totals
    _service.streamExpenses().listen((expenses) {
      double sum = 0;
      for (var e in expenses) sum += e.amount;
      setState(() => _totalExpense = sum);
      _calcMealRate();
    });

    _service.streamMeals().listen((meals) {
      int sum = 0;
      for (var m in meals) sum += (m.breakfast + m.lunch + m.dinner);
      setState(() => _totalMeals = sum);
      _calcMealRate();
    });
  }

  void _calcMealRate() {
    if (_totalMeals == 0) {
      setState(() => _mealRate = 0);
    } else {
      setState(() => _mealRate = _totalExpense / _totalMeals);
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), actions: [IconButton(onPressed: _logout, icon: const Icon(Icons.logout))]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Expense: ${_totalExpense.toStringAsFixed(2)} Tk', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Total Meals: $_totalMeals', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Meal Rate: ${_mealRate.toStringAsFixed(2)} Tk', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_) => MembersScreen())); }, child: const Text('Members')),
            ElevatedButton(onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_) => const AddMealScreen())); }, child: const Text('Add Meal')),
            ElevatedButton(onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExpenseScreen())); }, child: const Text('Add Expense')),
            const SizedBox(height: 20),
            const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('- Members -> Add members and deposits.'),
            const Text('- Add meals per member and add expenses when someone buys groceries.'),
            const Text('- Final settlement = deposit - (memberMeals * mealRate) + paidAmount'),
          ],
        ),
      ),
    );
  }
}
