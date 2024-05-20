import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'package:crypto_wallet/controllers/message_controller.dart';

final messageController = GetIt.instance.get<MessageController>();

void showToastMessage(String message) {
  if (!kReleaseMode) messageController.notifyMessage(message: message);
}

// * 에러 핸들러
void errorHandler(e) {
  // * dio 에러일때
  if (e is DioError) {
    if (e.response != null) {
      log(e.response.toString());
      showToastMessage(e.response!.data.toString());
    } else {
      log(e.message.toString());
      showToastMessage(e.message.toString());
    }
  }

  // * 기타
  else {
    log(e.toString());
    showToastMessage(e.toString());
  }
}
