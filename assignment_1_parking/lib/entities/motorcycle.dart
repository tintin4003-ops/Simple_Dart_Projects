import 'vehicle.dart';

class Motorcycle extends Vehicle {
  Motorcycle(String plateNumber, String ownerName) : super(plateNumber, ownerName);

  @override
  String get type => "Motorcycle";

  @override
  double get baseFee => 20;

  @override
  double get hourlyRate => 10;
}
