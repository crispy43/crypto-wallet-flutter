library router_builder;

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crypto_wallet/constants/style_constants.dart';
import 'package:crypto_wallet/controllers/eth_controller.dart';
import 'package:crypto_wallet/controllers/wallet_controller.dart';
import 'package:crypto_wallet/models/router/route_arguments.dart';
import 'package:crypto_wallet/screens/history/history.dart';
import 'package:crypto_wallet/screens/init_wallet/create_wallet/create_wallet.dart';
import 'package:crypto_wallet/screens/init_wallet/init_wallet.dart';
import 'package:crypto_wallet/screens/init_wallet/recover_wallet/recover_wallet.dart';
import 'package:crypto_wallet/screens/send/send.dart';
import 'package:crypto_wallet/screens/settings/settings.dart';
import 'package:crypto_wallet/screens/test/test_view.dart';
import 'package:crypto_wallet/screens/wallet_main/wallet_main.dart';

// * 라우트 빌더
PageRoute<dynamic> routeBuilder({
  required BuildContext context,
  required RouteSettings routeSettings,
  required SettingsController settingsController,
  required WalletController walletController,
  required EthController ethController,
}) {
  final RouteArguments routeArguments = (routeSettings.arguments == null)
      ? RouteArguments()
      : routeSettings.arguments as RouteArguments;
  log(routeSettings.toString());

  // TODO: 화면 추가 시 case문에 화면 위젯 추가할 것
  Widget widgetBuilder(BuildContext context) {
    switch (routeSettings.name) {
      case TestView.routeName:
        return const TestView();
      case Settings.routeName:
        return Settings();
      case InitWallet.routeName:
        return const InitWallet();
      case CreateWallet.routeName:
        return const CreateWallet();
      case RecoverWallet.routeName:
        return const RecoverWallet();
      case Send.routeName:
        return Send(
          accountIndex: routeArguments.payload?['accountIndex'] ?? 0,
          tokenIndex: routeArguments.payload?['tokenIndex'],
        );
      case History.routeName:
        return History(
          accountIndex: routeArguments.payload?['accountIndex'] ?? 0,
          token: routeArguments.payload?['token'],
        );
      case WalletMain.routeName:
      default:
        return walletController.isRegistered
            ? const WalletMain()
            : const InitWallet();
    }
  }

  // * 애니메이션 타입 정의
  switch (routeArguments.animationType) {
    case cupertinoWord:
      return CupertinoPageRoute<void>(
        settings: routeSettings,
        builder: widgetBuilder,
        maintainState: routeArguments.isMaintainState,
        fullscreenDialog: routeArguments.isFullscreenDialog,
      );
    case materialWord:
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: widgetBuilder,
        maintainState: routeArguments.isMaintainState,
        fullscreenDialog: routeArguments.isFullscreenDialog,
      );
    default:
      return DefaultPageRoute<void>(
        settings: routeSettings,
        builder: widgetBuilder,
        maintainState: routeArguments.isMaintainState,
        fullscreenDialog: routeArguments.isFullscreenDialog,
      );
  }
}

// * 기본 라우트: 애니메이션 없이 화면 전환
class DefaultPageRoute<T> extends MaterialPageRoute<T> {
  DefaultPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          maintainState: maintainState,
          settings: settings,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
