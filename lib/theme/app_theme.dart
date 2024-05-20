import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) => const Color.fromRGBO(212, 72, 52, 1),
          ),
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) => Colors.white,
          ),
        ),
      ),
      useMaterial3: true,
      textTheme: const TextTheme(
        headline1: TextStyle(
          fontSize: 26.0,
          fontFamily: 'NanumSquareRound',
          fontWeight: FontWeight.w700,
          color: Color(0xff484848),
        ),
        headline2: TextStyle(
          fontSize: 24.0,
          fontFamily: 'NanumSquareRound',
          fontWeight: FontWeight.w700,
          color: Color(0xff484848),
        ),
        headline3: TextStyle(
          fontSize: 22.0,
          fontFamily: 'NanumSquareRound',
          fontWeight: FontWeight.w700,
          color: Color(0xff484848),
        ),
        headline4: TextStyle(
          fontSize: 20.0,
          fontFamily: 'NanumSquareRound',
          fontWeight: FontWeight.w700,
          color: Color(0xff484848),
        ),
        headline5: TextStyle(
          fontSize: 18.0,
          fontFamily: 'NanumSquareRound',
          fontWeight: FontWeight.w700,
          color: Color(0xff484848),
        ),
        headline6: TextStyle(
          fontSize: 16.0,
          fontFamily: 'NanumSquareRound',
          fontWeight: FontWeight.w700,
          color: Color(0xff484848),
        ),
        subtitle1: TextStyle(
          fontSize: 18.0,
          fontFamily: 'NanumSquareRound',
          fontWeight: FontWeight.w700,
          color: Color(0xff484848),
        ),
        subtitle2: TextStyle(
          fontSize: 16.0,
          fontFamily: 'NanumSquareRound',
          fontWeight: FontWeight.w700,
          color: Color(0xff8f8f8f),
        ),
        bodyText1: TextStyle(
          fontSize: 14.0,
          fontFamily: 'NanumSquareRound',
          fontWeight: FontWeight.w400,
          color: Color(0xff484848),
        ),
        bodyText2: TextStyle(
          fontSize: 14.0,
          fontFamily: 'NanumSquareRound',
          fontWeight: FontWeight.w400,
          color: Color(0xff8f8f8f),
        ),
        caption: TextStyle(
          fontSize: 12.0,
          fontFamily: 'NanumSquareRound',
          fontWeight: FontWeight.w400,
          color: Color(0xff484848),
        ),
        button: TextStyle(
          fontSize: 14.0,
          fontFamily: 'NanumSquareRound',
          fontWeight: FontWeight.w700,
          color: Color(0xff484848),
        ),
        overline: TextStyle(
          fontSize: 10.0,
          fontFamily: 'NanumSquareRound',
          fontWeight: FontWeight.w400,
          color: Color(0xff484848),
        ),
      ),
      iconTheme: const IconThemeData(
        size: 21.0,
        color: Color(0xffc4c4c4),
      ),
      fontFamily: 'NanumSquareRound',
      dividerTheme: const DividerThemeData(
        thickness: 1.0,
        space: 1.0,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData.dark();
  }
}
