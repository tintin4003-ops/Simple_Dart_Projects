import 'course.dart';
import 'student.dart';

class RegularCourse extends Course {
  final String room;

  RegularCourse(String code, String title, int capacity, this.room)
      : super(code, title, capacity);

  @override
  String get type => "Regular";

  @override
  String? admissionCheck(Student student) => null;

  @override
  void onRegistered(Student student) {
    print("   -> Attend in person. Room: $room. Seat no: ${enrolled.length}");
  }
}
