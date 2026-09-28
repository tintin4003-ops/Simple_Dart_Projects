import '../entities/driver.dart';

class DriverService {
  final List<Driver> _drivers = [];

  void addDriver(Driver driver) {
    if (searchDriver(driver.id) != null) {
      print("Driver #${driver.id} already exists.");
      return;
    }
    _drivers.add(driver);
    print("${driver.name} has been added as a ${driver.vehicleType} driver.");
  }

  Driver? searchDriver(int id) {
    for (final driver in _drivers) {
      if (driver.id == id) return driver;
    }
    return null;
  }

  /// Simulates asking the dispatch system, which takes time.
  Future<Driver?> findAvailableDriver(String vehicleType) async {
    print("Looking for an available $vehicleType driver ...");
    await Future.delayed(const Duration(seconds: 2));
    for (final driver in _drivers) {
      if (driver.isAvailable &&
          driver.vehicleType.toLowerCase() == vehicleType.toLowerCase()) {
        return driver;
      }
    }
    return null;
  }

  void setAvailability(int driverId, bool value) {
    final driver = searchDriver(driverId);
    if (driver == null) {
      print("Driver #$driverId not found.");
      return;
    }
    driver.isAvailable = value;
    print("${driver.name} is now ${value ? 'available' : 'on a trip'}.");
  }

  void viewDrivers() {
    if (_drivers.isEmpty) {
      print("No drivers.");
      return;
    }
    print("--- Drivers ---");
    for (final driver in _drivers) {
      driver.displayInfo();
    }
  }

  /// Matches on ID, name or vehicle type.
  List<Driver> search(String query) {
    final q = query.toLowerCase();
    return _drivers
        .where((d) =>
            d.id.toString() == q ||
            d.name.toLowerCase().contains(q) ||
            d.vehicleType.toLowerCase().contains(q))
        .toList();
  }
}
