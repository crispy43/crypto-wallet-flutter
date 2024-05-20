import 'dart:math';

import 'package:intl/intl.dart';

// * 숫자 콤마 포멧
NumberFormat comma = NumberFormat('#,##0');
String toComma(num value, [int precision = 0]) {
  late NumberFormat formatter;
  if (precision > 0) {
    final String precisionPattern =
        List.generate(precision, (index) => '0').join();
    formatter = NumberFormat('#,##0.$precisionPattern');
  } else {
    formatter = comma;
  }
  return formatter.format(value);
}

// * 숫자 콤마 포멧 (스트링 타입 파싱)
String toCommaWithParse(String stringValue, [int precision = 0]) {
  final double value = double.parse(stringValue);
  return toComma(value, precision);
}

// * 10의 배수 단위 적용
double toCustomUnit(BigInt bigInt, int decimals) {
  return bigInt / BigInt.from(10).pow(decimals);
}

// * toWei
BigInt toWei(double amount, int decimals) {
  return BigInt.from((amount * pow(10, decimals)).floor());
}

// * 통화 포멧
NumberFormat dolor = NumberFormat.currency(locale: 'en_US', symbol: r'$');
NumberFormat won = NumberFormat.currency(locale: 'ko_KR', symbol: '￦');

// * 1000자리 단위
String toSiUnit(num value, [int precision = 0]) {
  double log10 = log(value) / ln10;
  if (log10 >= 3 && log10 < 4) {
    return '${(value / 1000).toStringAsFixed(1)}k';
  } else if (log10 >= 4 && log10 < 6) {
    return '${value ~/ 1000}k';
  } else if (log10 >= 6 && log10 < 7) {
    return '${(value / (1000 * 1000)).toStringAsFixed(1)}m';
  } else if (log10 >= 7 && log10 < 9) {
    return '${value ~/ (1000 * 1000)}m';
  } else if (log10 >= 9 && log10 < 10) {
    return '${(value / (1000 * 1000 * 1000)).toStringAsFixed(1)}g';
  } else if (log10 >= 10 && log10 < 12) {
    return '${value ~/ (1000 * 1000 * 1000)}g';
  } else if (log10 >= 12 && log10 < 13) {
    return '${(value / (1000 * 1000 * 1000 * 1000)).toStringAsFixed(1)}t';
  } else if (log10 >= 13 && log10 < 15) {
    return '${value ~/ (1000 * 1000 * 1000 * 1000)}t';
  } else if (log10 >= 15 && log10 < 16) {
    return '${(value / (1000 * 1000 * 1000 * 1000 * 1000)).toStringAsFixed(1)}p';
  } else if (log10 >= 16) {
    return '${value ~/ (1000 * 1000 * 1000 * 1000 * 1000)}p';
  } else {
    return value.toStringAsFixed(precision);
  }
}

// * 주소 앞뒤빼고 줄이기
String ellipsisAddress(String address) {
  return '${address.substring(0, 7)}...${address.substring(address.length - 4, address.length)}';
}
