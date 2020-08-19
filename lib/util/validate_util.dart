import 'package:validators/validators.dart';

const MOBILE_LENGTH = 10;
const INVALID_MOBILE_PATTERN = r'^[0-9]+$';
const CARD_NUMBER_LENGTH = 16;

class ValidateUtil {
  static bool isNullOrEmpty(String value) =>
      value == null || value.trim().isEmpty;

  static bool isValidName(String value) {
    if (value == null) {
      return false;
    }

    value = value.trim();

    if (!value.contains(" ")) {
      return false;
    }

    return true;
  }

  static bool isValidPhone(String phone) {
    return phone.length == MOBILE_LENGTH &&
        !isInValid(phone, INVALID_MOBILE_PATTERN);
  }

  static bool isValidEmail(String email) => isEmail(email);

  static bool isValid(String value, String regexPattern) =>
      RegExp(regexPattern).hasMatch(value);

  static bool isInValid(String value, String regexPattern) =>
      !isValid(value, regexPattern);

  static bool isValidCardNumber(String cardNumber) =>
      cardNumber != null &&
      cardNumber.replaceAll(" ", '').length == CARD_NUMBER_LENGTH;
}
