class DeliveryInfo {
  String? id;
  String? deliveryType;
  int? packageSize;
  String? pickupDate;
  String? pickupTime;
  String? shipmentType;
  String? status;
  double? value;

  DeliveryInfo({
    this.id,
    this.deliveryType,
    this.packageSize,
    this.pickupDate,
    this.pickupTime,
    this.shipmentType,
    this.status,
    this.value,
  });

  factory DeliveryInfo.fromJson(Map<String, dynamic> json) {
    return DeliveryInfo(
      id: json['_id'],
      deliveryType: json['deliveryType'],
      packageSize: json['packageSize'],
      pickupDate: json['pickupDate'],
      pickupTime: json['pickupTime'],
      shipmentType: json['shipmentType'],
      status: json['status'],
      value: json['value'],
    );
  }
}
