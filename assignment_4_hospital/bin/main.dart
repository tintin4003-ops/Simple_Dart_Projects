import '../lib/console/input.dart';
import '../lib/entities/department.dart';
import '../lib/entities/doctor.dart';
import '../lib/entities/emergency_appointment.dart';
import '../lib/entities/patient.dart';
import '../lib/entities/regular_appointment.dart';
import '../lib/services/hospital.dart';

Future<void> main() async {
  print("=== Smart Hospital Appointment System ===");
  final hospital = Hospital(Input.text("Hospital name"));
  var nextDoctorId = 1;
  var nextPatientId = 1;

  final departments = Department.values
      .map((d) => MenuOption(d.label, d))
      .toList();

  // A new appointment type = one more line here (plus its class).
  final appointmentTypes = <MenuOption<AppointmentBuilder>>[
    MenuOption("Regular appointment", RegularAppointment.new),
    MenuOption("Emergency appointment", EmergencyAppointment.new),
  ];

  await Input.runMenu("Hospital Menu", [
    MenuAction("Add doctor", () async {
      final name = Input.text("Doctor name");
      final department = Input.pick("Department", departments);
      final id = nextDoctorId++;
      hospital.addDoctor(Doctor(id, name, department));
      print("Doctor ID: $id");
    }),
    MenuAction("Add patient", () async {
      final name = Input.text("Patient name");
      final age = Input.integer("Age", min: 0, max: 120);
      final id = nextPatientId++;
      hospital.addPatient(Patient(id, name, age));
      print("Patient ID: $id");
    }),
    MenuAction("Book an appointment", () async {
      hospital.viewPatients();
      if (nextPatientId == 1) return;
      final patientId = Input.integer("Patient ID", min: 1);
      final department = Input.pick("Department", departments);
      final createAppointment = Input.pick("Appointment type", appointmentTypes);
      final days = Input.integer("Days from today (0 = today)", min: 0, max: 60);
      await hospital.bookAppointment(
        patientId,
        department,
        createAppointment,
        scheduledAt: DateTime.now().add(Duration(days: days)),
      );
    }),
    MenuAction("Change doctor availability", () async {
      hospital.viewDoctors();
      if (nextDoctorId == 1) return;
      final id = Input.integer("Doctor ID", min: 1);
      final available = Input.yesNo("Is the doctor available");
      hospital.setDoctorAvailability(id, available);
    }),
    MenuAction("View doctors", () async => hospital.viewDoctors()),
    MenuAction("View patients", () async => hospital.viewPatients()),
    MenuAction("View appointments", () async => hospital.viewAppointments()),
  ]);

  print("Goodbye!");
}
