import 'transportation.dart';

/// A completely different rule (flat fare) with no change anywhere else.
class Bus extends Transportation {
  static const double fixedFare = 40;

  @override
  String get type => "Bus";

  @override
  int get capacity => 40;

  @override
  double calculateFare(double distanceKm) => fixedFare;
}
