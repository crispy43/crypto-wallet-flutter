import 'package:flutter/material.dart';
import 'package:crypto_wallet/constants/style_constants.dart';
import 'package:crypto_wallet/models/router/route_arguments.dart';
import 'package:crypto_wallet/screens/init_wallet/create_wallet/create_wallet_view.dart';
import 'package:crypto_wallet/screens/init_wallet/recover_wallet/recover_wallet_view.dart';

class InitWallet extends StatelessWidget {
  const InitWallet({Key? key}) : super(key: key);

  static const routeName = '/wallet/init';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Container(
                width: 300,
                height: 150,
                child:
                    Image(image: AssetImage("assets/images/flutter_logo.png")),
              ),
              SizedBox(height: 100),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50)),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        CreateWallet.routeName,
                        arguments: RouteArguments(
                          animationType: materialWord,
                        ),
                      ),
                      child: Text('신규 생성'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50)),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        RecoverWallet.routeName,
                        arguments: RouteArguments(
                          animationType: materialWord,
                        ),
                      ),
                      child: Text('계정 복구'),
                    ),
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
