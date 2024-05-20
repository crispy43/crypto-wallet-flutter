import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:crypto_wallet/controllers/wallet_controller.dart';

class WalletMainSummary extends StatefulWidget {
  const WalletMainSummary({Key? key}) : super(key: key);

  @override
  State<WalletMainSummary> createState() => _WalletMainSummaryState();
}

class _WalletMainSummaryState extends State<WalletMainSummary> {
  late WalletController _walletController;

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
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100.0,
      color: const Color.fromRGBO(212, 72, 52, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              _walletController.currentWallet!.wallet.walletName,
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          // Text(
          //   // TODO: 가격 계산하여 환율 적용할 것
          //   '\$123,456.00',
          //   style: Theme.of(context).textTheme.subtitle1,
          // ),
        ],
      ),
    );
  }
}
