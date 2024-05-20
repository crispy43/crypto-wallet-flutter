import 'package:flutter/material.dart';
import 'package:crypto_wallet/screens/wallet_main/wallet_main_view.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    Key? key,
    this.currentIndex = 0,
  }) : super(key: key);

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        unselectedItemColor: const Color(0xffcccccc),
        selectedItemColor: const Color(0xffeb4034),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: Color(0xffcccccc),
        ),
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: Color(0xffeb4034),
        ),
        currentIndex: currentIndex,

        onTap: (int i) async {
          // * 인덱스 별 라우팅 정의
          // TODO: 화면 위젯 인덱스 별로 연결할 것
          switch (i) {
            case 0:
              await Navigator.pushNamed(
                context,
                WalletMain.routeName,
              );
              break;
            case 1:
              await Navigator.pushNamed(
                context,
                WalletMain.routeName,
              );
              break;
            case 2:
              await Navigator.pushNamed(
                context,
                WalletMain.routeName,
              );
              break;
          }
        },

        // * 네비게이션 아이콘
        items: [
          BottomNavigationBarItem(
            label: 'Wallet',
            icon: Icon(
              Icons.account_balance_wallet_outlined,
              color: Theme.of(context).iconTheme.color,
              size: 28.0,
            ),
          ),
          BottomNavigationBarItem(
            label: 'History',
            icon: Icon(
              Icons.history_outlined,
              color: Theme.of(context).iconTheme.color,
              size: 28.0,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(
              Icons.settings_outlined,
              color: Theme.of(context).iconTheme.color,
              size: 28.0,
            ),
          ),
        ],
      ),
    );
  }
}
