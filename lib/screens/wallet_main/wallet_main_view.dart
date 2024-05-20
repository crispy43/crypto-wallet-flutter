import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:crypto_wallet/controllers/eth_controller.dart';
import 'package:crypto_wallet/controllers/wallet_controller.dart';
import 'package:crypto_wallet/screens/drawer/side_drawer_view.dart';
import 'package:crypto_wallet/screens/init_wallet/init_wallet_view.dart';
import 'package:crypto_wallet/widgets/app_bars/network_app_bar.dart';
import 'package:crypto_wallet/widgets/tabs/indicate_tab_bar.dart';

import 'wallet_main_tokens_view.dart';

class WalletMain extends StatefulWidget {
  const WalletMain({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<WalletMain> createState() => _WalletMainState();
}

class _WalletMainState extends State<WalletMain>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late WalletController _walletController;
  late EthController _ethController;

  // * 탭바
  static const List<SizedTab> tabs = [
    SizedTab(label: 'Tokens'),
    // SizedTab(label: 'NFTs'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: 0,
    );
    _walletController = GetIt.I.get<WalletController>();
    _ethController = GetIt.I.get<EthController>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // * 월렛 없을 경우 월렛 등록 페이지로
    if (!_walletController.isRegistered &&
        !_walletController.isLoadedCurrentWallet) {
      Navigator.pushNamed(context, InitWallet.routeName);
    }

    return Scaffold(
      appBar: NetworkAppBar(controller: _ethController),
      // drawer: const SideDrawer(),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: IndicateTabBar(
                  controller: _tabController,
                  tabs: tabs,
                ),
              ),
              const Divider(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    WalletMainTokens(),
                    // SizedBox(
                    //   child: Center(
                    //     child: Text('준비중...'),
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
