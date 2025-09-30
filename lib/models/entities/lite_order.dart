class LiteOrder {
  final String id;
  final String status;
  final String number;

  LiteOrder({
    required this.id,
    required this.status,
    this.number = '',
  });

  factory LiteOrder.fromJson(Map<String, dynamic> json) {
    return LiteOrder(
      id: json['id'].toString(),
      status: json['status'],
      number: json['number'],
    );
  }
}
