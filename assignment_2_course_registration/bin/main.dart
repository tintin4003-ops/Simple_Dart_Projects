import '../lib/console/input.dart';
import '../lib/entities/course.dart';
import '../lib/entities/online_course.dart';
import '../lib/entities/regular_course.dart';
import '../lib/entities/student.dart';
import '../lib/services/registrar.dart';

/// Describes how to ask for and build one kind of course.
class CourseKind {
  final String detailPrompt;
  final Course Function(String code, String title, int capacity, String detail)
      build;
  const CourseKind(this.detailPrompt, this.build);
}

Future<void> main() async {
  print("=== University Course Registration System ===");
  final registrar = Registrar();
  var nextStudentId = 1;

  final courseKinds = <MenuOption<CourseKind>>[
    MenuOption("Regular course", CourseKind("Room", RegularCourse.new)),
    MenuOption("Online course", CourseKind("Platform (e.g. lms.uni.edu)", OnlineCourse.new)),
  ];

  await Input.runMenu("University Menu", [
    MenuAction("Add student", () async {
      final name = Input.text("Student name");
      final dept = Input.text("Department");
      final online = Input.yesNo("Does the student have an online learning account");
      final id = nextStudentId++;
      registrar.addStudent(Student(id, name, dept, hasOnlineAccess: online));
      print("Assigned student ID: $id");
    }),
    MenuAction("Add course", () async {
      final kind = Input.pick("Course type", courseKinds);
      final code = Input.text("Course code (e.g. CSE101)");
      final title = Input.text("Course title");
      final seats = Input.integer("Number of seats", min: 1);
      final detail = Input.text(kind.detailPrompt);
      registrar.addCourse(kind.build(code, title, seats, detail));
    }),
    MenuAction("Register a student for a course", () async {
      registrar.viewStudents();
      registrar.viewCourses();
      final id = Input.integer("Student ID", min: 1);
      final code = Input.text("Course code");
      registrar.register(id, code);
    }),
    MenuAction("Drop a course", () async {
      final id = Input.integer("Student ID", min: 1);
      final code = Input.text("Course code");
      registrar.dropCourse(id, code);
    }),
    MenuAction("View all students", () async => registrar.viewStudents()),
    MenuAction("View all courses", () async => registrar.viewCourses()),
    MenuAction("View all registrations", () async => registrar.viewRegistrations()),
    MenuAction("View one student's courses", () async {
      final id = Input.integer("Student ID", min: 1);
      registrar.viewStudentRegistrations(id);
    }),
  ]);

  print("Goodbye!");
}
