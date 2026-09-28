import '../core/exceptions.dart';
import '../entities/booking.dart';
import '../payment/payment_method.dart';
import '../transportation/transportation.dart';
import 'customer_service.dart';
import 'driver_service.dart';

/// Orchestrates the whole flow. It knows only the abstract types
/// `Transportation` and `PaymentMethod`, so new vehicles and new payment
/// methods plug in without a single edit here.
class BookingService {
  final CustomerService customers;
  final DriverService drivers;
  final List<Booking> _bookings = [];
  int _nextBookingId = 1;

  BookingService(this.customers, this.drivers);

  Future<Booking?> createBooking({
    required int customerId,
    required Transportation transportation,
    required double distanceKm,
    required PaymentMethod payment,
  }) async {
    final customer = customers.searchCustomer(customerId);
    if (customer == null) {
      print("Customer #$customerId not found.");
      return null;
    }
    if (distanceKm <= 0) {
      print("Travel distance must be greater than 0 km.");
      return null;
    }

    final booking = Booking(
      _nextBookingId++,
      customer,
      transportation,
      distanceKm,
      DateTime.now(),
    );
    _bookings.add(booking);

    print("--- Booking #${booking.id} for ${customer.name} "
        "(${transportation.type}, ${distanceKm.toStringAsFixed(1)} km) ---");

    try {
      // 1. Find a driver, asynchronously.
      final driver = await drivers.findAvailableDriver(transportation.type);
      if (driver == null) {
        throw NoDriverAvailableException(transportation.type);
      }
      booking.assignDriver(driver);
      print("Driver assigned: ${driver.name}");

      // 2. Let the transportation price itself.
      final fare = transportation.calculateFare(distanceKm);
      booking.setFare(fare);
      print("Fare: ${fare.toStringAsFixed(2)} BDT");

      // 3. Let the payment method process itself.
      final result = await payment.pay(fare);
      if (!result.success) {
        throw PaymentFailedException(result.message);
      }
      booking.markPaid(payment.name, result.transactionId);
      print("Payment accepted: ${result.message}");

      // 4. Confirm and take the driver off the roster.
      drivers.setAvailability(driver.id, false);
      booking.confirm();
      print("Booking #${booking.id} confirmed.\n");
      return booking;
    } on NoDriverAvailableException catch (e) {
      booking.cancel(e.toString());
      print("$e\nBooking #${booking.id} cancelled.\n");
      return null;
    } on PaymentFailedException catch (e) {
      // The driver was never taken off the roster, so nothing to undo there.
      booking.cancel(e.toString());
      print("$e\nBooking #${booking.id} cancelled.\n");
      return null;
    } catch (e) {
      booking.cancel("unexpected error: $e");
      print("Unexpected error: $e\nBooking #${booking.id} cancelled.\n");
      return null;
    }
  }

  /// Ends a trip and releases the driver.
  void completeTrip(int bookingId) {
    final booking = searchBooking(bookingId);
    if (booking == null) {
      print("Booking #$bookingId not found.");
      return;
    }
    if (booking.status != BookingStatus.confirmed) {
      print("Booking #$bookingId is not an active trip.");
      return;
    }
    if (booking.driver != null) {
      drivers.setAvailability(booking.driver!.id, true);
    }
    print("Trip of booking #$bookingId completed.");
  }

  Booking? searchBooking(int id) {
    for (final booking in _bookings) {
      if (booking.id == id) return booking;
    }
    return null;
  }

  void viewBookings() {
    if (_bookings.isEmpty) {
      print("No bookings.");
      return;
    }
    for (final booking in _bookings) {
      booking.displayInfo();
      print("");
    }
    final earned = _bookings
        .where((b) => b.status == BookingStatus.confirmed && b.fare != null)
        .fold(0.0, (sum, b) => sum + b.fare!);
    print("Total confirmed revenue: ${earned.toStringAsFixed(2)} BDT");
  }
}
