import 'delivery_method.dart';

class ExpressDelivery implements DeliveryMethod {
  static const double _base = 80;
  static const double _ratePerKm = 18;

  @override
  String get name => "Express Delivery";

  @override
  Duration get estimatedTime => const Duration(minutes: 20);

  @override
  double calculateFee(double orderAmount, double distanceKm) {
    return _base + (distanceKm * _ratePerKm);
  }
}
