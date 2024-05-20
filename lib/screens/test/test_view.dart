import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:crypto_wallet/constants/hd_constants.dart';
import 'package:crypto_wallet/controllers/message_controller.dart';
import 'package:crypto_wallet/databases/adaptors/wallet_adaptor.dart';
import 'package:crypto_wallet/models/wallet/key_pair.dart';
import 'package:crypto_wallet/models/wallet/mnemonic.dart';
import 'package:crypto_wallet/modules/hd/hd.dart';
import 'package:crypto_wallet/screens/init_wallet/init_wallet_view.dart';
import 'package:crypto_wallet/services/notification/notification_service.dart';
import 'package:crypto_wallet/services/wallet/functions/query_functions.dart';
import 'package:crypto_wallet/services/wallet/mnemonic_service.dart';
import 'package:crypto_wallet/services/wallet/wallet_service.dart';

class TestView extends StatefulWidget {
  const TestView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/test';

  @override
  _TestViewState createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  String code = '';
  String btcAddress = '';
  String ethAddress = '';
  String argon2Hash = '';

  final messageController = GetIt.instance.get<MessageController>();

  Future<void> _setTemporaryCode() async {
    code = await readTemporaryMnemonic() ?? await writeTemporaryMnemonic();
    _setBtcAddress();
    _setEthAddress();
    _rebuild();
  }

  Future<void> _resetTemporaryCode() async {
    code = await writeTemporaryMnemonic();
    _setBtcAddress();
    _setEthAddress();
    _rebuild();
  }

  void _setBtcAddress() {
    var root = mnemonicToRootKey(code);
    var btcPath = getPath(networkType: 'btc', index: 0);
    var childKeyBtc = deriveChildKey(root, btcPath!);
    btcAddress = toAddress(KeyPair.fromBase58(childKeyBtc));
  }

  void _setEthAddress() {
    var root = mnemonicToRootKey(code);
    var ethPath = getPath(networkType: 'eth', index: 0);
    var childKeyEth = deriveChildKey(root, ethPath!);
    ethAddress = toEthAddress(KeyPair.fromBase58(childKeyEth));
  }

  void _logWallets() async {
    log((await collectAll()).toString());
  }

  void _findFirstWallet() async {
    List<Wallet> finded = await findWallets(
      {
        walletIdWord: (await readAllWallets()).first.walletId,
      },
      sort: (Wallet a, Wallet b) => b.createdAt.compareTo(a.createdAt),
    );
    log(finded.toString());
  }

  void _deleteAll() async {
    await removeHiveFromDisk();
    Navigator.pushNamed(context, InitWallet.routeName);
  }

  void _createWallet() async {
    await createWallet(
      rootType: 'mnemonic',
      code: Mnemonic.generateRandom().code,
      walletName: 'test',
      networkTypes: [ethWord],
      isBackedUp: true,
    );
  }

  void _showToastMessage() {
    messageController.notifyMessage(message: 'test');
  }

  void _requestIOSPermissions() {
    NotificationService.requestIOSPermissions();
  }

  void _sampleNotification() async {
    NotificationService.sampleNotification();
  }

  @override
  void initState() {
    super.initState();
    _setTemporaryCode();
    // _setArgon2Hash();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('니모닉'),
                  Text(code),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _resetTemporaryCode,
                child: Text('reset'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('비트코인 주소'),
                  Text(btcAddress),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('이더리움 주소'),
                  Text(ethAddress),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _createWallet,
                child: Text('create wallet'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _logWallets,
                child: Text('all wallets'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _findFirstWallet,
                child: Text('find first wallet'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _deleteAll,
                child: Text('remove all data'),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _showToastMessage,
                child: Text('토스트 메세지'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _requestIOSPermissions,
                child: Text('IOS 노티 퍼미션 요청'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _sampleNotification,
                child: Text('샘플 노티 출력'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
