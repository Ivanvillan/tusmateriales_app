import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/home.dart';
import 'package:tus_materiales_app/home/new_address.dart';
import 'package:http/http.dart' as http;
import 'package:tus_materiales_app/provider/cart_bloc.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class SendOrder extends StatefulWidget {
  @override
  _SendOrderState createState() => _SendOrderState();
}

class _SendOrderState extends State<SendOrder> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  var idUser;
  List data = List();
  List data2 = List();
  // ignore: unused_field
  var _direc;
  var direc;
  // ignore: unused_field
  String _mySelection;

  @override
  void initState() {
    getAddress();
    getUser();
    super.initState();
  }

  void showModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(8.0),
          height: 200,
          alignment: Alignment.center,
          child: ListView.separated(
            itemCount: data == null ? 0 : data.length,
            separatorBuilder: (context, int) {
              return Divider(
                height: 10.0,
              );
            },
            itemBuilder: (context, i) {
              return GestureDetector(
                child: Text(
                  data[i]["location"] != null
                      ? data[i]["location"]
                      : 'No hay direcciones agregadas',
                  style: TextStyle(fontSize: 16.0),
                ),
                onTap: () {
                  setState(
                    () {
                      direc = data[i]["location"];
                      _mySelection = data[i]["idaddress"];
                      _direc = data[i]["location"];
                    },
                  );
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Dirección de envío'),
          backgroundColor: Color(0xfff2920a),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text(
                    _direc != null ? '$_direc' : 'Seleccione una dirección'),
                onPressed: () => showModal(context),
              ),
              RaisedButton(
                child: Text(
                  "Añadir dirección",
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewAddress(
                        idUser: idUser,
                        onShop: true,
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image(
                  image: AssetImage('assets/img/only-logo.png'),
                  width: MediaQuery.of(context).size.width / 2,
                  height: 120.0,
                ),
              ),
              Text('¡Gracias por su compra!'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text('Aviso'),
                content: Text('¿Crear orden?'),
                actions: [
                  FlatButton(
                    child: Text('Si'),
                    onPressed: () async {
                      Navigator.pop(c, false);
                      List items = [];
                      var list = Provider.of<CustomerList>(context).customers;
                      for (var item in list) {
                        var dataOrder = {
                          "idarticle": item.idarticle,
                          "idcorral": item.idcorral,
                          "price": item.price,
                          "quantity": item.quantity,
                        };
                        items.add(dataOrder);
                      }
                      Map<String, dynamic> _params = {
                        "data": {
                          "iduser": idUser.toString(),
                          "idaddress": _mySelection.toString(),
                          "observations": 'Orden creada',
                          "items": items
                        }
                      };
                      var body = json.encode(_params);
                      SharedPreferences localStorage =
                          await SharedPreferences.getInstance();
                      var cookies = localStorage.getString('cookies');
                      var url =
                          'http://200.105.69.227/tusmateriales-api/public/index.php/orders/generate';
                      var response = await http.post(url,
                          headers: {
                            'Accept': 'application/json',
                            'Content-Type': 'application/json',
                            'Cookie': cookies
                          },
                          body: body);
                      print(response.statusCode);
                      print(response.body);
                      var orderBody = json.decode(response.body);
                      var orderId = orderBody['response'].toString();
                      if (response.statusCode == 200) {
                        sendMail();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Home(
                        //     ),
                        //   ),
                        // );
                        SharedPreferences localStorage =
                            await SharedPreferences.getInstance();
                        var cookies = localStorage.getString('cookies');
                        var url =
                            'http://200.105.69.227/tusmateriales-api/public/index.php/mp/pay/$orderId';
                        var res = await http.post(
                          url,
                          headers: {
                            'Accept': 'application/json',
                            'Content-Type': 'application/json',
                            'Cookie': cookies
                          },
                        );
                        var mpBody = json.decode(res.body);
                        var preference = mpBody['result']['PREFERENCE_ID'];
                        var publicKey = mpBody['result']['PUBLIC_KEY'];
                        print(res.body);

                        if (res.statusCode == 200) {
                          scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text('Espere...'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          var result =
                              await MercadoPagoMobileCheckout.startCheckout(
                                  publicKey, preference);
                          print(result);
                          if (result.result == 'done') {
                            scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('Pedido enviado'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            list.removeWhere((item) => item != null);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Home(
                                  stateOrders: 'all',
                                  typeUser: '3',
                                ),
                              ),
                            );
                          } else {
                            scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('Error'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      } else {
                        Navigator.pop(c, false);
                        scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text('Error'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                  FlatButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                ],
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

  Future<String> getAddress() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    idUser = localStorage.getString('id');
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/addresses/get/1/$idUser'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    return "Sucess";
  }

  Future<String> getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var iduser = localStorage.getString('id');
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/users/getbyid/$iduser'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data2 = body["result"];
    });
    return 'success';
  }

  sendMail() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var email = localStorage.getString('email');
    var name = localStorage.getString('username').toUpperCase();
    String username = 'tusmaterialesapp@gmail.com';
    String password = 'materialesapp1';
    final smtpServer =
        SmtpServer('smtp.gmail.com', username: username, password: password);
    var totalPrice = Provider.of<CustomerList>(context)
        .customers
        .map<int>((m) => int.parse(m.price.split('.')[0]) * m.quantity)
        .reduce((a, b) => a + b);
    var totalPrice2 = Provider.of<CustomerList>(context)
        .customers
        .map<int>((m) => int.parse(m.price.split('.')[1]) * m.quantity)
        .reduce((a, b) => a + b);
    var total = totalPrice + totalPrice2;
    var list = Provider.of<CustomerList>(context).customers;
    var pedido = StringBuffer();
    list.forEach((item) {
      pedido.write('\nArtículo\n'
          ' · Material: ${item.detail}\n'
          ' · Tipo: ${item.brand}\n'
          ' · Cantidad: ${item.quantity}\n'
          ' · Precio: \$${item.price}\n');
    });

    final message = Message()
      ..from = Address(username)
      ..recipients.add('maximiliano.albitre@gerdau.com')
      ..bccRecipients.add(Address('ivanvillan54@gmail.com'))
      ..subject = 'Nueva orden de: $name'
      ..text = '\nINFORMACIÓN DEL CLIENTE\n'
          ' · Dirección de entrega: $direc\n'
          ' · Teléfono: ${data2[0]["phone"]}\n'
          ' · Email: $email\n'
          '$pedido\n'
          '\nPRECIO FINAL\n'
          ' · Total a pagar: \$$total\n';
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
    }
  }
}
