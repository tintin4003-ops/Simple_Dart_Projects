import 'payment_method.dart';
import 'payment_result.dart';

class CardPayment implements PaymentMethod {
  final String cardNumber;
  final double balance;

  CardPayment(this.cardNumber, this.balance);

  String get _masked => "****${cardNumber.substring(cardNumber.length - 4)}";

  @override
  String get name => "Card";

  @override
  Future<PaymentResult> pay(double amount) async {
    print("   [Card] Authorising $_masked ...");
    await Future.delayed(const Duration(seconds: 2));

    if (amount > balance) {
      return PaymentResult.failure(
          "card $_masked declined, available ${balance.toStringAsFixed(2)} BDT.");
    }
    return PaymentResult.success(
      "${amount.toStringAsFixed(2)} BDT charged to $_masked.",
      "CARD-${DateTime.now().millisecondsSinceEpoch}",
    );
  }
}
