import 'package:commission_counter/converter/firebase_datetime_converter.dart';
import 'package:commission_counter/converter/local_datetime_converter.dart';
import 'package:commission_counter/datasource/local/model/commission_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'commission.g.dart';

@JsonSerializable()
@FirebaseDateTimeConverter()
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
  String name;
  int seat;

  @JsonKey(ignore: true)
  bool isSelected;

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
    this.name,
    this.seat,
    this.isSelected,
  });

  CommissionModel get toCommissionModel => CommissionModel(
        storeOwnerId: storeOwnerId,
        storeId: storeId,
        updatedAt: updatedAt,
        createdAt: createdAt,
        adminId: adminId,
        amount: amount,
        currency: currency,
        agentId: agentId,
        customerId: customerId,
        orderId: orderId,
        name: name,
        seat: seat,
        isSelected: isSelected ? 1 : 0,
      );

  factory Commission.fromJson(Map<String, dynamic> json) =>
      _$CommissionFromJson(json);

  Map<String, dynamic> toJson() => _$CommissionToJson(this);
}
