import 'doctor.dart';
import 'patient.dart';

/// Appointment is the parent class because every appointment shares the same
/// data (patient, doctor, time) but the PROCESSING differs by type.
abstract class Appointment {
  final int id;
  final Patient patient;
  final Doctor doctor;
  final DateTime scheduledAt;

  Appointment(this.id, this.patient, this.doctor, this.scheduledAt);

  String get type;

  /// Lower number = seen earlier.
  int get priority;

  double get fee;

  /// Type specific processing. Each subclass decides what happens here.
  Future<void> process();

  void displayInfo() {
    print("Appointment #$id [$type] | ${patient.name} -> Dr. ${doctor.name} "
        "(${doctor.department.label}) | ${_clock(scheduledAt)} | "
        "fee ${fee.toStringAsFixed(0)} BDT");
  }

  String _clock(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return "${t.day}/${t.month} $h:$m";
  }
}
