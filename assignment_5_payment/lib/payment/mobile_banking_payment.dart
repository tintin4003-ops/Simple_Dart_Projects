import 'payment_method.dart';
import 'payment_result.dart';

class MobileBankingPayment implements PaymentMethod {
  final String provider;
  final String walletNumber;
  final String otp;
  final double balance;

  MobileBankingPayment(
      this.provider, this.walletNumber, this.otp, this.balance);

  @override
  String get name => "$provider Mobile Banking";

  @override
  Future<bool> verify(double amount) async {
    print("[$name] Sending OTP to $walletNumber ...");
    await Future.delayed(const Duration(seconds: 2));
    final valid = otp.length == 6 && int.tryParse(otp) != null;
    print(valid ? "[$name] OTP accepted." : "[$name] OTP rejected.");
    return valid;
  }

  @override
  Future<PaymentResult> pay(double amount) async {
    if (!await verify(amount)) {
      return PaymentResult.failure("OTP verification failed for $walletNumber.");
    }

    print("[$name] Transferring money ...");
    await Future.delayed(const Duration(seconds: 1));

    if (amount > balance) {
      return PaymentResult.failure(
          "not enough balance in $walletNumber (available ${balance.toStringAsFixed(2)} BDT).");
    }

    return PaymentResult.success(
      "${amount.toStringAsFixed(2)} BDT sent from $walletNumber.",
      "MB-${DateTime.now().millisecondsSinceEpoch}",
    );
  }
}
