import 'transportation.dart';

class Bike extends Transportation {
  static const double baseFare = 25;
  static const double perKm = 12;

  @override
  String get type => "Bike";

  @override
  int get capacity => 1;

  @override
  double calculateFare(double distanceKm) => baseFare + (perKm * distanceKm);
}
