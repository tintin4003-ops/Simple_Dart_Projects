class Student{
  final int id;
  final String name;

  Student(this.id, this.name);
  void displayInfo()
  {
    print("Student ID: $id");
    print("Student Name: $name");
  }
}