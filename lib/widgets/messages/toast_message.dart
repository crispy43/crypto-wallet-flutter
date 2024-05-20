import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToastMessage({
  required BuildContext context,
  String? type,
  String? level,
  required String message,
}) {
  // TODO: 메세지 타입 및 레벨별 분기 필요
  switch (level) {
    case 'info':
    default:
      Fluttertoast.showToast(
        textColor: Colors.white,
        backgroundColor: const Color.fromRGBO(212, 72, 52, 1),
        webBgColor: 'linear-gradient(to right, #E0E0E0, #CECECE)',
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
      );
      break;
  }
}
