import 'package:json_annotation/json_annotation.dart';

part 'seat.g.dart';

@JsonSerializable()
class Seat {
  int index; // 1->9,
  String userCode;
  double price;
  bool isSelected;

  Seat({
    this.index,
    this.userCode,
    this.price = 0,
    this.isSelected = false,
  });

  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

  Map<String, dynamic> toJson() => _$SeatToJson(this);
}
