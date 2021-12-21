import 'package:caship/models/transactionModel.dart';
import 'package:caship/models/paymentModel.dart';
import 'package:caship/providers/paymentProvider.dart';
import 'package:caship/providers/themeProvider.dart';
import 'package:caship/providers/transactionProvider.dart';
import 'package:caship/providers/userProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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

class HomeView extends ConsumerWidget {
  final PageController _pageController =
      PageController(viewportFraction: 0.90, initialPage: 0);

  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NestedScrollView(
      headerSliverBuilder: (_, isScrolled) => [
        SliverAppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            floating: false,
            title: RichText(
                text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText1,
                    text: "${getStateOfTheDay()}\n",
                    children: [
                  TextSpan(
                    text: ref.watch(userProvider.select((value) => value.name)),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ])))
      ],
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            (() {
              List<Widget> temp = [];
              final list = ref.watch(bankAccountsProvider.notifier).list();
              for (int i = 0; i < list.length; i++) {
                final bankAccount = list[i];
                for (int j = 0; j < bankAccount.length; j++) {
                  final paymentMethod = bankAccount.paymentMethod(j);
                  temp.add(Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: PaymentCard(
                        no: (paymentMethod.paymentProcessor ==
                                PaymentProcessor.upi
                            ? (paymentMethod as UpiPayment).upiId
                            : (paymentMethod as CardPayment).cardNo),
                        balance: bankAccount.balance,
                        paymentProcessor: paymentMethod.paymentProcessor),
                  ));
                }
              }

              return temp.isNotEmpty
                  ? SizedBox(
                      height: 200,
                      child: PageView(
                        physics: const BouncingScrollPhysics(),
                        controller: _pageController,
                        children: temp,
                      ),
                    )
                  : Container();
            }()),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
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
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: ref.watch(transactionsNotifierProvider).length,
                      itemBuilder: (_, position) {
                        final transaction = ref
                            .watch(transactionsNotifierProvider.notifier)
                            .transaction(position);
                        return TransactionTile(
                          transaction: transaction,
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  const TransactionTile({Key? key, required this.transaction})
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
            color: Color(colors[transaction.color]![0]),
          ),
          backgroundColor: Color(colors[transaction.color]![1]),
        ),
        tileColor: Theme.of(context).cardTheme.color,
        shape: Theme.of(context).cardTheme.shape,
        title: Text(
          transaction.title,
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.apply(fontSizeDelta: -2, fontWeightDelta: 2),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            DateFormat("d MMM yyyy").format(transaction.date),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        trailing: Text(
          "\$${transaction.amount}",
          style:
              Theme.of(context).textTheme.subtitle1?.apply(fontWeightDelta: 4),
        ),
      ),
    );
  }
}

class PaymentCard extends ConsumerWidget {
  final String no;
  final PaymentProcessor paymentProcessor;
  final double? balance;

  const PaymentCard(
      {Key? key,
      required this.no,
      this.balance,
      required this.paymentProcessor})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: ref.watch(themeProvider) == ThemeMode.dark ||
                        MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                    ? [Colors.white38, Colors.white10]
                    : [Colors.black54, Colors.black])),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                                text: TextSpan(
                                    text: "\$5000",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.apply(color: Colors.white),
                                    children: [
                                  TextSpan(
                                    text: balance != null
                                        ? " / \$$balance\n"
                                        : "\n",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.apply(color: Colors.white),
                                  ),
                                  TextSpan(
                                    text:
                                        "Amount Spent (${DateFormat("MMM").format(DateTime.now())})" +
                                            (balance != null
                                                ? " / Balance"
                                                : ""),
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        ?.apply(color: Colors.grey),
                                  )
                                ])),
                            Image.asset(
                              getPaymentProcessorLogo(paymentProcessor),
                              height: 50,
                              width: 50,
                            ),
                          ],
                        ),
                        Text(
                            paymentProcessor == PaymentProcessor.upi
                                ? no
                                : "xxxx xxxx xxxx $no",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                  letterSpacing:
                                      paymentProcessor == PaymentProcessor.upi
                                          ? 1.0
                                          : 4.0,
                                  color: Colors.white,
                                )),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

String getPaymentProcessorLogo(PaymentProcessor paymentProcessor) {
  String temp = "assets/images/payment_processors/";
  if (paymentProcessor == PaymentProcessor.visa) {
    temp += "visa.png";
  } else if (paymentProcessor == PaymentProcessor.mastercard) {
    temp += "mastercard.png";
  } else if (paymentProcessor == PaymentProcessor.maestro) {
    temp += "maestro.png";
  } else if (paymentProcessor == PaymentProcessor.americanExpress) {
    temp += "amex.png";
  } else {
    temp += "upi.png";
  }
  return temp;
}
