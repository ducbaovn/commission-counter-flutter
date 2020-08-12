import 'package:json_annotation/json_annotation.dart';

part 'commission.g.dart';

@JsonSerializable()
class Commission {
  String id;
  String storeOwnerId;
  String storeId;
  DateTime updatedAt;
  DateTime createdAt;
  String adminId;
  double amount;
  String currency;
  String agentId;
  String customerId;
  String orderId;

  Commission({
    this.id,
    this.storeOwnerId,
    this.storeId,
    this.updatedAt,
    this.createdAt,
    this.adminId,
    this.amount,
    this.currency,
    this.agentId,
    this.customerId,
    this.orderId,
  });

  factory Commission.fromJson(Map<String, dynamic> json) =>
      _$CommissionFromJson(json);

  Map<String, dynamic> toJson() => _$CommissionToJson(this);
}
