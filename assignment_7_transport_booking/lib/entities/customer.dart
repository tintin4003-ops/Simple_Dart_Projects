class Customer {
  final int id;
  final String name;
  final String phone;

  Customer(this.id, this.name, this.phone);

  void displayInfo() {
    print("Customer #$id | $name | $phone");
  }
}
