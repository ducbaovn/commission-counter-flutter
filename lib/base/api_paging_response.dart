import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class APIPagingResponse  {

  @JsonKey(name: 'current_page')
  int currentPage;

  @JsonKey(name: 'total')
  int totalPage;

  APIPagingResponse({
    this.currentPage,
    this.totalPage,
  });
}
