import 'dart:developer';

import 'package:crypto_wallet/models/wallet/mnemonic.dart';

import 'functions/key_functions.dart';

const String temporaryWord = '_temporary';

// * 임시 니모닉 코드 불러오기
Future<String?> readTemporaryMnemonic() async {
  try {
    return await readMnemonic(temporaryWord);
  } catch (error) {
    log(error.toString());
    return null;
  }
}

// * 임시 랜덤 니모닉 생성 후 저장
Future<String> writeTemporaryMnemonic() async {
  try {
    final Mnemonic mnemonic = Mnemonic.generateRandom();
    await writeRoot(temporaryWord, mnemonic.code);
    return mnemonic.code;
  } catch (error) {
    log(error.toString());
    rethrow;
  }
}
