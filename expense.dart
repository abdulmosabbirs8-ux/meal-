class Expense {
  final String id;
  final DateTime date;
  final String description;
  final double amount;
  final String paidBy; // memberId

  Expense({required this.id, required this.date, required this.description, required this.amount, required this.paidBy});

  factory Expense.fromMap(String id, Map<String, dynamic> data) {
    return Expense(
      id: id,
      date: DateTime.parse(data['date'] ?? DateTime.now().toIso8601String()),
      description: data['description'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      paidBy: data['paidBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'description': description,
      'amount': amount,
      'paidBy': paidBy,
    };
  }
}
