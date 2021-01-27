import 'package:flutter/foundation.dart';

class CustomerList with ChangeNotifier {
  Map<int, int> _cart1 = {};

  Map<int, int> get cart1 => _cart1;

  List<Customer> customers = [];

  CustomerList({this.customers});

  getCustomers() => customers;

  void addCustomer(Customer customer) {
    customers.add(customer);
    notifyListeners(); // Notify all it's listeners about update. If you comment this line then you will see that new added items will not be reflected in the list.
  }

  void removeCustomer(int index) {
    customers.removeAt(index);
    notifyListeners();
  }

  void addToCart(index) {
    if (_cart1.containsKey(index)) {
      _cart1[index] += 1;
    } else {
      _cart1[index] = 1;
    }
  }

  void clear(index) {
    if (_cart1.containsKey(index)) {
      _cart1.remove(index);
      notifyListeners();
    }
  }
}

class Customer {
  // Structure for Customer Data Storage
  var idarticle;
  var detail;
  var brand;
  var idcorral;
  var price;
  var quantity;
  Customer(
      {this.idarticle,
      this.detail,
      this.brand,
      this.idcorral,
      this.price,
      this.quantity});

  Customer.fromJson(Map<String, dynamic> json)
      : idarticle = json['idarticle'],
        idcorral = json['idcorral'],
        price = json['price'],
        quantity = json['quantity'];
  Map<String, dynamic> toJson() => {
        'idarticle': idarticle,
        'idcorral': idcorral,
        'price': price,
        'quantity': quantity,
      };
}
