class DeliveryDto {
  String id;
  String? date;
  int? deliverTimes;
  String? hubId;
  String? hubName;
  String? orderId;
  String? staffId;
  String? staffName;
  String? status;

  DeliveryDto({
    required this.id,
    this.date,
    this.deliverTimes,
    this.hubId,
    this.hubName,
    this.orderId,
    this.staffId,
    this.staffName,
    this.status,
  });

  factory DeliveryDto.fromJson(Map<String, dynamic> json) {
    return DeliveryDto(
      id: json['deliveryId'] ?? '',
      date: json['date'],
      deliverTimes: json['deliverTimes'],
      hubId: json['hubId'],
      hubName: json['hubName'],
      orderId: json['orderId'],
      staffId: json['staffId'],
      staffName: json['staffName'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deliveryId': id,
      'date': date,
      'deliverTimes': deliverTimes,
      'hubId': hubId,
      'hubName': hubName,
      'orderId': orderId,
      'staffId': staffId,
      'staffName': staffName,
      'status': status,
    };
  }
}
