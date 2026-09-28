import 'student.dart';

/// A course owns its own seats, so it is the class responsible for
/// seat availability and for rejecting a duplicate enrolment.
///
/// The *registration process* differs per course type, so the parts that
/// differ are abstract and filled in by the subclasses.
abstract class Course {
  final String code;
  final String title;
  final int capacity;
  final List<Student> _enrolled = [];

  Course(this.code, this.title, this.capacity);

  String get type;

  List<Student> get enrolled => List.unmodifiable(_enrolled);
  int get seatsLeft => capacity - _enrolled.length;
  bool get hasSeat => seatsLeft > 0;

  bool contains(Student student) => _enrolled.any((s) => s.id == student.id);

  /// Type specific rule. Returns `null` when the student may join,
  /// otherwise the reason for rejection.
  String? admissionCheck(Student student);

  /// Type specific step that happens after a successful enrolment.
  void onRegistered(Student student);

  /// Template method: the shared rules run for every course type.
  bool enroll(Student student) {
    if (contains(student)) {
      print("${student.name} is already registered for $code.");
      return false;
    }
    if (!hasSeat) {
      print("$code ($title) has no seats left.");
      return false;
    }

    final problem = admissionCheck(student);
    if (problem != null) {
      print("${student.name} cannot join $code: $problem");
      return false;
    }

    _enrolled.add(student);
    print("${student.name} registered for $code ($title). "
        "Seats left: $seatsLeft");
    onRegistered(student);
    return true;
  }

  bool drop(Student student) {
    final before = _enrolled.length;
    _enrolled.removeWhere((s) => s.id == student.id);
    final removed = _enrolled.length < before;
    if (removed) {
      print("${student.name} dropped $code. Seats left: $seatsLeft");
    } else {
      print("${student.name} is not registered for $code.");
    }
    return removed;
  }

  void displayInfo() {
    print("[$type] $code - $title | seats: ${_enrolled.length}/$capacity");
  }
}
