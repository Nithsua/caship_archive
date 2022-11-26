import 'package:caship/models/paymentModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BankAccountNotifier extends StateNotifier<List<BankAccount>> {
  BankAccountNotifier() : super([]);

  addBankAccount(String name, double balance) {
    state = [
      ...state,
      BankAccount.newBankAccount(name: name, balance: balance)
    ];
  }

  addPaymentMethod(int index, String id, PaymentProcessor paymentProcessor) {
    final accountId = state[index].id;
    if (paymentProcessor == PaymentProcessor.upi) {
      state[index]
          .addPaymentMethod(UpiPayment.newUpi(upiId: id, accountId: accountId));
    } else {
      state[index].addPaymentMethod(CardPayment.newCard(
          cardNo: id,
          paymentProcessor: paymentProcessor.toString(),
          accountId: accountId));
    }
  }

  updateBalanceById(String id, double by) {
    for (int i = 0; i < state.length; i++) {
      if (state[i].id == id) {
        state[i].updateBalance(by);
      }
    }
  }

  updateBalance(int index, double by) {
    state[index].updateBalance(by);
  }

  changeName(int index, String name) {
    state[index].updateName(name);
  }

  List<BankAccount> list() => state.map((e) => e).toList();
}

final bankAccountsProvider =
    StateNotifierProvider<BankAccountNotifier, List<BankAccount>>(
        (ref) => BankAccountNotifier());
