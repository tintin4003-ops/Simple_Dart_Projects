class Student {
  final int id;
  final String name;
  final String department;

  /// Used by online courses as an admission requirement.
  final bool hasOnlineAccess;

  Student(this.id, this.name, this.department, {this.hasOnlineAccess = true});

  void displayInfo() {
    print("Student #$id | $name | $department | "
        "online access: ${hasOnlineAccess ? 'yes' : 'no'}");
  }
}
