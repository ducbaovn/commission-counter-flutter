import 'package:json_annotation/json_annotation.dart';

class LocalDateTimeConverter implements JsonConverter<DateTime, String> {
  const LocalDateTimeConverter();

  @override
  DateTime fromJson(String json) {
    if (json == null) {
      return null;
    }
    return DateTime.parse(json).toLocal();
  }

  @override
  String toJson(DateTime json) {
    if (json == null) {
      return null;
    }
    return json.toIso8601String();
  }
}
