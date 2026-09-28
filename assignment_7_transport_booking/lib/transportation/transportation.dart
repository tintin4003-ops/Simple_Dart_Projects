/// Every transportation type prices itself. Nothing outside this family
/// ever needs to know which concrete type it is holding.
abstract class Transportation {
  String get type;

  int get capacity;

  double calculateFare(double distanceKm);

  void displayInfo() {
    print("$type (up to $capacity passengers)");
  }
}
