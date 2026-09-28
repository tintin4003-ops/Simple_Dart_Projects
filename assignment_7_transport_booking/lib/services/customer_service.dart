import '../entities/customer.dart';

class CustomerService {
  final List<Customer> _customers = [];

  void addCustomer(Customer customer) {
    if (searchCustomer(customer.id) != null) {
      print("Customer #${customer.id} already exists.");
      return;
    }
    _customers.add(customer);
    print("${customer.name} has been added as a customer.");
  }

  Customer? searchCustomer(int id) {
    for (final customer in _customers) {
      if (customer.id == id) return customer;
    }
    return null;
  }

  void viewCustomers() {
    if (_customers.isEmpty) {
      print("No customers.");
      return;
    }
    print("--- Customers ---");
    for (final customer in _customers) {
      customer.displayInfo();
    }
  }

  /// Matches on ID, name or phone number.
  List<Customer> search(String query) {
    final q = query.toLowerCase();
    return _customers
        .where((c) =>
            c.id.toString() == q ||
            c.name.toLowerCase().contains(q) ||
            c.phone.contains(q))
        .toList();
  }
}
