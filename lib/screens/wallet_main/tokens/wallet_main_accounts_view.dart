import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:crypto_wallet/constants/style_constants.dart';
import 'package:crypto_wallet/controllers/eth_controller.dart';
import 'package:crypto_wallet/controllers/message_controller.dart';

import 'package:crypto_wallet/controllers/wallet_controller.dart';
import 'package:crypto_wallet/databases/adaptors/base_key_adaptor.dart';
import 'package:crypto_wallet/models/router/route_arguments.dart';
import 'package:crypto_wallet/screens/history/history.dart';
import 'package:crypto_wallet/screens/send/send.dart';
import 'package:crypto_wallet/utils/filters.dart';
import 'package:crypto_wallet/widgets/modals/qrcode_modal.dart';
import 'package:crypto_wallet/widgets/modals/single_text_field_modal.dart';
import 'package:crypto_wallet/widgets/tiles/token_tile.dart';

class WalletMainAccounts extends StatefulWidget {
  const WalletMainAccounts({Key? key}) : super(key: key);

  @override
  State<WalletMainAccounts> createState() => _WalletMainAccountsState();
}

class _WalletMainAccountsState extends State<WalletMainAccounts> {
  late WalletController _walletController;
  final _carouselController = CarouselController();
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _walletController = GetIt.I.get<WalletController>();
    _walletController.addListener(_rebuild);
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => fetchAllBalances(),
    );
  }

  @override
  void dispose() {
    _walletController.removeListener(_rebuild);
    _timer.cancel();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  void fetchAllBalances() {
    _walletController.fetchCoinBalances();
    _walletController.fetchTokenBalances();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        children: [
          SizedBox(
            height: constraints.maxHeight - 50.0,
            child: CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount:
                  _walletController.currentWallet!.walletBranch.keys.length + 1,
              options: CarouselOptions(
                height: constraints.maxHeight - 50.0,
                viewportFraction: 0.9,
                initialPage: _currentIndex,
                enlargeCenterPage: false,
                enableInfiniteScroll: false,
                onPageChanged: (index, _) => setState(() {
                  _currentIndex = index;
                }),
              ),
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) {
                return itemIndex <
                        _walletController
                            .currentWallet!.walletBranch.keys.length
                    ? AccountCard(
                        account: _walletController
                            .currentWallet!.walletBranch.keys[itemIndex],
                        accountIndex: itemIndex,
                      )
                    : AddAccount(
                        nextIndex: _walletController
                            .currentWallet!.walletBranch.keys.length,
                      );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                _walletController.currentWallet!.walletBranch.keys.length,
                (index) => GestureDetector(
                  onTap: () => _carouselController.animateToPage(index),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_currentIndex == index ? 0.9 : 0.4),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ),
                child: GestureDetector(
                  onTap: () => _carouselController.jumpToPage(
                    _walletController.currentWallet!.walletBranch.keys.length,
                  ),
                  child: Text(
                    '+',
                    style: TextStyle(
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_currentIndex ==
                                  _walletController
                                      .currentWallet!.walletBranch.keys.length
                              ? 0.9
                              : 0.4),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class AccountCard extends StatefulWidget {
  const AccountCard({
    Key? key,
    required this.account,
    required this.accountIndex,
  }) : super(key: key);

  final BaseKey account;
  final int accountIndex;
  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  late MessageController _messageController;
  late WalletController _walletController;
  late EthController _ethController;

  @override
  void initState() {
    super.initState();
    _messageController = GetIt.I.get<MessageController>();
    _walletController = GetIt.I.get<WalletController>();
    _ethController = _walletController.ethController;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                widget.account.addresses.first.label ??
                    'Account ${widget.accountIndex + 1}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: ElevatedButton(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: widget.account.address),
                  );
                  _messageController.notifyMessage(message: '주소가 복사되었습니다.');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(ellipsisAddress(widget.account.address)),
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.content_copy,
                        size: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // * 코인 타일
                    InkWell(
                      onTap: () => Navigator.pushNamed(
                        context,
                        History.routeName,
                        arguments: RouteArguments(
                          animationType: materialWord,
                          payload: {
                            'accountIndex': widget.accountIndex,
                          },
                        ),
                      ),
                      child: TokenTile(
                        backgroundColor: Colors.white,
                        logo: _ethController.network.logo,
                        symbol: _ethController.network.symbol,
                        amount: _walletController.getBalanceFromCoinMap(
                          widget.account,
                          _ethController.network,
                        ),
                        decimals: _ethController.network.decimals,
                      ),
                    ),

                    // * 토큰 타일
                    ...List.generate(
                      _ethController.tokens.length,
                      (int i) => InkWell(
                        onTap: () => Navigator.pushNamed(
                          context,
                          History.routeName,
                          arguments: RouteArguments(
                            animationType: materialWord,
                            payload: {
                              'accountIndex': widget.accountIndex,
                              'token': _ethController.tokens[i],
                            },
                          ),
                        ),
                        child: TokenTile(
                          backgroundColor: Colors.white,
                          logo: _ethController.tokens[i].logo,
                          symbol: _ethController.tokens[i].symbol,
                          decimals: _ethController.tokens[i].decimals,
                          amount: _walletController.getBalanceFromTokenMap(
                            widget.account,
                            _ethController.tokens[i],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                    onPressed: () => showQrCodeModal(
                      context: context,
                      address: widget.account.address,
                      builder: (BuildContext context) {
                        return QrCodeModal(address: widget.account.address);
                      },
                    ),
                    child: Icon(
                      Icons.get_app,
                      size: 25.0,
                    ),
                  ),
                  Text(
                    "받기",
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Color(0xff484848),
                    ),
                  ),
                ]),
                // * 보내기 버튼
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          Send.routeName,
                          arguments: RouteArguments(
                            animationType: materialWord,
                            payload: {
                              'accountIndex': widget.accountIndex,
                            },
                          ),
                        ),
                        child: Icon(
                          Icons.upload,
                          size: 25.0,
                        ),
                      ),
                    ),
                    Text(
                      "보내기",
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Color(0xff484848),
                      ),
                    ),
                  ],
                )
                // ElevatedButton(
                //   onPressed: () => null,
                //   child: Icon(
                //     Icons.swap_vert,
                //     size: 25.0,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddAccount extends StatefulWidget {
  const AddAccount({
    Key? key,
    required this.nextIndex,
  }) : super(key: key);

  final int nextIndex;

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  late WalletController _walletController;
  final String title = '신규 주소 생성';
  final String description = '주소 이름을 입력하세요.';
  final String submitLabel = '생성';
  String? addressLabel;

  void onChanged(String text) {
    addressLabel = text;
  }

  void addNewAddress() async {
    await _walletController.addAddress(addressLabel);
  }

  @override
  void initState() {
    super.initState();
    _walletController = GetIt.I.get<WalletController>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String placeholder = 'Account ${widget.nextIndex + 1}';

    return Center(
      child: ElevatedButton(
        onPressed: () => showSingleTextFieldModal(
          context: context,
          title: title,
          description: description,
          placeholder: placeholder,
          submitLabel: submitLabel,
          onChanged: onChanged,
          onSubmit: addNewAddress,
          builder: (BuildContext context) {
            return SingleTextFieldModal(
              title: title,
              description: description,
              placeholder: placeholder,
              submitLabel: submitLabel,
              onChanged: onChanged,
              onSubmit: addNewAddress,
            );
          },
        ),
        child: const Text('주소 생성'),
      ),
    );
  }
}
