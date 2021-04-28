// Librerias
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tus_materiales_app/home/home.dart';
import 'package:tus_materiales_app/home/send_order.dart';
import 'package:tus_materiales_app/provider/cart_bloc.dart';

//
class CartShop extends StatefulWidget {
  @override
  _CartShopState createState() => _CartShopState();
}

class _CartShopState extends State<CartShop> {
  @override
  Widget build(BuildContext context) {
    // calculos del precio de los productos
    final customerList = Provider.of<CustomerList>(context);
    var totalPrice = Provider.of<CustomerList>(context)
        .customers
        .map<int>((m) => int.parse(m.price.split('.')[0]) * m.quantity)
        .reduce((a, b) => a + b);
    var totalPrice2 = Provider.of<CustomerList>(context)
        .customers
        .map<int>((m) => int.parse(m.price.split('.')[1]) * m.quantity)
        .reduce((a, b) => a + b);
    var total = totalPrice + totalPrice2;
    //
    return MaterialApp(
      home: Scaffold(
        // Appbar
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Color(0xfff2920a),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Carrito',
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  'Total: \$$total',
                  style: TextStyle(color: Color(0xff2e2925)),
                ),
              ),
            ],
          ),
        ),
        //
        body: ListView.builder(
          itemCount: customerList.customers.length,
          itemBuilder: (context, index) {
            print(customerList.customers.length);
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${customerList.customers[index].quantity} - '
                      '${customerList.customers[index].detail} - '
                      '${customerList.customers[index].brand} - '
                      '\$${customerList.customers[index].price}'),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Color(0xffe9501c),
                    ),
                    onPressed: () {
                      if (customerList.customers.length == 1) {
                        customerList.removeCustomer(index);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(
                              stateOrders: 'all',
                              typeUser: '3',
                            ),
                          ),
                        );
                      } else {
                        customerList.removeCustomer(index);
                      }
                    },
                  )
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SendOrder(),
              ),
            );
          },
          child: Icon(
            Icons.send,
            color: Colors.white,
          ),
          backgroundColor: Color(0xffe9501c),
        ),
      ),
    );
  }
}
