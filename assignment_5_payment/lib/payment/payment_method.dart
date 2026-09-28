import 'payment_result.dart';

/// The general payment contract.
///
/// Order never declares `CardPayment payment;` - it depends on this
/// interface, so bKash / Nagad / PayPal can be added as new classes only.
abstract interface class PaymentMethod {
  String get name;

  /// Some methods need an extra verification step; the default is none.
  Future<bool> verify(double amount);

  Future<PaymentResult> pay(double amount);
}
