import 'delivery_method.dart';

class RegularDelivery implements DeliveryMethod {
  static const double _base = 40;
  static const double _perKmAfter = 3;
  static const double _ratePerKm = 10;

  @override
  String get name => "Regular Delivery";

  @override
  Duration get estimatedTime => const Duration(minutes: 45);

  @override
  double calculateFee(double orderAmount, double distanceKm) {
    final double extraKm =
        distanceKm > _perKmAfter ? distanceKm - _perKmAfter : 0.0;
    return _base + (extraKm * _ratePerKm);
  }
}
