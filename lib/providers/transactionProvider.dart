import 'package:caship/models/transactionModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionsNotifier extends StateNotifier<List<Transaction>> {
  TransactionsNotifier() : super([]);

  addTransaction(
      String title, double amount, TransactionType type, DateTime date) {
    state.add(Transaction.newTransaction(
        title: title, amount: amount, type: type, date: date));
  }

  Transaction transaction(int index) => state[index];
}

final transactionsNotifierProvider =
    StateNotifierProvider<TransactionsNotifier, List<Transaction>>(
        (ref) => TransactionsNotifier());
