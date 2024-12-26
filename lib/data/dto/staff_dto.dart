class StaffDto {
  String? id;
  int? age;
  String? gender;
  String? hubId;
  int? motorcycleCapacity;
  String? name;
  String? userId;
  int? weight;

  StaffDto({
    this.id,
    this.age,
    this.gender,
    this.hubId,
    this.motorcycleCapacity,
    this.name,
    this.userId,
    this.weight,
  });

  factory StaffDto.fromJson(Map<String, dynamic> json) {
    return StaffDto(
      id: json['_id'] ?? '',
      age: json['age'],
      gender: json['gender'],
      hubId: json['hubId'],
      motorcycleCapacity: json['motorcycleCapacity'],
      name: json['name'],
      userId: json['userId'],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'age': age,
      'gender': gender,
      'hubId': hubId,
      'motorcycleCapacity': motorcycleCapacity,
      'name': name,
      'userId': userId,
      'weight': weight,
    };
  }
}
