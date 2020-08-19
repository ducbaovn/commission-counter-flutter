import 'package:json_annotation/json_annotation.dart';

class FirebaseDateTimeConverter implements JsonConverter<DateTime, DateTime> {
  const FirebaseDateTimeConverter();

  @override
  DateTime fromJson(DateTime json) {
    return json;
  }

  @override
  DateTime toJson(DateTime object) {
    return object.toUtc();
  }
}
