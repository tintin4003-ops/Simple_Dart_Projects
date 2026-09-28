import 'payment_method.dart';
import 'payment_result.dart';

/// Added by the client later. Not one existing class needed a change.
class CryptoPayment implements PaymentMethod {
  final String walletAddress;
  final double ratePerCoin;

  CryptoPayment(this.walletAddress, this.ratePerCoin);

  @override
  String get name => "Crypto Payment";

  @override
  Future<bool> verify(double amount) async {
    print("[$name] Waiting for 1 block confirmation ...");
    await Future.delayed(const Duration(seconds: 2));
    return walletAddress.startsWith("0x");
  }

  @override
  Future<PaymentResult> pay(double amount) async {
    if (!await verify(amount)) {
      return PaymentResult.failure("invalid wallet address $walletAddress.");
    }
    final coins = amount / ratePerCoin;
    return PaymentResult.success(
      "${coins.toStringAsFixed(6)} coins sent to $walletAddress.",
      "CHAIN-${DateTime.now().millisecondsSinceEpoch}",
    );
  }
}
