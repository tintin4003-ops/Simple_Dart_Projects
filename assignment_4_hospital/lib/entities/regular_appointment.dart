import 'appointment.dart';
import 'doctor.dart';
import 'patient.dart';

class RegularAppointment extends Appointment {
  RegularAppointment(int id, Patient patient, Doctor doctor, DateTime scheduledAt)
      : super(id, patient, doctor, scheduledAt);

  @override
  String get type => "Regular";

  @override
  int get priority => 2;

  @override
  double get fee => 500;

  @override
  Future<void> process() async {
    print("Processing regular appointment #$id ...");
    await Future.delayed(const Duration(seconds: 2));
    print("   Serial issued. ${patient.name}, please arrive 15 minutes early.");
  }
}
