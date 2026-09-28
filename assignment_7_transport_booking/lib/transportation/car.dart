import 'transportation.dart';

class Car extends Transportation {
  static const double baseFare = 60;
  static const double perKm = 25;

  @override
  String get type => "Car";

  @override
  int get capacity => 4;

  @override
  double calculateFare(double distanceKm) => baseFare + (perKm * distanceKm);
}
