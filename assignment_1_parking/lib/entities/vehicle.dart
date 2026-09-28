/// Common parent for every vehicle the mall may ever support.
///
/// A vehicle knows how much it costs to park ITSELF. The parking lot only
/// knows about `Vehicle`, so adding a Truck or Van later requires no change
/// inside ParkingLot.
abstract class Vehicle {
  final String plateNumber;
  final String ownerName;

  Vehicle(this.plateNumber, this.ownerName);

  String get type;
  double get baseFee;
  double get hourlyRate;

  /// Every started hour is charged, minimum one hour.
  double calculateFee(Duration parkedFor) {
    var hours = (parkedFor.inMinutes / 60).ceil();
    if (hours < 1) hours = 1;
    return baseFee + (hourlyRate * hours);
  }

  void displayInfo() {
    print("[$type] $plateNumber  owner: $ownerName  "
        "(base ${baseFee.toStringAsFixed(0)} + ${hourlyRate.toStringAsFixed(0)}/hr)");
  }
}
