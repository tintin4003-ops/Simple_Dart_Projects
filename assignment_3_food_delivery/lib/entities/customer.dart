class Customer {
  final int id;
  final String name;
  final String address;

  Customer(this.id, this.name, this.address);

  void displayInfo() {
    print("Customer #$id | $name | $address");
  }
}
