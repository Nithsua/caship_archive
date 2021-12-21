import 'package:caship/providers/themeProvider.dart';
import 'package:caship/views/dashboardView.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(const ProviderScope(child: MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: "Lato",
          backgroundColor: Colors.grey.shade50,
          scaffoldBackgroundColor: Colors.grey.shade50,
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
              statusBarColor: Colors.grey.shade50,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.grey.shade50,
              systemNavigationBarIconBrightness: Brightness.dark,
              systemNavigationBarDividerColor: Colors.grey.shade50,
            ),
            foregroundColor: Colors.black,
            color: Colors.grey.shade50,
            elevation: 0.0,
            toolbarTextStyle: Theme.of(context).textTheme.subtitle1,
            titleTextStyle: Theme.of(context).textTheme.headline6,
          ),
          textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.black,
              fontFamily: "Lato"),
          cardTheme: CardTheme(
            elevation: 0.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
          ),
          bottomSheetTheme: const BottomSheetThemeData(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0))),
              backgroundColor: Colors.white),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.grey.shade50,
            elevation: 0.0,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Colors.black,
                secondary: Colors.black,
                background: Colors.grey.shade50,
                onBackground: Colors.black,
                brightness: Brightness.light,
                onSurface: Colors.black,
                surface: Colors.white,
              ),
          listTileTheme: ListTileThemeData(
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          )),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          primarySwatch: Colors.blue,
          dialogBackgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black)),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: "Lato",
          backgroundColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              statusBarColor: Colors.black,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: Colors.black,
              systemNavigationBarIconBrightness: Brightness.light,
              systemNavigationBarDividerColor: Colors.black,
            ),
            color: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0.0,
            toolbarTextStyle: Theme.of(context).textTheme.subtitle1,
            titleTextStyle: Theme.of(context)
                .textTheme
                .headline6
                ?.apply(color: Colors.white),
          ),
          textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
              fontFamily: "Lato"),
          cardTheme: CardTheme(
            elevation: 0.0,
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
          ),
          bottomSheetTheme: BottomSheetThemeData(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0))),
              backgroundColor: Colors.grey[900]),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            elevation: 0.0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Colors.white,
                secondary: Colors.white,
                background: Colors.black,
                onBackground: Colors.white,
                brightness: Brightness.dark,
                onSurface: Colors.white,
                surface: Colors.black,
              ),
          listTileTheme: ListTileThemeData(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0))),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          primarySwatch: Colors.grey,
          dialogBackgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white)),
      themeMode: ref.watch(themeProvider),
      debugShowCheckedModeBanner: false,
      home: const Dashboard(),
    );
  }
}
