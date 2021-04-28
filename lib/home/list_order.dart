// Librerias
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/detail_order.dart';
import 'package:tus_materiales_app/home/home.dart';

//
class ListOrder extends StatefulWidget {
  // Parametros iniciales
  final idUser;
  final stateOrder;
  ListOrder({Key key, @required this.idUser, @required this.stateOrder})
      : super(key: key);
  //
  @override
  _ListOrderState createState() => _ListOrderState();
}

class _ListOrderState extends State<ListOrder> {
  // Variables globales
  List data = List();
  //

  @override
  void initState() {
    // Funciones iniciales
    getOrders();
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // Appbar
        appBar: AppBar(
          title: Text('Listado de ordenes'),
          backgroundColor: Color(0xfff2920a),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(Icons.search),
            )
          ],
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(
                  stateOrders: '',
                  typeUser: '3',
                ),
              ),
            ),
          ),
        ),
        //
        body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            var stateOrder;
            if (data[i]['state'] == '1') {
              stateOrder = 'Pendiente';
            } else if (data[i]['state'] == '2') {
              stateOrder = 'Realizada';
            } else {
              stateOrder = 'Rechazada';
            }
            return Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    final idOrder = data[i]['idorder'];
                    final idUser = widget.idUser;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailOrder(
                          idOrder: idOrder,
                          client: true,
                          idUser: idUser,
                          orderState: data[i]['state'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    data[i]['customer'].toUpperCase() ?? 'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    data[i]['location'].toUpperCase() ?? 'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(stateOrder.toUpperCase() ?? 'N/A'),
                              ),
                            ],
                          ),
                          Container(
                            child: Icon(Icons.arrow_right),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Funciones
  Future<String> getOrders() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/orders/get/${widget.stateOrder}/${widget.idUser}'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(data);

    return "Sucess";
  }
  //
}
