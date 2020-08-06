import 'package:commission_counter/type/user_role.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String username;
  String role;
  String token;

  User({
    this.username,
    this.role,
    this.token,
  });

  UserRole get userRoleType => EnumToString.fromString(UserRole.values, role);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
