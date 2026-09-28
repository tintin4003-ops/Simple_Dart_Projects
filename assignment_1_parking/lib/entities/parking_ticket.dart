import 'vehicle.dart';

/// Connects a vehicle to a slot over a period of time.
class ParkingTicket {
  final int ticketNo;
  final Vehicle vehicle;
  final String slot;
  final DateTime entryTime;

  DateTime? exitTime;
  double? fee;

  ParkingTicket(this.ticketNo, this.vehicle, this.slot, this.entryTime);

  bool get isActive => exitTime == null;

  Duration get parkedFor => (exitTime ?? DateTime.now()).difference(entryTime);

  void close(DateTime leftAt) {
    exitTime = leftAt;
    fee = vehicle.calculateFee(leftAt.difference(entryTime));
  }

  void displayInfo() {
    final line = StringBuffer();
    line.write("Ticket #$ticketNo | Slot $slot | ${vehicle.type} ${vehicle.plateNumber}");
    line.write(" | In: ${_clock(entryTime)}");
    if (isActive) {
      line.write(" | STILL PARKED");
    } else {
      line.write(" | Out: ${_clock(exitTime!)}");
      line.write(" | Fee: ${fee!.toStringAsFixed(2)} BDT");
    }
    print(line.toString());
  }

  String _clock(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }
}
