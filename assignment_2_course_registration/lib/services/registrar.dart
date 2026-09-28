import '../entities/course.dart';
import '../entities/registration.dart';
import '../entities/student.dart';

/// Owns the students, the courses and the registration records.
/// University-wide rules (like the course load limit) live here;
/// seat rules live inside Course.
class Registrar {
  static const int maxCoursesPerStudent = 3;

  final List<Student> _students = [];
  final List<Course> _courses = [];
  final List<Registration> _registrations = [];
  int _nextRegistrationId = 1;

  void addStudent(Student student) {
    if (searchStudent(student.id) != null) {
      print("Student #${student.id} already exists.");
      return;
    }
    _students.add(student);
    print("${student.name} has been added.");
  }

  void addCourse(Course course) {
    if (searchCourse(course.code) != null) {
      print("Course ${course.code} already exists.");
      return;
    }
    _courses.add(course);
    print("${course.code} (${course.title}) has been added.");
  }

  Student? searchStudent(int id) {
    for (final student in _students) {
      if (student.id == id) return student;
    }
    return null;
  }

  Course? searchCourse(String code) {
    for (final course in _courses) {
      if (course.code.toLowerCase() == code.toLowerCase()) return course;
    }
    return null;
  }

  bool register(int studentId, String courseCode) {
    final student = searchStudent(studentId);
    if (student == null) {
      print("Student #$studentId not found.");
      return false;
    }

    final course = searchCourse(courseCode);
    if (course == null) {
      print("Course $courseCode not found.");
      return false;
    }

    final currentLoad = registrationsOf(studentId).length;
    if (currentLoad >= maxCoursesPerStudent) {
      print("${student.name} already has the maximum of "
          "$maxCoursesPerStudent courses.");
      return false;
    }

    // The course decides whether it can accept this student.
    if (!course.enroll(student)) return false;

    _registrations.add(
      Registration(_nextRegistrationId++, student, course, DateTime.now()),
    );
    return true;
  }

  bool dropCourse(int studentId, String courseCode) {
    final student = searchStudent(studentId);
    final course = searchCourse(courseCode);
    if (student == null || course == null) {
      print("Student or course not found.");
      return false;
    }
    if (!course.drop(student)) return false;

    _registrations.removeWhere(
      (r) => r.student.id == studentId && r.course.code == course.code,
    );
    return true;
  }

  List<Registration> registrationsOf(int studentId) =>
      _registrations.where((r) => r.student.id == studentId).toList();

  void viewStudents() {
    if (_students.isEmpty) {
      print("No students.");
      return;
    }
    print("--- Students ---");
    for (final student in _students) {
      student.displayInfo();
    }
  }

  void viewCourses() {
    if (_courses.isEmpty) {
      print("No courses.");
      return;
    }
    print("--- Courses ---");
    for (final course in _courses) {
      course.displayInfo();
    }
  }

  void viewRegistrations() {
    if (_registrations.isEmpty) {
      print("No registrations yet.");
      return;
    }
    print("--- All registrations ---");
    for (final registration in _registrations) {
      registration.displayInfo();
    }
  }

  void viewStudentRegistrations(int studentId) {
    final student = searchStudent(studentId);
    if (student == null) {
      print("Student #$studentId not found.");
      return;
    }
    final list = registrationsOf(studentId);
    print("--- Courses of ${student.name} (${list.length}) ---");
    if (list.isEmpty) {
      print("None.");
      return;
    }
    for (final registration in list) {
      print("  ${registration.course.code} - ${registration.course.title}");
    }
  }
}
