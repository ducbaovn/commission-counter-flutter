import 'package:json_annotation/json_annotation.dart';

part 'store.g.dart';

@JsonSerializable()
class Store {
  String adminId;
  String currency;
  String name;
  String timezone;
  List<double> parValues;

  Store({
    this.adminId,
    this.currency,
    this.name,
    this.parValues,
    this.timezone,
  });

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  Map<String, dynamic> toJson() => _$StoreToJson(this);
}
