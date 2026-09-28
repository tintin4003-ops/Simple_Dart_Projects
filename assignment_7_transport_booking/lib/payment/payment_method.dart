import 'payment_result.dart';

abstract interface class PaymentMethod {
  String get name;

  Future<PaymentResult> pay(double amount);
}
