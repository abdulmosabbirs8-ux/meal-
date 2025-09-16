import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/member.dart';
import '../models/meal.dart';
import '../models/expense.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Members
  Stream<List<Member>> streamMembers() {
    return _db.collection('members').snapshots().map((snap) => snap.docs.map((d) => Member.fromMap(d.id, d.data())).toList());
  }

  Future<void> addMember(String name, String phone, double deposit) async {
    await _db.collection('members').add({'name': name, 'phone': phone, 'deposit': deposit});
  }

  // Meals
  Stream<List<Meal>> streamMeals() {
    return _db.collection('meals').snapshots().map((snap) =>
        snap.docs.map((d) => Meal.fromMap(d.id, d.data())).toList());
  }

  Future<void> addMeal(String memberId, DateTime date, int breakfast, int lunch, int dinner) async {
    await _db.collection('meals').add({
      'memberId': memberId,
      'date': date.toIso8601String(),
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
    });
  }

  // Expenses
  Stream<List<Expense>> streamExpenses() {
    return _db.collection('expenses').snapshots().map((snap) => snap.docs.map((d) => Expense.fromMap(d.id, d.data())).toList());
  }

  Future<void> addExpense(String description, double amount, String paidBy, DateTime date) async {
    await _db.collection('expenses').add({
      'description': description,
      'amount': amount,
      'paidBy': paidBy,
      'date': date.toIso8601String(),
    });
  }
}
