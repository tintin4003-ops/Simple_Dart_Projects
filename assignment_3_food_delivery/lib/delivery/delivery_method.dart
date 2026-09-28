/// Delivery IS a class (actually a family of classes), because the delivery
/// fee rule is the thing that varies. Order depends on this contract only,
/// so a new delivery type never forces a change inside Order.
abstract interface class DeliveryMethod {
  String get name;

  Duration get estimatedTime;

  double calculateFee(double orderAmount, double distanceKm);
}
