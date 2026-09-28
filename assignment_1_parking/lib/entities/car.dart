import 'vehicle.dart';

class Car extends Vehicle {
  Car(String plateNumber, String ownerName) : super(plateNumber, ownerName);

  @override
  String get type => "Car";

  @override
  double get baseFee => 50;

  @override
  double get hourlyRate => 30;
}
