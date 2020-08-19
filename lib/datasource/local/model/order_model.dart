import 'package:commission_counter/converter/local_datetime_converter.dart';
import 'package:commission_counter/schema/order.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable()
@LocalDateTimeConverter()
class OrderModel {
  String id;
  @JsonKey(name: 'store_owner_id')
  String storeOwnerId;

  @JsonKey(name: 'store_id')
  String storeId;

  @JsonKey(name: 'admin_id')
  String adminId;

  String currency;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  double amount;

  OrderModel({
    this.id,
    this.storeOwnerId,
    this.storeId,
    this.adminId,
    this.currency,
    this.updatedAt,
    this.createdAt,
    this.amount,
  });

  Order get toOrder => Order(
        id: id,
        storeOwnerId: storeOwnerId,
        storeId: storeId,
        adminId: adminId,
        currency: currency,
        amount: amount,
        updatedAt: updatedAt,
        createdAt: createdAt,
      );

  static String tableName = 'orders';

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
