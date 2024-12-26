class Delivery {
  String id;
  String? date;
  int? deliverTimes;
  String? hubId;
  String? orderId;
  String? staffId;
  String? status;

  Delivery({
    required this.id,
    this.date,
    this.deliverTimes,
    this.hubId,
    this.orderId,
    this.staffId,
    this.status,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['_id'] ?? '',
      date: json['date'],
      deliverTimes: json['deliverTimes'],
      hubId: json['hubId'],
      orderId: json['orderId'],
      staffId: json['staffId'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date,
      'deliverTimes': deliverTimes,
      'hubId': hubId,
      'orderId': orderId,
      'staffId': staffId,
      'status': status,
    };
  }
}
