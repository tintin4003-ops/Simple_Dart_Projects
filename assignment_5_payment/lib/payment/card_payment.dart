import 'payment_method.dart';
import 'payment_result.dart';

class CardPayment implements PaymentMethod {
  final String cardNumber;
  final String cvv;
  final double creditLimit;

  CardPayment(this.cardNumber, this.cvv, this.creditLimit);

  String get _masked =>
      "**** **** **** ${cardNumber.substring(cardNumber.length - 4)}";

  @override
  String get name => "Card Payment";

  /// Card payments need a 3-D Secure style check.
  @override
  Future<bool> verify(double amount) async {
    print("[$name] Running 3-D Secure verification for $_masked ...");
    await Future.delayed(const Duration(seconds: 2));
    if (cvv.length != 3) {
      print("[$name] Invalid CVV.");
      return false;
    }
    return true;
  }

  @override
  Future<PaymentResult> pay(double amount) async {
    if (!await verify(amount)) {
      return PaymentResult.failure("card verification failed for $_masked.");
    }

    print("[$name] Contacting the bank ...");
    await Future.delayed(const Duration(seconds: 2));

    if (amount > creditLimit) {
      return PaymentResult.failure(
          "insufficient limit on $_masked (limit ${creditLimit.toStringAsFixed(2)} BDT).");
    }

    return PaymentResult.success(
      "${amount.toStringAsFixed(2)} BDT charged to $_masked.",
      "CARD-${DateTime.now().millisecondsSinceEpoch}",
    );
  }
}
