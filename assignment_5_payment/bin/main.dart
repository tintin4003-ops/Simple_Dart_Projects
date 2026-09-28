import '../lib/console/input.dart';
import '../lib/entities/customer.dart';
import '../lib/entities/order.dart';
import '../lib/payment/card_payment.dart';
import '../lib/payment/cash_on_delivery.dart';
import '../lib/payment/crypto_payment.dart';
import '../lib/payment/mobile_banking_payment.dart';
import '../lib/payment/payment_method.dart';
import '../lib/services/checkout_service.dart';

Future<void> main() async {
  print("=== Online Payment System ===");
  final checkout = CheckoutService();
  final customers = <Customer>[];
  final orders = <Order>[];
  var nextCustomerId = 1;
  var nextOrderId = 1;

  // Each option asks for the details that payment method needs, then builds
  // it. A new method (PayPal, Nagad ...) = one more entry here + its class.
  final paymentOptions = <MenuOption<PaymentMethod Function()>>[
    MenuOption("Cash on Delivery", () => CashOnDelivery()),
    MenuOption("Card Payment", () {
      final number = Input.text("Card number", minLength: 4);
      final cvv = Input.text("CVV (3 digits)");
      final limit = Input.number("Card credit limit (BDT)", min: 0);
      return CardPayment(number, cvv, limit);
    }),
    MenuOption("Mobile Banking", () {
      final provider = Input.text("Provider (bKash / Nagad / Rocket)");
      final wallet = Input.text("Wallet number");
      final otp = Input.text("OTP (6 digits)");
      final balance = Input.number("Wallet balance (BDT)", min: 0);
      return MobileBankingPayment(provider, wallet, otp, balance);
    }),
    MenuOption("Crypto Payment", () {
      final address = Input.text("Wallet address (must start with 0x)");
      final rate = Input.number("BDT price of one coin", min: 0.01);
      return CryptoPayment(address, rate);
    }),
  ];

  await Input.runMenu("Payment Menu", [
    MenuAction("Add customer", () async {
      final name = Input.text("Customer name");
      final email = Input.text("Email");
      final id = nextCustomerId++;
      customers.add(Customer(id, name, email));
      print("$name added with ID $id.");
    }),
    MenuAction("Create an order", () async {
      if (customers.isEmpty) {
        print("Add a customer first.");
        return;
      }
      final customer = Input.pick("Customer",
          customers.map((c) => MenuOption("${c.name} (#${c.id})", c)).toList());

      final items = <String, double>{};
      do {
        final name = Input.text("Item name");
        final price = Input.number("Item price (BDT)", min: 0.01);
        items[name] = price;
      } while (Input.yesNo("Add another item"));

      final order = Order(nextOrderId++, customer, items);
      orders.add(order);
      print("");
      order.displayInfo();
    }),
    MenuAction("Pay for an order", () async {
      final payable =
          orders.where((o) => o.status != OrderStatus.paid).toList();
      if (payable.isEmpty) {
        print("There are no unpaid orders.");
        return;
      }
      final order = Input.pick(
        "Order to pay",
        payable
            .map((o) => MenuOption(
                "Order #${o.id} - ${o.customer.name} - "
                "${o.amount.toStringAsFixed(2)} BDT (${o.status.name})",
                o))
            .toList(),
      );
      final createMethod = Input.pick("Payment method", paymentOptions);
      print("");
      await checkout.checkout(order, createMethod());
    }),
    MenuAction("View all orders", () async {
      if (orders.isEmpty) {
        print("No orders yet.");
        return;
      }
      for (final order in orders) {
        order.displayInfo();
        print("");
      }
    }),
  ]);

  print("Goodbye!");
}
