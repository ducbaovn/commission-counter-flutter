import 'package:commission_counter/converter/local_datetime_converter.dart';
import 'package:commission_counter/schema/commission.dart';
import 'package:json_annotation/json_annotation.dart';

part 'commission_model.g.dart';

@JsonSerializable()
@LocalDateTimeConverter()
class CommissionModel {
  String id;

  @JsonKey(name: 'store_owner_id')
  String storeOwnerId;

  @JsonKey(name: 'store_id')
  String storeId;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'admin_id')
  String adminId;

  double amount;

  String currency;

  @JsonKey(name: 'agent_id')
  String agentId;

  @JsonKey(name: 'customer_id')
  String customerId;

  @JsonKey(name: 'order_id')
  String orderId;

  @JsonKey(name: 'is_selected')
  int isSelected;

  String name;

  int seat;

  CommissionModel({
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

  Commission get toCommission => Commission(
        id: id,
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
        isSelected: isSelected == 1 ? true : false,
      );

  static String tableName = 'commissions';

  factory CommissionModel.fromJson(Map<String, dynamic> json) =>
      _$CommissionModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommissionModelToJson(this);
}
