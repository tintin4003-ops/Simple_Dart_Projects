import 'course.dart';
import 'student.dart';

/// The relationship itself is an entity, so neither Student nor Course
/// has to hold a list of the other side.
class Registration {
  final int id;
  final Student student;
  final Course course;
  final DateTime registeredAt;

  Registration(this.id, this.student, this.course, this.registeredAt);

  void displayInfo() {
    print("Reg #$id | ${student.name} -> ${course.code} (${course.title}) "
        "| ${registeredAt.year}-${registeredAt.month}-${registeredAt.day}");
  }
}
