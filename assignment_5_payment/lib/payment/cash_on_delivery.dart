import 'payment_method.dart';
import 'payment_result.dart';

class CashOnDelivery implements PaymentMethod {
  static const double limit = 20000;

  @override
  String get name => "Cash on Delivery";

  @override
  Future<bool> verify(double amount) async => amount <= limit;

  @override
  Future<PaymentResult> pay(double amount) async {
    print("[$name] Reserving the order ...");
    await Future.delayed(const Duration(seconds: 1));

    if (!await verify(amount)) {
      return PaymentResult.failure(
          "cash on delivery is not allowed above ${limit.toStringAsFixed(0)} BDT.");
    }

    return PaymentResult.success(
      "collect ${amount.toStringAsFixed(2)} BDT from the customer at delivery.",
      "COD-${DateTime.now().millisecondsSinceEpoch}",
    );
  }
}
