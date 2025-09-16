class Member {
  final String id;
  final String name;
  final String phone;
  final double deposit;

  Member({required this.id, required this.name, required this.phone, required this.deposit});

  factory Member.fromMap(String id, Map<String, dynamic> data) {
    return Member(
      id: id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      deposit: (data['deposit'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'deposit': deposit,
    };
  }
}
