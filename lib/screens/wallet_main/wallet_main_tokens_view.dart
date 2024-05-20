import 'package:flutter/material.dart';

import 'tokens/wallet_main_accounts_view.dart';
import 'tokens/wallet_main_summary_view.dart';

class WalletMainTokens extends StatelessWidget {
  const WalletMainTokens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WalletMainSummary(),
        const Divider(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: WalletMainAccounts(),
          ),
        ),
      ],
    );
  }
}
