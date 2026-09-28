import '../lib/console/input.dart';
import '../lib/entities/customer.dart';
import '../lib/entities/driver.dart';
import '../lib/payment/card_payment.dart';
import '../lib/payment/cash_payment.dart';
import '../lib/payment/mobile_banking_payment.dart';
import '../lib/payment/payment_method.dart';
import '../lib/services/booking_service.dart';
import '../lib/services/customer_service.dart';
import '../lib/services/driver_service.dart';
import '../lib/transportation/bike.dart';
import '../lib/transportation/bus.dart';
import '../lib/transportation/car.dart';
import '../lib/transportation/transportation.dart';

Future<void> main() async {
  print("=== Smart Transportation Booking System ===");
  final customers = CustomerService();
  final drivers = DriverService();
  final bookings = BookingService(customers, drivers);
  var nextCustomerId = 1;
  var nextDriverId = 1;

  // A new transportation type = add its class and one entry here.
  final transportFactories = <Transportation Function()>[
    Car.new,
    Bike.new,
    Bus.new,
  ];
  final transportOptions = transportFactories
      .map((make) => MenuOption<Transportation Function()>(make().type, make))
      .toList();

  // A new payment method = add its class and one entry here.
  final paymentOptions = <MenuOption<PaymentMethod Function()>>[
    MenuOption("Cash", () => CashPayment()),
    MenuOption("Card", () {
      final number = Input.text("Card number", minLength: 4);
      final balance = Input.number("Card available balance (BDT)", min: 0);
      return CardPayment(number, balance);
    }),
    MenuOption("Mobile Banking", () {
      final provider = Input.text("Provider (bKash / Nagad / Rocket)");
      final wallet = Input.text("Wallet number");
      final pin = Input.text("PIN (4 digits)");
      final balance = Input.number("Wallet balance (BDT)", min: 0);
      return MobileBankingPayment(provider, wallet, pin, balance);
    }),
  ];

  Future<void> customerMenu() => Input.runMenu("Customer Management", [
        MenuAction("Add customer", () async {
          final name = Input.text("Customer name");
          final phone = Input.text("Phone number");
          final id = nextCustomerId++;
          customers.addCustomer(Customer(id, name, phone));
          print("Customer ID: $id");
        }),
        MenuAction("View customers", () async => customers.viewCustomers()),
        MenuAction("Search customers", () async {
          final query = Input.text("Search by ID, name or phone");
          final found = customers.search(query);
          if (found.isEmpty) {
            print("No customer matches '$query'.");
            return;
          }
          for (final customer in found) {
            customer.displayInfo();
          }
        }),
      ], exitLabel: "Back");

  Future<void> driverMenu() => Input.runMenu("Driver Management", [
        MenuAction("Add driver", () async {
          final name = Input.text("Driver name");
          final make = Input.pick("Vehicle the driver operates", transportOptions);
          final id = nextDriverId++;
          drivers.addDriver(Driver(id, name, make().type));
          print("Driver ID: $id");
        }),
        MenuAction("View drivers", () async => drivers.viewDrivers()),
        MenuAction("Search drivers", () async {
          final query = Input.text("Search by ID, name or vehicle type");
          final found = drivers.search(query);
          if (found.isEmpty) {
            print("No driver matches '$query'.");
            return;
          }
          for (final driver in found) {
            driver.displayInfo();
          }
        }),
        MenuAction("Check driver availability for a vehicle type", () async {
          final make = Input.pick("Vehicle type", transportOptions);
          final driver = await drivers.findAvailableDriver(make().type);
          if (driver == null) {
            print("No ${make().type} driver is available.");
          } else {
            print("Available: ${driver.name} (#${driver.id})");
          }
        }),
        MenuAction("Change driver availability", () async {
          drivers.viewDrivers();
          if (nextDriverId == 1) return;
          final id = Input.integer("Driver ID", min: 1);
          final available = Input.yesNo("Is the driver available");
          drivers.setAvailability(id, available);
        }),
      ], exitLabel: "Back");

  Future<void> bookingMenu() => Input.runMenu("Booking Management", [
        MenuAction("Create a booking", () async {
          customers.viewCustomers();
          if (nextCustomerId == 1) return;
          final customerId = Input.integer("Customer ID", min: 1);
          final make = Input.pick("Transportation", transportOptions);
          final distance = Input.number("Travel distance (km)", min: 0.1);
          final createPayment = Input.pick("Payment method", paymentOptions);
          print("");
          await bookings.createBooking(
            customerId: customerId,
            transportation: make(),
            distanceKm: distance,
            payment: createPayment(),
          );
        }),
        MenuAction("Complete a trip (free the driver)", () async {
          final id = Input.integer("Booking ID", min: 1);
          bookings.completeTrip(id);
        }),
        MenuAction("View bookings", () async => bookings.viewBookings()),
      ], exitLabel: "Back");

  await Input.runMenu("Main Menu", [
    MenuAction("Customers", customerMenu),
    MenuAction("Drivers", driverMenu),
    MenuAction("Bookings", bookingMenu),
  ]);

  print("Goodbye!");
}
