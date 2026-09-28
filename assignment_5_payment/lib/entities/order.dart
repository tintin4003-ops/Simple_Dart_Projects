import 'customer.dart';

enum OrderStatus { created, paid, failed }

class Order {
  final int id;
  final Customer customer;
  final Map<String, double> items;

  OrderStatus status = OrderStatus.created;
  String? transactionId;
  String? paidWith;

  Order(this.id, this.customer, this.items);

  double get amount => items.values.fold(0.0, (sum, price) => sum + price);

  void markPaid(String method, String? txnId) {
    status = OrderStatus.paid;
    paidWith = method;
    transactionId = txnId;
  }

  void markFailed() {
    status = OrderStatus.failed;
  }

  void displayInfo() {
    print("=== Order #$id ===");
    print(" Customer: ${customer.name}");
    items.forEach((name, price) {
      print("   $name: ${price.toStringAsFixed(2)} BDT");
    });
    print(" Amount  : ${amount.toStringAsFixed(2)} BDT");
    print(" Status  : ${status.name}");
    if (status == OrderStatus.paid) {
      print(" Paid via: $paidWith (txn $transactionId)");
    }
  }
}
