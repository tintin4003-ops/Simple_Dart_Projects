import 'vehicle.dart';

/// A bus is charged per hour but never more than a daily cap.
/// A completely different pricing RULE lives in the subclass,
/// not inside ParkingLot.
class Bus extends Vehicle {
  static const double dailyCap = 1200;

  Bus(String plateNumber, String ownerName) : super(plateNumber, ownerName);

  @override
  String get type => "Bus";

  @override
  double get baseFee => 100;

  @override
  double get hourlyRate => 60;

  @override
  double calculateFee(Duration parkedFor) {
    final normal = super.calculateFee(parkedFor);
    return normal > dailyCap ? dailyCap : normal;
  }
}
