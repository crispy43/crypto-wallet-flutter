import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:crypto_wallet/controllers/wallet_controller.dart';
import 'package:crypto_wallet/utils/error.dart';

import 'app.dart';
import 'constants/box_constants.dart';
import 'constants/network_constants.dart';
import 'controllers/eth_controller.dart';
import 'controllers/message_controller.dart';
import 'databases/hive.dart';
import 'databases/secure_storage.dart';
import 'firebase_options.dart';
import 'screens/settings/settings_controller.dart';
import 'screens/settings/settings_service.dart';
import 'services/notification/notification_service.dart';
import 'utils/crypto.dart';
import 'utils/date_time.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool data = await fetchData();
  print(data);

  // * RUN_ENV에 따라 환경 변수 로드
  const runEnv = String.fromEnvironment('RUN_ENV');
  switch (runEnv) {
    case 'PROD':
      await dotenv.load(fileName: '.env.production');
      break;
    case 'DEV':
    default:
      await dotenv.load(fileName: '.env.development');
      break;
  }
  log('Running in ${dotenv.env['ENV_NAME']} mode.');

  // * Storage initialize
  SecureStorage.init();
  await Hive.initFlutter();
  registerAllAdaptors();
  String? boxEncKeyHex = await SecureStorage.read(boxEncryptionKeyWord);
  if (boxEncKeyHex == null) {
    final Uint8List boxEncKeyBuffer =
        toSha256Buffer('${getSecureRandomCharacters(16)}${getTimeNowMicro()}');
    await SecureStorage.write(
        boxEncryptionKeyWord, bufferToHex(boxEncKeyBuffer));
    await openAllBoxes(boxEncKeyBuffer);
  } else {
    await openAllBoxes(hexToBuffer(boxEncKeyHex));
  }

  // * Root bundle
  WidgetsFlutterBinding.ensureInitialized();

  // * Controllers
  // TODO: 하이브에서 정보 읽어와서 초기화할 것
  final settingsController = SettingsController(SettingsService());
  final ethController = EthController(networksForProd[0]);
  final walletController = WalletController(ethController: ethController);
  await settingsController.loadSettings();
  ethController.checkProvider();
  await walletController.load();
  walletController.initCoinMap();
  walletController.onChangedNetwork();
  walletController.subscribe();

  // * Firebase initialize
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // * GetIt Singleton
  final getIt = GetIt.instance;
  getIt.registerSingleton<FirebaseAnalytics>(analytics);
  getIt.registerSingleton<MessageController>(MessageController());
  getIt.registerSingleton<SettingsController>(settingsController);
  getIt.registerSingleton<EthController>(ethController);
  getIt.registerSingleton<WalletController>(walletController);

  // * Notification initialize
  await NotificationService.init();
  NotificationService.requestIOSPermissions();

  // * FCM Token
  final String? fcmToken = await FirebaseMessaging.instance.getToken();
  log('FirebaseMessaging: fcmToken => $fcmToken');
  FirebaseMessaging.instance.onTokenRefresh.listen((newFcmToken) {
    log('FirebaseMessaging: new fcmToken => $newFcmToken');
  }).onError((error) {
    errorHandler(error);
  });

  runApp(MyApp());
}

Future<bool> fetchData() async {
  bool data = false;

  // Change to API call
  await Future.delayed(Duration(seconds: 3), () {
    data = true;
  });

  return data;
}
