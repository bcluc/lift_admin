class ReceiverInfo {
  String? id;
  String? address;
  String? name;
  String? phoneNumber;
  String? userId;

  ReceiverInfo({
    this.id,
    this.address,
    this.name,
    this.phoneNumber,
    this.userId,
  });

  factory ReceiverInfo.fromJson(Map<String, dynamic> json) {
    return ReceiverInfo(
      id: json['_id'],
      address: json['address'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      userId: json['userId'],
    );
  }
}
