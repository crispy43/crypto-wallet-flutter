import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:crypto_wallet/models/blockchain/erc20.dart';

Future<List> getTokenTx({
  required String scannerUrl,
  required String contractAddress,
  required String address,
}) async {
  Dio dio = Dio();
  Response response = await dio.get(
    scannerUrl,
    queryParameters: {
      'module': 'account',
      'action': 'tokentx',
      'contractAddress': contractAddress,
      'address': address,
      'apiKey': '',
      'offset': '500',
      'sort': 'desc',
    },
  );
  return response.data['result'];
}

Future<List> getNormalTx({
  required String scannerUrl,
  required String address,
}) async {
  Dio dio = Dio();
  Response response = await dio.get(
    scannerUrl,
    queryParameters: {
      'module': 'account',
      'action': 'txlist',
      'address': address,
      'apiKey': '',
      'offset': '500',
      'sort': 'desc',
    },
  );
  return response.data['result'];
}

Future<List> getKlaytnTx({
  required int chainId,
  required String address,
}) async {
  Dio dio = Dio();
  dio.options.headers['x-chain-id'] = chainId.toString();
  dio.options.headers['authorization'] =
      '';
  Response response = await dio.get(
    'https://th-api.klaytnapi.com/v2/transfer/account/$address',
    queryParameters: {},
  );
  return response.data['items'];
}
