import 'payment_method.dart';
import 'payment_result.dart';

class MobileBankingPayment implements PaymentMethod {
  final String provider;
  final String walletNumber;
  final String pin;
  final double balance;

  MobileBankingPayment(this.provider, this.walletNumber, this.pin, this.balance);

  @override
  String get name => provider;

  @override
  Future<PaymentResult> pay(double amount) async {
    print("   [$provider] Verifying PIN for $walletNumber ...");
    await Future.delayed(const Duration(seconds: 2));

    if (pin.length != 4) {
      return PaymentResult.failure("invalid PIN for $walletNumber.");
    }
    if (amount > balance) {
      return PaymentResult.failure("not enough balance in $walletNumber.");
    }
    return PaymentResult.success(
      "${amount.toStringAsFixed(2)} BDT sent from $walletNumber.",
      "MB-${DateTime.now().millisecondsSinceEpoch}",
    );
  }
}
