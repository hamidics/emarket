

import 'package:eMarket/ui/helpers/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/common/connection_service.dart';
import 'core/utilities/router.dart' as router;
import 'core/utilities/service_locator.dart';
import 'core/common/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupServices();
  ConnectionService.getInstance().initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(EMarketApp()));
}

class EMarketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eMarket',
      navigatorKey: locator<NavigationService>().navigationKey,
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      initialRoute: 'splash',
      onGenerateRoute: router.Router.generateRoute,
      locale: Locale('ps'),
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ps', 'AF'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
    );
  }
}
