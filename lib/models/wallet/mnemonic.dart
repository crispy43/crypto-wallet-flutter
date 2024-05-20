import 'dart:convert';

import 'package:crypto_wallet/modules/hd/hd_module.dart';

class Mnemonic {
  final String code;
  final String locale;
  final int words;
  Mnemonic({
    required this.code,
    this.locale = defaultLocale,
    this.words = defaultWords,
  });

  Mnemonic copyWith({
    String? code,
    String? locale,
    int? words,
  }) {
    return Mnemonic(
      code: code ?? this.code,
      locale: locale ?? this.locale,
      words: words ?? this.words,
    );
  }

  // * 랜덤 생성
  factory Mnemonic.generateRandom([int? words]) {
    return Mnemonic(
      code: generateRandomMnemonic(words ?? defaultWords),
      locale: defaultLocale,
      words: words ?? defaultWords,
    );
  }

  // * code에서
  factory Mnemonic.fromCode(String code, [String? locale]) {
    return Mnemonic(
      code: code,
      locale: locale ?? defaultLocale,
      words: code.split(' ').length,
    );
  }

  // * code 리스트에서
  factory Mnemonic.fromCodeList(List<String> codeList, [String? locale]) {
    return Mnemonic(
      code: codeList.join(' '),
      locale: locale ?? defaultLocale,
      words: codeList.length,
    );
  }

  // * code를 리스트로
  List<String> get codeToList => code.split(' ');

  // * code를 rootKey로
  String get rootKey => mnemonicToRootKey(code);

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'locale': locale,
      'words': words,
    };
  }

  factory Mnemonic.fromMap(Map<String, dynamic> map) {
    return Mnemonic(
      code: map['code'] ?? '',
      locale: map['locale'] ?? defaultLocale,
      words: map['words']?.toInt() ?? map['code'].split(' ').length,
    );
  }

  String toJson() => json.encode(toMap());

  factory Mnemonic.fromJson(String source) =>
      Mnemonic.fromMap(json.decode(source));

  @override
  String toString() => 'Mnemonic(code: $code, locale: $locale, words: $words)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Mnemonic &&
        other.code == code &&
        other.locale == locale &&
        other.words == words;
  }

  @override
  int get hashCode => code.hashCode ^ locale.hashCode ^ words.hashCode;
}
