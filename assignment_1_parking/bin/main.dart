import '../lib/console/input.dart';
import '../lib/entities/bus.dart';
import '../lib/entities/car.dart';
import '../lib/entities/motorcycle.dart';
import '../lib/entities/vehicle.dart';
import '../lib/services/parking_lot.dart';

Future<void> main() async {
  print("=== Smart Parking Management System ===");
  final lotName = Input.text("Parking area name");
  final capacity = Input.integer("Number of parking slots", min: 1);
  final lot = ParkingLot(lotName, capacity);

  // Adding a new vehicle type = one more line here (plus its class).
  final vehicleTypes = <MenuOption<Vehicle Function(String, String)>>[
    MenuOption("Car", Car.new),
    MenuOption("Motorcycle", Motorcycle.new),
    MenuOption("Bus", Bus.new),
  ];

  await Input.runMenu("Parking Menu", [
    MenuAction("Park a vehicle", () async {
      final create = Input.pick("Vehicle type", vehicleTypes);
      final plate = Input.text("Plate number");
      final owner = Input.text("Owner name");
      lot.parkVehicle(create(plate, owner));
    }),
    MenuAction("Vehicle leaves (calculate fee)", () async {
      lot.viewParkedVehicles();
      if (lot.activeTickets.isEmpty) return;
      final plate = Input.text("Plate number of the leaving vehicle");
      final extra = Input.integer(
          "Extra minutes to add for testing (0 = real time)",
          min: 0);
      lot.releaseVehicle(plate,
          exitTime: DateTime.now().add(Duration(minutes: extra)));
    }),
    MenuAction("View currently parked vehicles", () async {
      lot.viewParkedVehicles();
    }),
    MenuAction("View all tickets and earnings", () async {
      lot.viewHistory();
    }),
  ]);

  print("Goodbye!");
}
