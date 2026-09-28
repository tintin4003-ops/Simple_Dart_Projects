class Driver {
  final int id;
  final String name;

  /// Which transportation type this driver is licensed for.
  /// It is a lookup key, never used for branching logic.
  final String vehicleType;

  bool isAvailable;

  Driver(this.id, this.name, this.vehicleType, {this.isAvailable = true});

  void displayInfo() {
    print("Driver #$id | $name | $vehicleType | "
        "${isAvailable ? 'available' : 'on a trip'}");
  }
}
