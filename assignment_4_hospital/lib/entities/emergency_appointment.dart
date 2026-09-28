import 'appointment.dart';
import 'doctor.dart';
import 'patient.dart';

class EmergencyAppointment extends Appointment {
  EmergencyAppointment(int id, Patient patient, Doctor doctor, DateTime scheduledAt)
      : super(id, patient, doctor, scheduledAt);

  @override
  String get type => "Emergency";

  @override
  int get priority => 1;

  @override
  double get fee => 1500;

  @override
  Future<void> process() async {
    print("EMERGENCY: processing appointment #$id immediately ...");
    await Future.delayed(const Duration(seconds: 1));
    doctor.isAvailable = false;
    print("   Dr. ${doctor.name} pulled from rotation for ${patient.name}.");
    print("   Emergency room prepared.");
  }
}
