import 'package:lift_admin/data/model/delivery_info.dart';
import 'package:lift_admin/data/model/receiver_info.dart';
import 'package:lift_admin/data/model/sender_info.dart';

class OrderDto {
  String id;
  DeliveryInfo? deliveryInfo;
  String? hubId;
  String? hubName;
  String? message;
  String? payStatus;
  String? payWith;
  ReceiverInfo? receiverInfo;
  SenderInfo? senderInfo;

  OrderDto({
    required this.id,
    this.deliveryInfo,
    this.hubId,
    this.hubName,
    this.message,
    this.payStatus,
    this.payWith,
    this.receiverInfo,
    this.senderInfo,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) {
    return OrderDto(
      id: json['_id'] ?? '',
      deliveryInfo: json['deliveryInfo'] != null
          ? DeliveryInfo.fromJson(json['deliveryInfo'])
          : null,
      hubId: json['hubId'],
      hubName: json['hubName'],
      message: json['message'],
      payStatus: json['payStatus'],
      payWith: json['payWith'],
      receiverInfo: json['receiverInfo'] != null
          ? ReceiverInfo.fromJson(json['receiverInfo'])
          : null,
      senderInfo: json['senderInfo'] != null
          ? SenderInfo.fromJson(json['senderInfo'])
          : null,
    );
  }
}
