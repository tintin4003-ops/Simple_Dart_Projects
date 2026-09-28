import 'department.dart';

class Doctor {
  final int id;
  final String name;
  final Department department;
  bool isAvailable;

  Doctor(this.id, this.name, this.department, {this.isAvailable = true});

  void displayInfo() {
    print("Dr. $name (#$id) | ${department.label} | "
        "${isAvailable ? 'available' : 'busy'}");
  }
}
