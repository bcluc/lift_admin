class SenderInfo {
  String? id;
  String? address;
  String? name;
  String? phoneNumber;
  String? userId;

  SenderInfo({
    this.id,
    this.address,
    this.name,
    this.phoneNumber,
    this.userId,
  });

  factory SenderInfo.fromJson(Map<String, dynamic> json) {
    return SenderInfo(
      id: json['_id'],
      address: json['address'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      userId: json['userId'],
    );
  }
}
