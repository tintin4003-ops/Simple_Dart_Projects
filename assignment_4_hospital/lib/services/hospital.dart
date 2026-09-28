import '../entities/appointment.dart';
import '../entities/department.dart';
import '../entities/doctor.dart';
import '../entities/patient.dart';

/// Builds one specific kind of appointment. Passing a builder instead of a
/// type string is what keeps `if (type == "emergency")` out of this class.
typedef AppointmentBuilder = Appointment Function(
  int id,
  Patient patient,
  Doctor doctor,
  DateTime scheduledAt,
);

/// Hospital manages the entities and owns the async availability check.
class Hospital {
  final String name;
  final List<Doctor> _doctors = [];
  final List<Patient> _patients = [];
  final List<Appointment> _appointments = [];
  int _nextAppointmentId = 1;

  Hospital(this.name);

  void addDoctor(Doctor doctor) {
    _doctors.add(doctor);
    print("Dr. ${doctor.name} joined ${doctor.department.label}.");
  }

  void addPatient(Patient patient) {
    _patients.add(patient);
    print("${patient.name} has been registered as a patient.");
  }

  Patient? searchPatient(int id) {
    for (final patient in _patients) {
      if (patient.id == id) return patient;
    }
    return null;
  }

  /// Simulates contacting the roster system, which takes time.
  Future<Doctor?> findAvailableDoctor(Department department) async {
    print("Checking doctor availability in ${department.label} ...");
    await Future.delayed(const Duration(seconds: 2));
    for (final doctor in _doctors) {
      if (doctor.department == department && doctor.isAvailable) {
        return doctor;
      }
    }
    return null;
  }

  Future<Appointment?> bookAppointment(
    int patientId,
    Department department,
    AppointmentBuilder build, {
    DateTime? scheduledAt,
  }) async {
    final patient = searchPatient(patientId);
    if (patient == null) {
      print("Patient #$patientId not found.");
      return null;
    }

    final doctor = await findAvailableDoctor(department);
    if (doctor == null) {
      print("No doctor is available in ${department.label} right now.");
      return null;
    }

    final appointment = build(
      _nextAppointmentId++,
      patient,
      doctor,
      scheduledAt ?? DateTime.now().add(const Duration(days: 1)),
    );

    // Hospital does not know which subclass it is holding.
    await appointment.process();

    _appointments.add(appointment);
    print("Booked: ");
    appointment.displayInfo();
    print("");
    return appointment;
  }

  void viewDoctors() {
    print("--- Doctors of $name ---");
    for (final doctor in _doctors) {
      doctor.displayInfo();
    }
  }

  void viewAppointments() {
    if (_appointments.isEmpty) {
      print("No appointments.");
      return;
    }
    final sorted = List<Appointment>.from(_appointments)
      ..sort((a, b) => a.priority.compareTo(b.priority));
    print("--- Appointments (emergency first) ---");
    for (final appointment in sorted) {
      appointment.displayInfo();
    }
  }

  Doctor? searchDoctor(int id) {
    for (final doctor in _doctors) {
      if (doctor.id == id) return doctor;
    }
    return null;
  }

  void setDoctorAvailability(int id, bool available) {
    final doctor = searchDoctor(id);
    if (doctor == null) {
      print("Doctor #$id not found.");
      return;
    }
    doctor.isAvailable = available;
    print("Dr. ${doctor.name} is now ${available ? 'available' : 'busy'}.");
  }

  void viewPatients() {
    if (_patients.isEmpty) {
      print("No patients.");
      return;
    }
    print("--- Patients of $name ---");
    for (final patient in _patients) {
      patient.displayInfo();
    }
  }
}
