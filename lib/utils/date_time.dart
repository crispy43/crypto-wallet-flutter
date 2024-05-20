import 'dart:math';

import 'package:intl/intl.dart';

// * DateTime now timestamp
int getTimeNowMicro() => DateTime.now().microsecondsSinceEpoch;
int getTimeNowMilli() => DateTime.now().millisecondsSinceEpoch;

// * 날짜시간 포멧
bool isMicro(num value) => log(value) / ln10 == 16;
bool isMilli(num value) => log(value) / ln10 == 13;
int calcLocaleTime(int time, String locale) {
  switch (locale) {
    case 'ko_KR':
      time = time.toInt() + 9 * 60 * 60 * 1000;
      break;
    default:
      time = time.toInt();
      break;
  }
  return time;
}

// * HH:MM
String toHmString(num timestamp, [String locale = 'ko_KR']) =>
    DateFormat.Hm(locale).format(DateTime.fromMillisecondsSinceEpoch(
        calcLocaleTime(timestamp.toInt(), locale)));
// * HH:MM:SS
String toHmsString(num timestamp, [String locale = 'ko_KR']) =>
    DateFormat.Hms(locale).format(DateTime.fromMillisecondsSinceEpoch(
        calcLocaleTime(timestamp.toInt(), locale)));
