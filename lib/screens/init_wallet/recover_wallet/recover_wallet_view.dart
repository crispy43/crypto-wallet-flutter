import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:crypto_wallet/constants/hd_constants.dart';
import 'package:crypto_wallet/controllers/message_controller.dart';
import 'package:crypto_wallet/controllers/wallet_controller.dart';
import 'package:crypto_wallet/screens/wallet_main/wallet_main.dart';
import 'package:crypto_wallet/widgets/app_bars/title_app_bar.dart';
import 'package:crypto_wallet/widgets/forms/outline_text_field.dart';
import 'package:crypto_wallet/widgets/modals/single_text_field_modal.dart';

class RecoverWallet extends StatefulWidget {
  const RecoverWallet({Key? key}) : super(key: key);

  static const routeName = '/wallet/recover';

  @override
  State<RecoverWallet> createState() => _RecoverWalletState();
}

class _RecoverWalletState extends State<RecoverWallet> {
  late List<String> _codes;
  late List<TextEditingController> _controllers;
  late MessageController _messageController;
  late WalletController _walletController;
  String walletName = '';
  final String singleTextFieldTitle = '월렛 복구';
  final String singleTextFieldDesc = '복구할 월렛 이름을 입력하세요.';
  final String singleTextFieldPlaceholder = '';
  final String singleTextFieldSubmitLabel = '복구';

  @override
  void initState() {
    // _codes = List.generate(12, (_) => '');
    _codes = [
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    ];
    _controllers = List.generate(
      _codes.length,
      (i) => TextEditingController.fromValue(
        TextEditingValue(text: _codes[i]),
      ),
    );
    _messageController = GetIt.I.get<MessageController>();
    _walletController = GetIt.I.get<WalletController>();
    _walletController.addListener(_goWalletMain);
    super.initState();
  }

  @override
  void dispose() {
    _walletController.removeListener(_goWalletMain);
    super.dispose();
  }

  // TODO: 코드 검증식 추가 필요
  void onChanged(int index, String text) {
    setState(() {
      _codes[index] = text;
    });
  }

  Future<void> _createWallet() async {
    if (walletName.isNotEmpty) {
      _walletController.createWallet(
        rootType: 'mnemonic',
        code: _codes.join(' '),
        walletName: walletName,
        networkTypes: [ethWord],
        isBackedUp: true,
      );
    } else {
      _messageController.notifyMessage(
        message: '월렛 이름을 입력하세요.',
      );
    }
  }

  void _onWalletNameChanged(String text) {
    setState(() {
      walletName = text;
    });
  }

  void _goWalletMain() {
    if (_walletController.isRegistered) {
      Navigator.pushNamed(context, WalletMain.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const TitleAppBar('지갑 복구'),
      appBar: AppBar(
        title: Image.asset('assets/images/flutter_logo.png',
            fit: BoxFit.cover),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 22.0),
                child: Text(
                  '지갑복구',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 4, 4, 4),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Text('니모닉 문구를 순서대로 입력하세요.'),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                    childAspectRatio: 3.0,
                  ),
                  itemCount: _codes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          children: [
                            const Spacer(),
                            Text(
                              '${index + 1}. ',
                              style: const TextStyle(fontSize: 12.0),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: constraints.maxWidth - 24.0,
                              ),
                              child: OutlineTextField(
                                fontSize: 12.0,
                                controller: _controllers[index],
                                autoFocus: false,
                                onChanged: (String text) =>
                                    onChanged(index, text),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
                onPressed: () => showSingleTextFieldModal(
                  context: context,
                  title: singleTextFieldTitle,
                  description: singleTextFieldDesc,
                  placeholder: singleTextFieldPlaceholder,
                  submitLabel: singleTextFieldSubmitLabel,
                  willDismiss: false,
                  onChanged: _onWalletNameChanged,
                  onSubmit: _createWallet,
                  builder: (BuildContext context) {
                    return SingleTextFieldModal(
                      title: singleTextFieldTitle,
                      description: singleTextFieldDesc,
                      placeholder: singleTextFieldPlaceholder,
                      submitLabel: singleTextFieldSubmitLabel,
                      willDismiss: false,
                      onChanged: _onWalletNameChanged,
                      onSubmit: _createWallet,
                    );
                  },
                ),
                child: const Text('복구'),
              ),
              SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }
}
