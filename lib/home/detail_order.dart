// Librerias
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/home.dart';
import 'package:tus_materiales_app/home/list_order.dart';

//
//
class DetailOrder extends StatefulWidget {
  // Parametros iniciales
  final idOrder;
  final client;
  final orderState;
  final idUser;
  DetailOrder(
      {Key key,
      @required this.idOrder,
      this.client,
      this.orderState,
      this.idUser})
      : super(key: key);
  //
  @override
  _DetailOrderState createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  // Variables globales
  List data = List();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  //
  //
  @override
  void initState() {
    // Funciones iniciales
    getDetail();
    //
    super.initState();
  }

  Widget orderState() {
    // Botón de cancelar orden si es la orden es de estado 1
    if (widget.orderState == '1') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3,
              child: RaisedButton(
                onPressed: () async {},
                child: Text('Cancelar orden'),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Navegación, si se vuelve para atras y es cliente va al listado de ordenes con el estado heredado...
    // si es administrador o corralon vuelve al inicio
    void navigatorPush() {
      if (widget.client == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListOrder(
              idUser: widget.idUser,
              stateOrder: widget.orderState,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              stateOrders: widget.orderState,
              typeUser: '1',
            ),
          ),
        );
      }
    }

    //
    // Floating button, si el usuario es cliente se agrega boton para cancelar la orden
    Widget _floatingButton() {
      if (widget.client == true) {
        return FloatingActionButton(
          onPressed: () async {
            SharedPreferences localStorage =
                await SharedPreferences.getInstance();
            var cookies = localStorage.getString('cookies');
            var idUser = localStorage.getString('id');
            var url =
                'http://200.105.69.227/tusmateriales-api/public/index.php/orders/cancel/order/${widget.idOrder}';
            var response = await http.post(
              url,
              headers: {'Accept': 'application/json', 'Cookie': cookies},
            );
            print(response.statusCode);
            print(response.body);
            if (response.statusCode == 200) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListOrder(
                    stateOrder: widget.orderState,
                    idUser: idUser,
                  ),
                ),
              );
            }
          },
          backgroundColor: Color(0xffe9501c),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        );
      } else {
        return Container();
      }
    }

    return MaterialApp(
      home: Scaffold(
        // Appbar
        appBar: AppBar(
          title: Text('Listado de pedido'),
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
            onPressed: () => navigatorPush(),
          ),
        ),
        //
        body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            // Si la orden es de estado 1, o sea pendiente, se puede cancelar
            Widget itemState() {
              if (widget.orderState == '1') {
                return Column(
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        onPressed: () async {
                          var idItem = data[i]['iditem'];
                          SharedPreferences localStorage =
                              await SharedPreferences.getInstance();
                          var cookies = localStorage.getString('cookies');
                          var url =
                              'http://200.105.69.227/tusmateriales-api/public/index.php/orders/cancel/item/$idItem';
                          var response = await http.post(
                            url,
                            headers: {
                              'Accept': 'application/json',
                              'Cookie': cookies
                            },
                          );
                          print(response.statusCode);
                          print(response.body);
                          if (response.statusCode == 200) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailOrder(
                                  idOrder: widget.idOrder,
                                  orderState: widget.orderState,
                                  client: false,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text('Cancelar', style: TextStyle(fontSize: 10)),
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            }
            //

            Widget itemStateClient() {
              if (widget.orderState == '1') {
                // Si la orden es de estado 1, o sea, pendiente se puede cancelar
                return Column(
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        onPressed: () async {
                          var idItem = data[i]['iditem'];
                          SharedPreferences localStorage =
                              await SharedPreferences.getInstance();
                          var cookies = localStorage.getString('cookies');
                          var url =
                              'http://200.105.69.227/tusmateriales-api/public/index.php/orders/cancel/item/$idItem';
                          var response = await http.post(
                            url,
                            headers: {
                              'Accept': 'application/json',
                              'Cookie': cookies
                            },
                          );
                          print(response.statusCode);
                          print(response.body);
                          if (response.statusCode == 200) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailOrder(
                                  idOrder: widget.idOrder,
                                  orderState: widget.orderState,
                                  client: true,
                                  idUser: widget.idUser,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text('Cancelar', style: TextStyle(fontSize: 10)),
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            }

            //
            // si cliente es falso se muestran botones para cambiar de estado la orden
            if (widget.client == false) {
              return Column(
                children: <Widget>[
                  Card(
                    elevation: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 10,
                          child: RaisedButton(
                            onPressed: () async {
                              if (widget.orderState == '3') {
                                SharedPreferences localStorage =
                                    await SharedPreferences.getInstance();
                                var cookies = localStorage.getString('cookies');
                                var url =
                                    'http://200.105.69.227/tusmateriales-api/public/index.php/orders/state/1/${widget.idOrder}';
                                var response = await http.post(
                                  url,
                                  headers: {
                                    'Accept': 'application/json',
                                    'Cookie': cookies
                                  },
                                );
                                print(response.statusCode);
                                print(response.body);
                                if (response.statusCode == 200) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Home(
                                        stateOrders: widget.orderState,
                                        typeUser: '1',
                                      ),
                                    ),
                                  );
                                } else {
                                  scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'No se puede cambiar el estado de la orden'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text(
                              'Pendiente',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 10,
                          child: RaisedButton(
                            onPressed: () async {
                              if (widget.orderState == '1' ||
                                  widget.orderState == '3') {
                                SharedPreferences localStorage =
                                    await SharedPreferences.getInstance();
                                var cookies = localStorage.getString('cookies');
                                var url =
                                    'http://200.105.69.227/tusmateriales-api/public/index.php/orders/state/2/${widget.idOrder}';
                                var response = await http.post(
                                  url,
                                  headers: {
                                    'Accept': 'application/json',
                                    'Cookie': cookies
                                  },
                                );
                                print(response.statusCode);
                                print(response.body);
                                if (response.statusCode == 200) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Home(
                                        stateOrders: widget.orderState,
                                        typeUser: '1',
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'No se puede cambiar el estado de la orden'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: Text('Realizada',
                                style: TextStyle(fontSize: 10)),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 10,
                          child: RaisedButton(
                            onPressed: () async {
                              if (widget.orderState == '1') {
                                SharedPreferences localStorage =
                                    await SharedPreferences.getInstance();
                                var cookies = localStorage.getString('cookies');
                                var url =
                                    'http://200.105.69.227/tusmateriales-api/public/index.php/orders/state/3/${widget.idOrder}';
                                var response = await http.post(
                                  url,
                                  headers: {
                                    'Accept': 'application/json',
                                    'Cookie': cookies
                                  },
                                );
                                print(response.statusCode);
                                print(response.body);
                                if (response.statusCode == 200) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Home(
                                        stateOrders: widget.orderState,
                                        typeUser: '1',
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'No se puede cambiar el estado de la orden'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: Text('Rechazada',
                                style: TextStyle(fontSize: 10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
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
                                    data[i]['detail'].toUpperCase() ?? 'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    data[i]['denomination'].toUpperCase() ??
                                        'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    data[i]['brand'].toUpperCase() ?? 'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    data[i]['businessname'].toUpperCase() ??
                                        'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    data[i]['price'].toUpperCase() ?? 'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    data[i]['quantity'].toUpperCase() ?? 'N/A'),
                              ),
                            ],
                          ),
                          itemState(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
              //
            } else {
              // Se muestra el detalle de la orden y un boton para cancelar la orden si es de estado 1
              return Column(
                children: <Widget>[
                  Card(
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
                                    data[i]['detail'].toUpperCase() ?? 'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    data[i]['denomination'].toUpperCase() ??
                                        'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    data[i]['brand'].toUpperCase() ?? 'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    data[i]['businessname'].toUpperCase() ??
                                        'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    data[i]['price'].toUpperCase() ?? 'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    data[i]['quantity'].toUpperCase() ?? 'N/A'),
                              ),
                            ],
                          ),
                          itemStateClient(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
        floatingActionButton: _floatingButton(),
      ),
    );
  }

  // Funciones
  Future<String> getDetail() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/orders/details/${widget.idOrder}'),
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
