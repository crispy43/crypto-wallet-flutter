import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:crypto_wallet/constants/hd_constants.dart';
import 'package:crypto_wallet/controllers/message_controller.dart';
import 'package:crypto_wallet/controllers/wallet_controller.dart';
import 'package:crypto_wallet/screens/wallet_main/wallet_main.dart';
import 'package:crypto_wallet/services/wallet/mnemonic_service.dart';
import 'package:crypto_wallet/widgets/app_bars/title_app_bar.dart';
import 'package:crypto_wallet/widgets/forms/outline_text_field.dart';

class CreateWallet extends StatefulWidget {
  const CreateWallet({Key? key}) : super(key: key);

  static const routeName = '/wallet/init/create';

  @override
  State<CreateWallet> createState() => _CreateWalletState();
}

class _CreateWalletState extends State<CreateWallet> {
  late List<String> _codes;
  late List<TextEditingController> _controllers;
  late MessageController _messageController;
  late WalletController _walletController;

  String code = '';
  String walletName = '';

  @override
  void initState() {
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
        // TextEditingValue(text: _codes[i]),
        TextEditingValue(text: _codes[i]),
      ),
    );
    super.initState();
    _messageController = GetIt.I.get<MessageController>();
    _walletController = GetIt.I.get<WalletController>();
    _walletController.addListener(_goWalletMain);
    _setTemporaryCode();
  }

  @override
  void dispose() {
    _walletController.removeListener(_goWalletMain);
    super.dispose();
  }

  void onChanged(int index, String text) {
    setState(() {
      _codes[index] = text;
    });
  }

  void rebuild() => setState(() {});

  Future<void> _setTemporaryCode() async {
    code = await readTemporaryMnemonic() ?? await writeTemporaryMnemonic();
    _codes = code.split(' ');
    _controllers = List.generate(
      _codes.length,
      (i) => TextEditingController.fromValue(
        // TextEditingValue(text: _codes[i]),
        TextEditingValue(text: _codes[i]),
      ),
    );
    rebuild();
  }

  Future<void> _createWallet() async {
    if (walletName.isNotEmpty) {
      await _walletController.createWallet(
        rootType: 'mnemonic',
        code: code,
        // code: _codes.join(' '),
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

  void _onChanged(String text) {
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
      // appBar: const TitleAppBar('지갑 생성'),
      appBar: AppBar(
        title: Image.asset('assets/images/flutter_logo.png',
            fit: BoxFit.cover),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 22.0),
                  child: Text('지갑생성',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 4, 4, 4),
                      )),
                ),
                Container(
                  width: double.infinity,
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      "지갑이름",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff484848),
                      ),
                    ),
                  ),
                ),
                OutlineTextField(
                  onChanged: _onChanged,
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      "니모닉 정보",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff484848),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            strutStyle: StrutStyle(fontSize: 14.0),
                            text: const TextSpan(
                              text:
                                  '※ 니모닉 문구는 지갑 분실 시 복구할 수있는 유일한 방법입니다. 메모 또는 캡쳐를 통해 안전하게 보관하여 주시기 바랍니다, 지갑 복구시 니모닉 정보가 없을 시 지갑 복구가 불가하여 자산을 잃을 위험이 있습니다.',
                              style: TextStyle(
                                  color: Colors.red,
                                  height: 1.4,
                                  fontSize: 11.0,
                                  fontFamily: 'NanumSquareRegular'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     minimumSize: const Size(200, 50)
                //   ),
                //   onPressed: () => _resetTemporaryCode(),
                //   child: const Text('니모닉 리셋'),
                // ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50)),
                  onPressed: () => _createWallet(),
                  child: const Text('지갑 생성'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
