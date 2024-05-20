import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:crypto_wallet/controllers/eth_controller.dart';
import 'package:crypto_wallet/controllers/wallet_controller.dart';
import 'package:crypto_wallet/models/blockchain/erc20.dart';
import 'package:crypto_wallet/services/wallet/scanner_service.dart';
import 'package:crypto_wallet/utils/filters.dart';
import 'package:crypto_wallet/widgets/app_bars/network_app_bar.dart';
import 'package:crypto_wallet/widgets/app_bars/title_app_bar.dart';

class History extends StatefulWidget {
  const History({
    super.key,
    required this.accountIndex,
    this.token,
  });

  final int accountIndex;
  final ERC20? token;

  static const routeName = '/history';

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late WalletController _walletController;
  late EthController _ethController;
  List history = [];

  fetchTokenHistory() async {
    history = await getTokenHistory(
      network: _ethController.network,
      erc20: widget.token!,
      account: _walletController
          .currentWallet!.walletBranch.keys[widget.accountIndex],
    );
    print(history);
    setState(() {});
  }

  fetchNormalTxHistory() async {
    history = await getNormalTxHistory(
      network: _ethController.network,
      account: _walletController
          .currentWallet!.walletBranch.keys[widget.accountIndex],
    );
    print(history);
    setState(() {});
  }

  fetchKlaytnTxHistory() async {
    List res = await getKlaytnTxHistory(
      network: _ethController.network,
      account: _walletController
          .currentWallet!.walletBranch.keys[widget.accountIndex],
    );
    history = res.map((item) {
      return {
        'timeStamp': item['timestamp'].toString(),
        'from': item['from'],
        'to': item['to'],
        'value': item['value'],
      };
    }).toList();
    print(history);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _walletController = GetIt.I.get<WalletController>();
    _ethController = GetIt.I.get<EthController>();
    if (_ethController.network.chainId == 0x1 ||
        _ethController.network.chainId == 0x5) {
      if (widget.token != null) {
        fetchTokenHistory();
      } else {
        fetchNormalTxHistory();
      }
    } else {
      fetchKlaytnTxHistory();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar('전송 내역'),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 70.0,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ellipsisAddress(_walletController.currentWallet!
                        .walletBranch.keys[widget.accountIndex].address),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 20.0,
                            minHeight: 20.0,
                            maxWidth: 20.0,
                            maxHeight: 20.0,
                          ),
                          child:
                              widget.token?.logo ?? _ethController.network.logo,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          widget.token?.symbol ?? _ethController.network.symbol,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView.separated(
                  itemCount: history.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      leading: history[index]['to'] ==
                              _walletController.currentWallet!.walletBranch
                                  .keys[widget.accountIndex].address
                                  .toLowerCase()
                          ? const Icon(
                              Icons.get_app,
                              size: 25.0,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.upload,
                              size: 25.0,
                              color: Colors.blue,
                            ),
                      title: Text(
                        toComma(
                          toCustomUnit(
                            BigInt.parse(history[index]['value']),
                            widget.token?.decimals ?? 18,
                          ),
                          4,
                        ),
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      subtitle: Text(
                        history[index]['to'] ==
                                _walletController.currentWallet!.walletBranch
                                    .keys[widget.accountIndex].address
                            ? ellipsisAddress(history[index]['from'])
                            : ellipsisAddress(history[index]['to']),
                      ),
                      trailing: Column(
                        children: [
                          Text(DateFormat.yMd('ko_KR')
                              .format(DateTime.fromMillisecondsSinceEpoch(
                            ((int.parse(history[index]['timeStamp']) +
                                        9 * 60 * 60) *
                                    1000)
                                .toInt(),
                          ))),
                          Text(DateFormat.Hms('ko_KR')
                              .format(DateTime.fromMillisecondsSinceEpoch(
                            ((int.parse(history[index]['timeStamp']) +
                                        9 * 60 * 60) *
                                    1000)
                                .toInt(),
                          ))),
                        ],
                      ),
                    );
                  }),
                  separatorBuilder: ((context, index) => const Divider()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
