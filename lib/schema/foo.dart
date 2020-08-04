import 'package:json_annotation/json_annotation.dart';

part 'foo.g.dart';

@JsonSerializable()
class Foo {
  String foo;

  Foo({
    this.foo,
  });

  factory Foo.fromJson(Map<String, dynamic> json) => _$FooFromJson(json);

  Map<String, dynamic> toJson() => _$FooToJson(this);
}
