class Hub {
  String? id;
  String name;
  String address;
  Hub({
    this.id,
    required this.name,
    required this.address,
  });
  factory Hub.fromJson(Map<String, dynamic> json) {
    return Hub(
      id: json['_id'],
      name: json['name'],
      address: json['address'],
    );
  }
}
