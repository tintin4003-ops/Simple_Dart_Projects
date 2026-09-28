import 'course.dart';
import 'student.dart';

class OnlineCourse extends Course {
  final String platform;

  OnlineCourse(String code, String title, int capacity, this.platform)
      : super(code, title, capacity);

  @override
  String get type => "Online";

  @override
  String? admissionCheck(Student student) {
    if (!student.hasOnlineAccess) {
      return "an online learning account is required for $platform.";
    }
    return null;
  }

  @override
  void onRegistered(Student student) {
    final link = "https://$platform/${code.toLowerCase()}/${student.id}";
    print("   -> Class link sent: $link");
  }
}
