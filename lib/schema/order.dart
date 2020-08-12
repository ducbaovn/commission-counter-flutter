import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  String id;
  String storeOwnerId;
  String storeId;
  String adminId;
  String currency;
  DateTime updatedAt;
  DateTime createdAt;
  List<String> listCustomer;
  double amount;

  Order({
    this.id,
    this.storeOwnerId,
    this.storeId,
    this.adminId,
    this.currency,
    this.updatedAt,
    this.createdAt,
    this.listCustomer,
    this.amount,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
