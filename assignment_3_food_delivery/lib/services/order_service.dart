import '../entities/order.dart';

class OrderService {
  final List<Order> _orders = [];

  void placeOrder(Order order) {
    if (order.lines.isEmpty) {
      print("Order #${order.id} has no items and was not placed.");
      return;
    }
    _orders.add(order);
    print("Order #${order.id} placed for ${order.customer.name}. "
        "Total: ${order.total.toStringAsFixed(2)} BDT");
  }

  Order? searchOrder(int id) {
    for (final order in _orders) {
      if (order.id == id) return order;
    }
    return null;
  }

  void viewOrders() {
    if (_orders.isEmpty) {
      print("No orders placed yet.");
      return;
    }
    for (final order in _orders) {
      order.displayInfo();
      print("");
    }
    print("Company revenue from delivery fees: "
        "${_orders.fold(0.0, (sum, o) => sum + o.deliveryFee).toStringAsFixed(2)} BDT");
  }
}
