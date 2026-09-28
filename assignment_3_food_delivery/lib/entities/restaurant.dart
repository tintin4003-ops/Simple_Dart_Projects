import 'food_item.dart';

class Restaurant {
  final String name;
  final List<FoodItem> menu;

  Restaurant(this.name, this.menu);

  FoodItem? findItem(String itemName) {
    for (final item in menu) {
      if (item.name.toLowerCase() == itemName.toLowerCase()) return item;
    }
    return null;
  }

  void showMenu() {
    print("--- Menu of $name ---");
    for (final item in menu) {
      print("   ${item.name}: ${item.unitPrice.toStringAsFixed(2)} BDT");
    }
  }
}
