import '../transportation/transportation.dart';
import 'customer.dart';
import 'driver.dart';

enum BookingStatus { pending, driverAssigned, paid, confirmed, cancelled }

class Booking {
  final int id;
  final Customer customer;
  final Transportation transportation;
  final double distanceKm;
  final DateTime createdAt;

  Driver? driver;
  double? fare;
  String? paidWith;
  String? transactionId;
  BookingStatus status = BookingStatus.pending;
  String? failureReason;

  Booking(this.id, this.customer, this.transportation, this.distanceKm,
      this.createdAt);

  void assignDriver(Driver assigned) {
    driver = assigned;
    status = BookingStatus.driverAssigned;
  }

  void setFare(double amount) {
    fare = amount;
  }

  void markPaid(String method, String? txnId) {
    paidWith = method;
    transactionId = txnId;
    status = BookingStatus.paid;
  }

  void confirm() {
    status = BookingStatus.confirmed;
  }

  void cancel(String reason) {
    failureReason = reason;
    status = BookingStatus.cancelled;
  }

  void displayInfo() {
    print("=== Booking #$id ===");
    print(" Customer : ${customer.name} (${customer.phone})");
    print(" Vehicle  : ${transportation.type}");
    print(" Distance : ${distanceKm.toStringAsFixed(1)} km");
    print(" Driver   : ${driver == null ? 'not assigned' : driver!.name}");
    final fareText = fare == null ? "-" : "${fare!.toStringAsFixed(2)} BDT";
    print(" Fare     : $fareText");
    print(" Status   : ${status.name}");
    if (status == BookingStatus.confirmed) {
      print(" Paid via : $paidWith (txn $transactionId)");
    }
    if (failureReason != null) {
      print(" Reason   : $failureReason");
    }
  }
}
