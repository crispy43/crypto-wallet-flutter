import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:crypto_wallet/controllers/eth_controller.dart';
import 'package:crypto_wallet/controllers/wallet_controller.dart';
import 'package:crypto_wallet/modules/router/route_builder.dart';

import 'controllers/message_controller.dart';
import 'generated/l10n.dart';
import 'screens/settings/settings.dart';
import 'theme/app_theme.dart';
import 'widgets/messages/toast_message.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final messageController = GetIt.I.get<MessageController>();
  final settingsController = GetIt.I.get<SettingsController>();
  final analytics = GetIt.I.get<FirebaseAnalytics>();
  final ethController = GetIt.I.get<EthController>();
  final walletController = GetIt.I.get<WalletController>();

  // * 토스트 메세지
  void _showToastMessage(BuildContext context) {
    showToastMessage(
      context: context,
      type: messageController.messages.last.type,
      level: messageController.messages.last.level,
      message: messageController.messages.last.message,
    );
  }

  @override
  Widget build(BuildContext context) {
    messageController.addListener(() => _showToastMessage(context));
    analytics.logAppOpen();

    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          onGenerateTitle: (BuildContext context) => S.of(context).appTitle,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settingsController.themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            PageRoute<dynamic> pageRoute = routeBuilder(
              context: context,
              routeSettings: routeSettings,
              settingsController: settingsController,
              walletController: walletController,
              ethController: ethController,
            );
            return pageRoute;
          },
          navigatorObservers: <NavigatorObserver>[
            FirebaseAnalyticsObserver(analytics: analytics),
          ],
        );
      },
    );
  }
}
