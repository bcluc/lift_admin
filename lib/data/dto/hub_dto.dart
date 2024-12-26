class HubDto {
  String name;
  String address;
  int canceledOrders;
  int failedOrders;
  String? hubId;
  int inProgressOrders;
  int pendingOrders;
  int successOrders;

  HubDto({
    required this.name,
    required this.address,
    required this.canceledOrders,
    required this.failedOrders,
    this.hubId,
    required this.inProgressOrders,
    required this.pendingOrders,
    required this.successOrders,
  });

  factory HubDto.fromJson(Map<String, dynamic> json) {
    return HubDto(
      name: json['name'],
      address: json['address'],
      canceledOrders: json['canceledOrders'],
      failedOrders: json['failedOrders'],
      hubId: json['hubId'],
      inProgressOrders: json['inProgressOrders'],
      pendingOrders: json['pendingOrders'],
      successOrders: json['successOrders'],
    );
  }
}
