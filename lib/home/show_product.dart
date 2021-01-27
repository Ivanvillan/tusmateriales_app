import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShowProduct extends StatefulWidget {
  final idProduct;
  final idCat;
  ShowProduct({Key key, @required this.idProduct, this.idCat})
      : super(key: key);
  @override
  _ShowProductState createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  List data = List();
  List data2 = List();
  var state;

  @override
  void initState() {
    getCat();
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Información del producto'),
          backgroundColor: Color(0xfff2920a),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            if (data[i]['enabled'] == "1") {
              state = 'Activo';
            } else {
              state = 'Inactivo';
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('DATOS DEL PRODUCTO',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Divider(
                      color: Colors.black38,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text('NOMBRE',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(data[i]['detail'] ?? 'N/A'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text('DETALLE',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(data[i]['additionalinformation'] ?? 'N/A'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text('CATEGORIA',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(data2[0]['denomination'] ?? 'N/A'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'ESTADO',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(state),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<String> getProduct() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    // username = localStorage.getString('username');
    // email = localStorage.getString('email');
    // role = localStorage.getString('role');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/generics/getbyid/${widget.idProduct}'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    return "Sucess";
  }

  Future<String> getCat() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    // username = localStorage.getString('username');
    // email = localStorage.getString('email');
    // role = localStorage.getString('role');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/categories/get/all/${widget.idCat}'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data2 = body["result"];
    });
    return "Sucess";
  }
}
