import 'package:flutter/material.dart';
import 'package:crypto_wallet/screens/test/test_view.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            TestView.routeName,
          ),
          child: Text('테스트 화면'),
        ),
      ),
    );
  }
}
