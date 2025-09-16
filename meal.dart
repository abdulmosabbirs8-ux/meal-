class Meal {
  final String id;
  final String memberId;
  final DateTime date;
  final int breakfast;
  final int lunch;
  final int dinner;

  Meal({required this.id, required this.memberId, required this.date, required this.breakfast, required this.lunch, required this.dinner});

  factory Meal.fromMap(String id, Map<String, dynamic> data) {
    return Meal(
      id: id,
      memberId: data['memberId'] ?? '',
      date: DateTime.parse(data['date'] ?? DateTime.now().toIso8601String()),
      breakfast: (data['breakfast'] ?? 0).toInt(),
      lunch: (data['lunch'] ?? 0).toInt(),
      dinner: (data['dinner'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memberId': memberId,
      'date': date.toIso8601String(),
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
    };
  }
}
