import '../entities/parking_ticket.dart';
import '../entities/vehicle.dart';

/// Manages slots and tickets. It never asks "what kind of vehicle is this?".
class ParkingLot {
  final String name;
  final int capacity;
  final List<ParkingTicket> _tickets = [];
  int _nextTicketNo = 1;

  ParkingLot(this.name, this.capacity);

  List<ParkingTicket> get activeTickets =>
      _tickets.where((t) => t.isActive).toList();

  double get totalEarnings =>
      _tickets.where((t) => t.fee != null).fold(0.0, (sum, t) => sum + t.fee!);

  ParkingTicket? parkVehicle(Vehicle vehicle, {DateTime? entryTime}) {
    if (_findActiveTicket(vehicle.plateNumber) != null) {
      print("${vehicle.plateNumber} is already inside the parking area.");
      return null;
    }

    final slot = _findFreeSlot();
    if (slot == null) {
      print("$name is full. ${vehicle.plateNumber} cannot enter.");
      return null;
    }

    final ticket = ParkingTicket(
      _nextTicketNo++,
      vehicle,
      slot,
      entryTime ?? DateTime.now(),
    );
    _tickets.add(ticket);
    print("${vehicle.type} ${vehicle.plateNumber} parked at slot $slot "
        "(ticket #${ticket.ticketNo}).");
    return ticket;
  }

  double? releaseVehicle(String plateNumber, {DateTime? exitTime}) {
    final ticket = _findActiveTicket(plateNumber);
    if (ticket == null) {
      print("No active ticket found for $plateNumber.");
      return null;
    }

    ticket.close(exitTime ?? DateTime.now());
    print("$plateNumber left slot ${ticket.slot} after "
        "${_readable(ticket.parkedFor)}. Fee: ${ticket.fee!.toStringAsFixed(2)} BDT");
    return ticket.fee;
  }

  void viewParkedVehicles() {
    final active = activeTickets;
    if (active.isEmpty) {
      print("No vehicle is currently parked in $name.");
      return;
    }
    print("--- Currently parked in $name (${active.length}/$capacity) ---");
    for (final ticket in active) {
      ticket.displayInfo();
    }
  }

  void viewHistory() {
    if (_tickets.isEmpty) {
      print("No parking history.");
      return;
    }
    print("--- All tickets ---");
    for (final ticket in _tickets) {
      ticket.displayInfo();
    }
    print("Total earnings: ${totalEarnings.toStringAsFixed(2)} BDT");
  }

  ParkingTicket? _findActiveTicket(String plateNumber) {
    for (final ticket in _tickets) {
      if (ticket.isActive &&
          ticket.vehicle.plateNumber.toLowerCase() == plateNumber.toLowerCase()) {
        return ticket;
      }
    }
    return null;
  }

  String? _findFreeSlot() {
    final taken = activeTickets.map((t) => t.slot).toSet();
    for (var i = 1; i <= capacity; i++) {
      final slot = "S$i";
      if (!taken.contains(slot)) return slot;
    }
    return null;
  }

  String _readable(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return "${h}h ${m}m";
  }
}
