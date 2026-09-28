import 'payment_method.dart';
import 'payment_result.dart';

class CashPayment implements PaymentMethod {
  @override
  String get name => "Cash";

  @override
  Future<PaymentResult> pay(double amount) async {
    print("   [Cash] The driver will collect ${amount.toStringAsFixed(2)} BDT.");
    await Future.delayed(const Duration(seconds: 1));
    return PaymentResult.success(
      "cash will be collected after the trip.",
      "CASH-${DateTime.now().millisecondsSinceEpoch}",
    );
  }
}
