class Customer {
  final int id;
  final String name;
  final String email;

  Customer(this.id, this.name, this.email);

  void displayInfo() {
    print("Customer #$id | $name | $email");
  }
}
