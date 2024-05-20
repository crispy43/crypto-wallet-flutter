import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:crypto_wallet/controllers/eth_controller.dart';
import 'package:crypto_wallet/controllers/message_controller.dart';
import 'package:crypto_wallet/controllers/wallet_controller.dart';
import 'package:crypto_wallet/screens/init_wallet/init_wallet_view.dart';
import 'package:crypto_wallet/widgets/app_bars/network_app_bar.dart';
import 'package:crypto_wallet/widgets/tabs/indicate_tab_bar.dart';
import 'package:crypto_wallet/widgets/tiles/token_tile.dart';

import '../../widgets/forms/outline_text_field.dart';

class Send extends StatefulWidget {
  const Send({
    super.key,
    required this.accountIndex,
    this.tokenIndex,
  });

  final int accountIndex;
  final int? tokenIndex;

  static const routeName = '/send';

  @override
  State<Send> createState() => _SendState();
}

class _SendState extends State<Send> {
  late MessageController _messageController;
  late WalletController _walletController;
  late EthController _ethController;
  late List<TokenTile> _assets;
  late String _asset;
  Map form = {
    // 'toAddress': '0x47882e2281961cABBeed0eDf93B7C7C15F442109',
    'toAddress': '',
    'amount': '0',
  };

  @override
  void initState() {
    super.initState();
    _messageController = GetIt.I.get<MessageController>();
    _walletController = GetIt.I.get<WalletController>();
    _ethController = GetIt.I.get<EthController>();
    _getAssets();
    // _walletController.addListener(_getAssets);
    _ethController.addListener(_getAssets);
  }

  @override
  void dispose() {
    // _walletController.removeListener(_getAssets);
    _ethController.removeListener(_getAssets);
    super.dispose();
  }

  void _getAssets() {
    setState(() {
      _assets = [
        // * 코인 타일
        TokenTile(
          backgroundColor: Colors.white,
          logo: _ethController.network.logo,
          symbol: _ethController.network.symbol,
          amount: _walletController.getBalanceFromCoinMap(
            _walletController
                .currentWallet!.walletBranch.keys[widget.accountIndex],
            _ethController.network,
          ),
          decimals: _ethController.network.decimals,
        ),
        // * 토큰 타일
        ...List.generate(
          _ethController.tokens.length,
          (int i) => TokenTile(
            backgroundColor: Colors.white,
            logo: _ethController.tokens[i].logo,
            symbol: _ethController.tokens[i].symbol,
            decimals: _ethController.tokens[i].decimals,
            amount: _walletController.getBalanceFromTokenMap(
              _walletController
                  .currentWallet!.walletBranch.keys[widget.accountIndex],
              _ethController.tokens[i],
            ),
          ),
        ),
      ];
      if (widget.tokenIndex != null &&
          widget.tokenIndex! >= _assets.length - 1) {
        _asset = _assets.first.symbol;
      } else if (widget.tokenIndex != null) {
        _asset = _assets[widget.tokenIndex! + 1].symbol;
      } else {
        _asset = _assets.first.symbol;
      }
    });
  }

  void _onChanged(dynamic value, String target) {
    form[target] = value;
  }

  void _onAssetChanged(String? value) {
    if (value != null) {
      setState(() {
        _asset = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NetworkAppBar(controller: _ethController),
      // drawer: const SideDrawer(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.all(10)),
              const Text('받는 주소'),
              OutlineTextField(
                initialValue: form['toAddress'],
                onChanged: (String value) => _onChanged(value, 'toAddress'),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              DropdownButton(
                value: _asset,
                isExpanded: true,
                items: _assets.map<DropdownMenuItem<String>>((TokenTile tile) {
                  return DropdownMenuItem<String>(
                    value: tile.symbol,
                    child: tile,
                  );
                }).toList(),
                onChanged: _onAssetChanged,
              ),
              const Padding(padding: EdgeInsets.all(10)),
              const Text('전송 수량'),
              OutlineTextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (String value) => _onChanged(value, 'amount'),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if ((_assets.indexWhere(
                            (element) => element.symbol == _asset) ==
                        0)) {
                      _walletController.sendCoin(
                        account: _walletController.currentWallet!.walletBranch
                            .keys[widget.accountIndex],
                        toAddress: form['toAddress'],
                        amount: form['amount'],
                        messageController: _messageController,
                      );
                    } else {
                      _walletController.sendToken(
                        account: _walletController.currentWallet!.walletBranch
                            .keys[widget.accountIndex],
                        token: _ethController.tokens
                            .firstWhere((element) => element.symbol == _asset),
                        toAddress: form['toAddress'],
                        amount: form['amount'],
                        messageController: _messageController,
                      );
                    }
                  },
                  child: const Text('전송'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
