import 'package:expense_boi/providers/themeProvider.dart';
import 'package:expense_boi/providers/userProvider.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(const ProviderScope(child: MyApp())));
}

String getStateOfTheDay() {
  final hour = DateTime.now().hour;
  if (hour >= 16) {
    return "Good Evening";
  } else if (hour >= 12) {
    return "Good Afternoon";
  } else {
    return "Good Morning";
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData(
          backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
              systemNavigationBarDividerColor: Colors.white,
            ),
            color: Colors.white,
            elevation: 0.0,
            toolbarTextStyle: Theme.of(context).textTheme.subtitle1,
            titleTextStyle: Theme.of(context).textTheme.subtitle1,
          ),
          textTheme: Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.black, displayColor: Colors.black),
          cardTheme: CardTheme(
              elevation: 0.0,
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)))),
      darkTheme: ThemeData.dark(),
      themeMode: ref.watch(themeProvider),
      debugShowCheckedModeBanner: false,
      home: const Dashboard(),
    );
  }
}

class Dashboard extends ConsumerWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, isScrolled) => [
          SliverAppBar(
              centerTitle: false,
              floating: false,
              title: RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      text: "${getStateOfTheDay()}\n",
                      children: [
                    TextSpan(
                      text:
                          ref.watch(userProvider.select((value) => value.name)),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ])))
        ],
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const PaymentCard(),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Transactions",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.greenAccent[100],
                                child: Icon(
                                  Icons.trending_up,
                                  color: Colors.green[700],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "+24%",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.apply(
                                            color: Colors.greenAccent,
                                          ),
                                    ),
                                    const Text("Income"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.orangeAccent[100],
                                child: Icon(
                                  Icons.trending_down,
                                  color: Colors.orange[700],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "-42%",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.apply(
                                            color: Colors.orangeAccent,
                                          ),
                                    ),
                                    const Text("Expense"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    TransactionHistoryTile(
                        title: "Digital Ocean",
                        date: DateTime.now(),
                        amount: 130.0),
                    TransactionHistoryTile(
                        title: "Digital Ocean",
                        date: DateTime.now(),
                        amount: 130.0),
                    TransactionHistoryTile(
                        title: "Digital Ocean",
                        date: DateTime.now(),
                        amount: 130.0),
                    TransactionHistoryTile(
                        title: "Digital Ocean",
                        date: DateTime.now(),
                        amount: 130.0),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionHistoryTile extends StatelessWidget {
  final String title;
  final DateTime date;
  final double amount;
  const TransactionHistoryTile(
      {Key? key, required this.title, required this.date, required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        leading: CircleAvatar(
          child: Icon(
            CupertinoIcons.bag,
            color: Colors.red.shade700,
          ),
          backgroundColor: Colors.redAccent.shade100,
        ),
        tileColor: Theme.of(context).cardTheme.color,
        shape: Theme.of(context).cardTheme.shape,
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.apply(fontSizeDelta: -2, fontWeightDelta: 2),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            DateFormat("d MMM yyyy").format(date),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        trailing: Text(
          "\$$amount",
          style:
              Theme.of(context).textTheme.subtitle1?.apply(fontWeightDelta: 4),
        ),
      ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  const PaymentCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.black,
        child: SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(
                                text: "\$5000\n",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.apply(color: Colors.white),
                                children: [
                              TextSpan(
                                text: "Amount Spent this month",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.apply(color: Colors.grey),
                              )
                            ])),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "xxxx xxxx xxxx " + "4567",
                              style:
                                  Theme.of(context).textTheme.subtitle1?.apply(
                                        color: Colors.white,
                                      ),
                            ),
                            Image.asset(
                              "assets/images/mastercard.png",
                              height: 50,
                              width: 50,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
