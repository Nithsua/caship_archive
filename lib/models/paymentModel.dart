import 'package:uuid/uuid.dart';

extension on Uuid {
  String v4withouthyphen() {
    return v4().replaceAll("-", "");
  }
}

class BankAccount {
  late final String _id;
  late String _name;
  late double _balance;
  late List<PaymentMethod> _paymentMethods;

  BankAccount(
      {required String id,
      required String name,
      required double balance,
      List<PaymentMethod>? paymentMethods}) {
    _id = id;
    _name = name;
    _balance = balance;
    _paymentMethods = paymentMethods ?? [];
  }

  static BankAccount newBankAccount(
          {required String name, required double balance}) =>
      BankAccount(
          id: const Uuid().v4withouthyphen(), name: name, balance: balance);

  String get id => _id;
  String get name => _name;
  double get balance => _balance;
  PaymentMethod paymentMethod(int index) => _paymentMethods[index];
  int get length => _paymentMethods.length;

  double updateBalance(double by) {
    _balance += by;
    return balance;
  }

  String updateName(String name) {
    _name = name;
    return _name;
  }

  addPaymentMethod(PaymentMethod paymentMethod) {
    _paymentMethods = [..._paymentMethods, paymentMethod];
  }

  removePaymentMethod(String paymentMethodId) {
    _paymentMethods.removeWhere((element) => element._id == paymentMethodId);
  }
}

enum PaymentProcessor {
  upi,
  visa,
  mastercard,
  maestro,
  americanExpress,
  dinersClub,
  ruPay,
  other,
}

abstract class PaymentMethod {
  late final String _id;
  late final String _accountId;
  late final PaymentProcessor _paymentProcessor;

  PaymentMethod(this._id, this._accountId, this._paymentProcessor);

  String get id => _id;
  String get accountId => _accountId;
  PaymentProcessor get paymentProcessor => _paymentProcessor;
}

class UpiPayment extends PaymentMethod {
  late final String _upiId;

  UpiPayment(
      {required String id, required String upiId, required String accountId})
      : super(id, accountId, PaymentProcessor.upi) {
    _upiId = upiId;
    accountId = _accountId;
  }

  static UpiPayment newUpi(
          {required String upiId, required String accountId}) =>
      UpiPayment(
          id: const Uuid().v4withouthyphen(),
          upiId: upiId,
          accountId: accountId);

  String get upiId => _upiId;
}

class CardPayment extends PaymentMethod {
  late final String _cardNo;

  CardPayment(
      {required String id,
      required String cardNo,
      required String accountId,
      required String paymentProcessor})
      : super(
            id,
            accountId,
            (() {
              if (paymentProcessor == "PaymentProcessor.visa") {
                return PaymentProcessor.visa;
              } else if (paymentProcessor == "PaymentProcessor.mastercard") {
                return PaymentProcessor.mastercard;
              } else if (paymentProcessor == "PaymentProcessor.maestro") {
                return PaymentProcessor.maestro;
              } else if (paymentProcessor == "PaymentProcessor.dinersclub") {
                return PaymentProcessor.dinersClub;
              } else if (paymentProcessor ==
                  "PaymentProcessor.americanExpress") {
                return PaymentProcessor.americanExpress;
              } else if (paymentProcessor == "PaymentProcessor.rupay") {
                return PaymentProcessor.ruPay;
              } else if (paymentProcessor == "PaymentProcessor.upi") {
                return PaymentProcessor.upi;
              } else {
                return PaymentProcessor.other;
              }
            }())) {
    _cardNo = cardNo;
  }

  static CardPayment newCard(
          {required String cardNo,
          required String paymentProcessor,
          required String accountId}) =>
      CardPayment(
          id: const Uuid().v4withouthyphen(),
          cardNo: cardNo,
          accountId: accountId,
          paymentProcessor: paymentProcessor);

  String get cardNo => _cardNo;
}
