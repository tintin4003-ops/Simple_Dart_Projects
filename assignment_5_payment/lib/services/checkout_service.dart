import '../entities/order.dart';
import '../payment/payment_method.dart';

class CheckoutService {
  final List<Order> _orders = [];

  /// The whole system talks to `PaymentMethod`, never to a concrete class.
  Future<bool> checkout(Order order, PaymentMethod method) async {
    print("--- Checkout for order #${order.id} "
        "(${order.amount.toStringAsFixed(2)} BDT) using ${method.name} ---");

    try {
      final result = await method.pay(order.amount);

      if (result.success) {
        order.markPaid(method.name, result.transactionId);
        print("Payment ${result.toString()}");
      } else {
        order.markFailed();
        print("Payment ${result.toString()}");
        print("Order #${order.id} was not completed. Try another method.");
      }

      _record(order);
      return result.success;
    } catch (e) {
      order.markFailed();
      _record(order);
      print("Unexpected payment error: $e");
      return false;
    }
  }

  void _record(Order order) {
    if (!_orders.any((o) => o.id == order.id)) {
      _orders.add(order);
    }
  }

  void viewOrders() {
    if (_orders.isEmpty) {
      print("No orders.");
      return;
    }
    for (final order in _orders) {
      order.displayInfo();
      print("");
    }
  }
}
