import '../delivery/delivery_method.dart';
import 'customer.dart';
import 'food_item.dart';
import 'order_line.dart';
import 'restaurant.dart';

/// Order knows its own items and totals, but it does NOT know how a
/// delivery fee is computed. It asks the delivery method for that number.
class Order {
  final int id;
  final Customer customer;
  final Restaurant restaurant;
  final double distanceKm;
  final DeliveryMethod delivery;
  final List<OrderLine> _lines = [];

  static const double vatRate = 0.05;

  Order(this.id, this.customer, this.restaurant, this.distanceKm, this.delivery);

  List<OrderLine> get lines => List.unmodifiable(_lines);

  bool addItem(String itemName, int quantity) {
    final FoodItem? item = restaurant.findItem(itemName);
    if (item == null) {
      print("$itemName is not on the menu of ${restaurant.name}.");
      return false;
    }
    if (quantity <= 0) {
      print("Quantity must be at least 1.");
      return false;
    }
    _lines.add(OrderLine(item, quantity));
    return true;
  }

  double get subtotal => _lines.fold(0.0, (sum, line) => sum + line.total);

  double get vat => subtotal * vatRate;

  double get deliveryFee => delivery.calculateFee(subtotal, distanceKm);

  double get total => subtotal + vat + deliveryFee;

  void displayInfo() {
    print("=== Order #$id ===");
    print(" Customer : ${customer.name} (${customer.address})");
    print(" From     : ${restaurant.name}, ${distanceKm.toStringAsFixed(1)} km away");
    print(" Items:");
    if (_lines.isEmpty) {
      print("   (empty)");
    } else {
      for (final line in _lines) {
        line.displayInfo();
      }
    }
    print(" Subtotal : ${subtotal.toStringAsFixed(2)} BDT");
    print(" VAT (5%) : ${vat.toStringAsFixed(2)} BDT");
    print(" Delivery : ${delivery.name} -> ${deliveryFee.toStringAsFixed(2)} BDT "
        "(approx ${delivery.estimatedTime.inMinutes} min)");
    print(" TOTAL    : ${total.toStringAsFixed(2)} BDT");
  }
}
