import 'package:caship/models/paymentModel.dart';
import 'package:caship/models/transactionModel.dart';
import 'package:caship/providers/paymentProvider.dart';
import 'package:caship/providers/themeProvider.dart';
import 'package:caship/providers/transactionProvider.dart';
import 'package:caship/views/homeView.dart';
import 'package:caship/views/profileView.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BottomNavigationBarStateNotifier extends StateNotifier<int> {
  BottomNavigationBarStateNotifier({int initial = 0}) : super(initial);

  changeNavigation(int navigation) {
    state = navigation;
  }
}

final bottomNavigationBarStateProvider =
    StateNotifierProvider<BottomNavigationBarStateNotifier, int>(
        (ref) => BottomNavigationBarStateNotifier(initial: 0));

class Dashboard extends ConsumerWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: SafeArea(
          child: [
            HomeView(),
            const ProfileView()
          ][ref.watch(bottomNavigationBarStateProvider)],
        ),
        bottomNavigationBar: Material(
          // shape: const RoundedRectangleBorder(
          //     borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(15.0),
          //   topRight: Radius.circular(15.0),
          // )),
          color: Theme.of(context).cardTheme.color,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: ref.watch(bottomNavigationBarStateProvider) == 0
                      ? const Icon(CupertinoIcons.house_alt_fill)
                      : const Icon(CupertinoIcons.house_alt),
                  tooltip: "Home",
                  onPressed: () => ref
                      .read(bottomNavigationBarStateProvider.notifier)
                      .changeNavigation(0),
                ),
                FloatingActionButton(
                    child: const Icon(CupertinoIcons.add),
                    onPressed: () => showModalBottomSheet(
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.9),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0))),
                          context: context,
                          builder: (context) => const NewTransactionButton(),
                        )),
                IconButton(
                  icon: ref.watch(bottomNavigationBarStateProvider) == 1
                      ? const Icon(CupertinoIcons.person_fill)
                      : const Icon(CupertinoIcons.person),
                  tooltip: "Person",
                  onPressed: () => ref
                      .read(bottomNavigationBarStateProvider.notifier)
                      .changeNavigation(1),
                ),
              ],
            ),
          ),
        ));
  }
}

class NewTransactionButton extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewTransactionButtonState();

  const NewTransactionButton({Key? key}) : super(key: key);
}

class _NewTransactionButtonState extends ConsumerState<NewTransactionButton> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  late DateTime dateTime;
  late final TextEditingController _dateController;
  final _pageController = PageController(initialPage: 0, viewportFraction: 0.9);

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
    _dateController =
        TextEditingController(text: DateFormat("d MMM y").format(dateTime));
  }

  @override
  Widget build(BuildContext context) {
    List<Map<PaymentMethod, BankAccount>> temp = [];
    final list = ref.watch(bankAccountsProvider.notifier).list();
    for (int i = 0; i < list.length; i++) {
      final bankAccount = list[i];
      for (int j = 0; j < bankAccount.length; j++) {
        temp.add({bankAccount.paymentMethod(j): bankAccount});
      }
    }

    return FractionallySizedBox(
      heightFactor: 0.9,
      child: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
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
                      const Text("Title"),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.grey,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Amount"),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: TextField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.grey,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("Payment Methods"),
                  const SizedBox(height: 5),
                  temp.isNotEmpty
                      ? SizedBox(
                          height: 200,
                          child: PageView(
                              physics: const BouncingScrollPhysics(),
                              controller: _pageController,
                              children: temp
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: PaymentCard(
                                            no: (e.keys.first
                                                        .paymentProcessor ==
                                                    PaymentProcessor.upi
                                                ? (e.keys.first as UpiPayment)
                                                    .upiId
                                                : (e.keys.first as CardPayment)
                                                    .cardNo),
                                            balance: e.values.first.balance,
                                            paymentProcessor:
                                                e.keys.first.paymentProcessor),
                                      ))
                                  .toList()),
                        )
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
                                          ? [Colors.white38, Colors.white10]
                                          : [Colors.black54, Colors.black])),
                              child: SizedBox(
                                height: 200,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text("No Payment Method Setup")
                                      ],
                                    ))
                                  ],
                                ),
                              ))),
                  const SizedBox(height: 10),
                  const Text("Date"),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: GestureDetector(
                      onTap: () async {
                        final currentDate = DateTime.now();
                        final temp = await showDatePicker(
                            builder: (context, child) => ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: child,
                                ),
                            context: context,
                            initialDate: currentDate,
                            firstDate: currentDate,
                            lastDate: currentDate.add(const Duration(days: 7)));

                        if (temp != null) {
                          setState(() {
                            dateTime = temp;
                          });
                        }
                      },
                      child: TextField(
                        enabled: false,
                        showCursor: false,
                        keyboardType: TextInputType.none,
                        decoration: InputDecoration(
                          hintText: DateFormat("d MMM y").format(dateTime),
                          filled: true,
                          fillColor: Colors.grey,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: MaterialButton(
                      shape: Theme.of(context).cardTheme.shape,
                      color: Theme.of(context).colorScheme.onBackground,
                      onPressed: temp.isNotEmpty
                          ? () {
                              final PaymentMethod selectedPaymentMethod =
                                  temp[_pageController.page!.toInt()]
                                      .keys
                                      .first;
                              final amount =
                                  double.parse(_amountController.text) * -1;
                              ref
                                  .read(bankAccountsProvider.notifier)
                                  .updateBalanceById(
                                      selectedPaymentMethod.accountId, amount);
                              ref
                                  .read(transactionsNotifierProvider.notifier)
                                  .addTransaction(
                                      _titleController.text,
                                      amount,
                                      TransactionType.send,
                                      dateTime,
                                      selectedPaymentMethod.id);
                              Navigator.pop(context);
                            }
                          : null,
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
              )),
            )),
      ),
    );
  }
}
