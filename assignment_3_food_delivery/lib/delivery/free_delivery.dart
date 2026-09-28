import 'delivery_method.dart';

/// Added later by the client. Nothing else in the system changed.
class FreeDelivery implements DeliveryMethod {
  static const double minimumOrder = 1000;

  final DeliveryMethod fallback;

  FreeDelivery(this.fallback);

  @override
  String get name => "Free Delivery";

  @override
  Duration get estimatedTime => fallback.estimatedTime;

  @override
  double calculateFee(double orderAmount, double distanceKm) {
    if (orderAmount >= minimumOrder) return 0;
    return fallback.calculateFee(orderAmount, distanceKm);
  }
}
