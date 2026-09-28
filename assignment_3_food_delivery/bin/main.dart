import '../lib/console/input.dart';
import '../lib/delivery/delivery_method.dart';
import '../lib/delivery/express_delivery.dart';
import '../lib/delivery/free_delivery.dart';
import '../lib/delivery/regular_delivery.dart';
import '../lib/entities/customer.dart';
import '../lib/entities/food_item.dart';
import '../lib/entities/order.dart';
import '../lib/entities/restaurant.dart';
import '../lib/services/order_service.dart';

Future<void> main() async {
  print("=== Food Delivery Management System ===");
  final service = OrderService();
  final restaurants = <Restaurant>[];
  final customers = <Customer>[];
  var nextCustomerId = 1;
  var nextOrderId = 1;

  // Adding SameDayDelivery / InternationalDelivery = one more line here.
  final deliveryOptions = <MenuOption<DeliveryMethod Function()>>[
    MenuOption("Regular Delivery", RegularDelivery.new),
    MenuOption("Express Delivery", ExpressDelivery.new),
    MenuOption("Free Delivery (orders of 1000 BDT+, otherwise regular fee)",
        () => FreeDelivery(RegularDelivery())),
  ];

  await Input.runMenu("Food Delivery Menu", [
    MenuAction("Add restaurant with menu", () async {
      final name = Input.text("Restaurant name");
      final items = <FoodItem>[];
      do {
        final itemName = Input.text("Food item name");
        final price = Input.number("Price (BDT)", min: 0.01);
        items.add(FoodItem(itemName, price));
      } while (Input.yesNo("Add another item"));
      restaurants.add(Restaurant(name, items));
      print("$name added with ${items.length} item(s).");
    }),
    MenuAction("Add customer", () async {
      final name = Input.text("Customer name");
      final address = Input.text("Delivery address");
      final id = nextCustomerId++;
      customers.add(Customer(id, name, address));
      print("$name added with ID $id.");
    }),
    MenuAction("View restaurants and menus", () async {
      if (restaurants.isEmpty) {
        print("No restaurants yet.");
        return;
      }
      for (final restaurant in restaurants) {
        restaurant.showMenu();
      }
    }),
    MenuAction("Place an order", () async {
      if (customers.isEmpty || restaurants.isEmpty) {
        print("Add at least one customer and one restaurant first.");
        return;
      }
      final customer = Input.pick("Customer",
          customers.map((c) => MenuOption("${c.name} (#${c.id})", c)).toList());
      final restaurant = Input.pick("Restaurant",
          restaurants.map((r) => MenuOption(r.name, r)).toList());
      final distance = Input.number("Distance to customer (km)", min: 0.1);
      final createDelivery = Input.pick("Delivery method", deliveryOptions);

      final order = Order(
          nextOrderId, customer, restaurant, distance, createDelivery());

      restaurant.showMenu();
      while (true) {
        final itemName = Input.optional("Item name (press Enter to finish)");
        if (itemName.isEmpty) break;
        final qty = Input.integer("Quantity", min: 1);
        if (order.addItem(itemName, qty)) print("  Added.");
      }

      if (order.lines.isEmpty) {
        print("No items chosen. Order cancelled.");
        return;
      }
      print("");
      order.displayInfo();
      if (Input.yesNo("Place this order")) {
        service.placeOrder(order);
        nextOrderId++;
      } else {
        print("Order discarded.");
      }
    }),
    MenuAction("View all orders", () async => service.viewOrders()),
  ]);

  print("Goodbye!");
}
