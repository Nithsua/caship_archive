import 'dart:math';

import 'package:uuid/uuid.dart';

enum TransactionType {
  send,
  receive,
}

class Transaction {
  late final String _id;
  late final String _icon;
  late final String _color;
  late final String _title;
  late final DateTime _date;
  late final double _amount;
  late final TransactionType _type;
  late final String _paymentMethodId;

  String get id => _id;
  String get title => _title;
  String get icon => _icon;
  String get color => _color;
  DateTime get date => _date;
  double get amount => _amount;
  TransactionType get type => _type;
  String get paymentMethodId => _paymentMethodId;

  Transaction(
      {required String id,
      required String title,
      required double amount,
      required String paymentMethodId,
      required TransactionType type,
      required String color,
      required DateTime date,
      required String icon}) {
    _id = id;
    _title = title;
    _paymentMethodId = paymentMethodId;
    _amount = amount;
    _type = type;
    _date = date;
    _color = color;
    _icon = icon;
  }

  static Transaction newTransaction(
      {required String title,
      required double amount,
      required TransactionType type,
      String? color,
      required DateTime date,
      required String paymentMethodId,
      String? icon}) {
    return Transaction(
        id: const Uuid().v4().replaceAll("-", ""),
        title: title,
        amount: amount,
        type: type,
        paymentMethodId: paymentMethodId,
        color: color ??
            colors.keys.toList()[Random.secure().nextInt(colors.length)],
        date: date,
        icon: "bag");
  }
}

Map iconCode = <String, int>{
  "bag": 0xF57E,
};

Map<String, List<int>> colors = {
  "red": const [0xFFD32F2F, 0xFFFF8A80],
  "orange": const [0xFFF57C00, 0xFFFFD180],
  "yellow": const [0xFFFBC02D, 0xFFFFFF8D],
  "green": const [0xFF388E3C, 0xFFB9F6CA],
  "teal": const [0xFF00796B, 0xFFA7FFEB],
  "indigo": const [0xFF303F9F, 0xFF8C9EFF],
};
