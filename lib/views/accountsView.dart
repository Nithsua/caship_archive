import 'package:caship/models/paymentModel.dart';
import 'package:caship/providers/paymentProvider.dart';
import 'package:caship/providers/themeProvider.dart';
import 'package:caship/views/homeView.dart';
import 'package:caship/widgets/expandableFab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension on String {
  String nameCase() {
    return substring(0, 1).toUpperCase() + substring(1);
  }
}

class SelectedPaymentProcessor extends StateNotifier<PaymentProcessor> {
  SelectedPaymentProcessor() : super(PaymentProcessor.mastercard);

  changePaymentProcessor(PaymentProcessor paymentProcessor) =>
      state = paymentProcessor;

  reset() => state = PaymentProcessor.mastercard;
}

final paymentProcessorProvider =
    StateNotifierProvider<SelectedPaymentProcessor, PaymentProcessor>(
        (ref) => SelectedPaymentProcessor());

class AccountView extends ConsumerWidget {
  final int accountIndex;
  final idController = TextEditingController();

  AccountView({Key? key, required this.accountIndex}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text(ref.watch(bankAccountsProvider
              .select((value) => value[accountIndex].name))),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ref.watch(bankAccountsProvider
                              .select((value) => value[accountIndex].name)),
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                            "Balance: ${ref.watch(bankAccountsProvider.select((value) => value[accountIndex].balance))}",
                            style: Theme.of(context).textTheme.subtitle1),
                        const SizedBox(height: 20),
                        Text(
                          "Payment Methods",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 200,
                          child: ref.watch(bankAccountsProvider.select(
                                      (value) => value[accountIndex].length)) >
                                  0
                              ? PageView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: ref.watch(
                                      bankAccountsProvider.select((value) =>
                                          value[accountIndex].length)),
                                  itemBuilder: (context, position) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      child: PaymentCard(
                                          no: ref.watch(bankAccountsProvider.select((value) => value[accountIndex]
                                                      .paymentMethod(position)
                                                      .paymentProcessor ==
                                                  PaymentProcessor.upi
                                              ? (value[accountIndex].paymentMethod(position)
                                                      as UpiPayment)
                                                  .upiId
                                              : (value[accountIndex].paymentMethod(position)
                                                      as CardPayment)
                                                  .cardNo)),
                                          paymentProcessor: ref.watch(
                                              bankAccountsProvider.select((value) => value[accountIndex].paymentMethod(position).paymentProcessor))),
                                    );
                                  })
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: ref.watch(themeProvider) ==
                                                        ThemeMode.dark ||
                                                    MediaQuery.of(context)
                                                            .platformBrightness ==
                                                        Brightness.dark
                                                ? [
                                                    Colors.white38,
                                                    Colors.white10
                                                  ]
                                                : [
                                                    Colors.black54,
                                                    Colors.black
                                                  ])),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("No Payment Methods Available",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    ?.apply(
                                                        color: Colors.white)),
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                false
                    ? Column(
                        children: [
                          Text(
                            "Transactions",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          const SizedBox(height: 5),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: ref.watch(bankAccountsProvider.select(
                                  (value) => value[accountIndex].length)),
                              itemBuilder: (context, position) {
                                return ListTile(
                                  shape: Theme.of(context).cardTheme.shape,
                                  tileColor: Theme.of(context).cardTheme.color,
                                  title: Text(ref.watch(bankAccountsProvider
                                      .select((value) => value[accountIndex]
                                                  .paymentMethod(position)
                                                  .paymentProcessor ==
                                              PaymentProcessor.upi
                                          ? (value[accountIndex]
                                                      .paymentMethod(position)
                                                  as UpiPayment)
                                              .upiId
                                          : (value[accountIndex]
                                                      .paymentMethod(position)
                                                  as CardPayment)
                                              .cardNo))),
                                  trailing: Image.asset(
                                    getPaymentProcessorLogo(ref.watch(
                                        bankAccountsProvider.select((value) =>
                                            value[accountIndex]
                                                .paymentMethod(position)
                                                .paymentProcessor))),
                                    width: 60,
                                    height: 60,
                                  ),
                                );
                              }),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        floatingActionButton: ExpandableFab(distance: 80, children: [
          ActionButton(
              toolTip: "Credit/Debit",
              icon: const Icon(CupertinoIcons.creditcard),
              onPressed: () => showAddCardBottomSheet(
                      context,
                      DropdownButton<PaymentProcessor>(
                        icon: const Icon(CupertinoIcons.creditcard),
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(15.0),
                        value: ref.watch(paymentProcessorProvider),
                        items: PaymentProcessor.values
                            .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                    e.toString().split(".")[1].nameCase())))
                            .toList(),
                        onChanged: (PaymentProcessor? paymentProcessor) => ref
                            .read(paymentProcessorProvider.notifier)
                            .changePaymentProcessor(paymentProcessor!),
                      ), () {
                    print(ref.watch(paymentProcessorProvider));
                    ref.read(bankAccountsProvider.notifier).addPaymentMethod(
                        accountIndex,
                        idController.text,
                        ref.watch(paymentProcessorProvider));
                    idController.clear();
                    ref.read(paymentProcessorProvider.notifier).reset();
                    Navigator.pop(context);
                  })),
          ActionButton(
            toolTip: "UPI",
            icon: const Icon(Icons.fast_forward_outlined),
            onPressed: () => showAddUpiBottomSheet(context, () {
              ref.read(bankAccountsProvider.notifier).addPaymentMethod(
                  accountIndex, idController.text, PaymentProcessor.upi);
              idController.clear();
              Navigator.pop(context);
            }),
          ),
        ]));
  }

  showAddUpiBottomSheet(BuildContext context, Function() onCreate) {
    showModalBottomSheet(
        context: context,
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(CupertinoIcons.xmark),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("UPI id"),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: TextField(
                          controller: idController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.grey,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: MaterialButton(
                      shape: Theme.of(context).cardTheme.shape,
                      color: Theme.of(context).colorScheme.onBackground,
                      onPressed: onCreate,
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Create",
                            style: Theme.of(context).textTheme.headline5?.apply(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )));
        });
  }

  showAddCardBottomSheet(
      BuildContext context, Widget child, Function() onCreate) {
    showModalBottomSheet(
        context: context,
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(CupertinoIcons.xmark),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("Last 4 digits of Card#"),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: TextField(
                          controller: idController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.grey,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Payment Processor"),
                      const SizedBox(height: 5),
                      child,
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: MaterialButton(
                      shape: Theme.of(context).cardTheme.shape,
                      color: Theme.of(context).colorScheme.onBackground,
                      onPressed: onCreate,
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Create",
                            style: Theme.of(context).textTheme.headline5?.apply(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )));
        });
  }
}
