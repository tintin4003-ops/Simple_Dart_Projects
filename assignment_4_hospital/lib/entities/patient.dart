class Patient {
  final int id;
  final String name;
  final int age;

  Patient(this.id, this.name, this.age);

  void displayInfo() {
    print("Patient #$id | $name | age $age");
  }
}
