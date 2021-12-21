import 'package:caship/providers/paymentProvider.dart';
import 'package:caship/views/accountsView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountsView extends ConsumerWidget {
  final _balanceFocusNode = FocusNode();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  AccountsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accounts"),
      ),
      body: ListView.builder(
        itemCount:
            ref.watch(bankAccountsProvider.select((value) => value.length)),
        padding: const EdgeInsets.all(8.0),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, position) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              shape: Theme.of(context).cardTheme.shape,
              tileColor: Theme.of(context).cardTheme.color,
              title: Text(
                ref.watch(bankAccountsProvider
                    .select((value) => value[position].name)),
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: Text(
                "Balance: ${ref.watch(bankAccountsProvider.select((value) => value[position].balance))}",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.apply(color: Colors.grey),
              ),
              trailing: const Icon(CupertinoIcons.forward),
              onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (_) => AccountView(accountIndex: position))),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => engageAddAccountBottomSheet(context, () {
          ref.read(bankAccountsProvider.notifier).addBankAccount(
              _nameController.text, double.parse(_balanceController.text));
          Navigator.pop(context);
        }),
        label: const Text("Account"),
        icon: const Icon(CupertinoIcons.add),
      ),
    );
  }

  engageAddAccountBottomSheet(BuildContext context, Function() onCreate) {
    showModalBottomSheet(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
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
                    const Text("Name"),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: TextField(
                        onEditingComplete: () =>
                            _balanceFocusNode.requestFocus(),
                        controller: _nameController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.grey,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("Initial Balance"),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: TextField(
                        focusNode: _balanceFocusNode,
                        controller: _balanceController,
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
                                color: Theme.of(context).colorScheme.background,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
