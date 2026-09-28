class NoDriverAvailableException implements Exception {
  final String vehicleType;
  NoDriverAvailableException(this.vehicleType);

  @override
  String toString() => "No $vehicleType driver is available right now.";
}

class PaymentFailedException implements Exception {
  final String reason;
  PaymentFailedException(this.reason);

  @override
  String toString() => "Payment failed: $reason";
}

class BookingException implements Exception {
  final String message;
  BookingException(this.message);

  @override
  String toString() => "Booking error: $message";
}
