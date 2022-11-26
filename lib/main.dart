import 'dart:async';

import 'package:caship/app/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var navigationKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(() async {
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(const ProviderScope(child: MyApp()));
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigationKey,
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.light,
                statusBarColor: Color.fromRGBO(34, 34, 34, 1),
              ),
            ),
        textTheme:
            Theme.of(context).textTheme.apply(fontFamily: 'Gilroy').copyWith(
                  headlineSmall: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.apply(fontFamily: 'Cirka'),
                  headlineMedium: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.apply(fontFamily: 'Cirka'),
                  headlineLarge: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.apply(fontFamily: 'Cirka'),
                ),
        backgroundColor: const Color.fromRGBO(34, 34, 34, 1.0),
        scaffoldBackgroundColor: const Color.fromRGBO(34, 34, 34, 1.0),
        primaryColor: Colors.white,
      ),
      themeMode: ThemeMode.dark,
      home: const Wrapper(),
    );
  }
}
