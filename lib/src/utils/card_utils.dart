import 'package:flutter_utils/src/enums/card_brand.dart';

class CardUtils {
  CardUtils._();

  static String? validateCVC(String? value) {
    if (value?.isEmpty ?? true) return _CardStrings.cvcReq;

    if ((value?.length ?? 0) < 3 || (value?.length ?? 0) > 4) {
      return _CardStrings.cvcIsInvalid;
    }
    return null;
  }

  static String? validateDate(String? value) {
    if (value?.isEmpty ?? true) return _CardStrings.dateReq;

    late int year;
    late int month;

    if (value?.contains(RegExp(r'(\/)')) ?? false) {
      var split = value?.split(RegExp(r'(\/)'));

      month = int.parse(split?[0] ?? '0');
      year = int.parse(split?[1] ?? '0');
    } else {
      month = int.parse(value?.substring(0, (value.length)) ?? '0');
      year = -1;
    }

    if ((month < 1) || (month > 12)) return _CardStrings.monthIsInvalid;

    var fourDigitsYear = convertYearTo4Digits(year);
    if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
      return _CardStrings.yearIsInvalid;
    }

    if (!hasDateExpired(month, year)) return _CardStrings.cardExpired;
    return null;
  }

  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  static bool hasDateExpired(int? month, int? year) {
    return !(month == null || year == null) && isNotExpired(year, month);
  }

  static bool isNotExpired(int year, int month) {
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  static List<num> getExpiryDate(String? value) {
    var split = value?.split(RegExp(r'(\/)'));
    return [num.parse(split?.first ?? '0'), num.parse(split?.last ?? '0')];
  }

  static bool hasMonthPassed(int year, int month) {
    var now = DateTime.now();
    return hasYearPassed(year) ||
        convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  static bool hasYearPassed(int year) {
    int fourDigitsYear = convertYearTo4Digits(year);
    var now = DateTime.now();
    return fourDigitsYear < now.year;
  }

  static String? getCleanedNumber(String? text) {
    RegExp regExp = RegExp(r"[^0-9]");
    return text?.replaceAll(regExp, '');
  }

  static String? getFormatedCardNumber(String? text, {String separator = '-'}) {
    var buffer = StringBuffer();
    for (int i = 0; i < (text?.length ?? 0); i++) {
      buffer.write(text?[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text?.length) {
        buffer.write(separator);
      }
    }
    return buffer.toString();
  }

  static String? validateCardNum(String? input) {
    if (input?.isEmpty ?? true) return _CardStrings.fieldReq;

    input = getCleanedNumber(input);

    if ((input?.length ?? 0) < 8) {
      return _CardStrings.numberIsInvalid;
    }

    int sum = 0;
    int length = input?.length ?? 0;
    for (var i = 0; i < length; i++) {
      int digit = int.parse(input?[length - i - 1] ?? '0');

      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }

    if (sum % 10 == 0) {
      return null;
    }

    return _CardStrings.numberIsInvalid;
  }

  static CardBrand getCardBrandFromNumber(String? input) {
    CardBrand cardType;

    String number = isNullOrValue(input);
    if (number.startsWith(RegExp(
        r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
      cardType = CardBrand.mastercard;
    } else if (number.startsWith(RegExp(r'[4]'))) {
      cardType = CardBrand.visa;
    } else if (number.startsWith(RegExp(r'((34)|(37))'))) {
      cardType = CardBrand.amex;
    } else if (number.startsWith(RegExp(r'((6[45])|(6011))'))) {
      cardType = CardBrand.discover;
    } else if (number.startsWith(RegExp(r'((30[0-5])|(3[89])|(36)|(3095))'))) {
      cardType = CardBrand.dinersClub;
    } else if (number.startsWith(RegExp(r'(352[89]|35[3-8][0-9])'))) {
      cardType = CardBrand.jcb;
    } else if (number.length <= 8) {
      cardType = CardBrand.unknown;
    } else {
      cardType = CardBrand.unknown;
    }
    return cardType;
  }
}

class _CardStrings {
  _CardStrings._();

  static const String fieldReq = 'Card Number is required';
  static const String numberIsInvalid = 'Card is invalid';

  static const String dateReq = 'Expiry date is required';
  static const String monthIsInvalid = 'Expiry month is invalid';
  static const String yearIsInvalid = 'Expiry year is invalid';
  static const String cardExpired = 'Card has expired';

  static const String cvcReq = 'CVC is required';
  static const String cvcIsInvalid = 'CVC is invalid';
}

T isNullOrValue<T>(dynamic value) => value;
