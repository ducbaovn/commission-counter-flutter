import 'package:commission_counter/converter/firebase_datetime_converter.dart';
import 'package:commission_counter/converter/local_datetime_converter.dart';
import 'package:commission_counter/datasource/local/model/order_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
@FirebaseDateTimeConverter()
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

  OrderModel get toOrderModel => OrderModel(
        storeOwnerId: storeOwnerId,
        storeId: storeId,
        adminId: adminId,
        currency: currency,
        amount: amount,
        updatedAt: updatedAt,
        createdAt: createdAt,
      );

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
