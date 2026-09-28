import 'food_item.dart';

/// One line of an order: which item and how many.
class OrderLine {
  final FoodItem item;
  final int quantity;

  OrderLine(this.item, this.quantity);

  double get total => item.unitPrice * quantity;

  void displayInfo() {
    print("   ${item.name} x$quantity = ${total.toStringAsFixed(2)} BDT");
  }
}
