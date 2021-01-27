import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/edit_address.dart';
import 'package:tus_materiales_app/home/home.dart';
import 'package:tus_materiales_app/home/new_address.dart';

class ListAddress extends StatefulWidget {
  @override
  _ListAddressState createState() => _ListAddressState();
}

class _ListAddressState extends State<ListAddress> {
  List data = List();
  var idUser;

  @override
  void initState() {
    getAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Listado de direcciones'),
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
        body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            var state;
            if (data[i]['enabled'] == '1') {
              state = 'Activo';
            } else {
              state = 'Deshabilitado';
            }
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
                                  data[i]['location'].toUpperCase() ?? 'N/A'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text(data[i]['city'].toUpperCase() ?? 'N/A'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(state.toUpperCase() ?? 'N/A'),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              child: RaisedButton(
                                onPressed: () {
                                  final id = data[i]['idaddress'];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditAddress(
                                        id: id,
                                      ),
                                    ),
                                  );
                                },
                                child: Text('Editar'),
                              ),
                            ),
                            Container(
                              child: RaisedButton(
                                onPressed: () async {
                                  final id = data[i]['idaddress'];
                                  SharedPreferences localStorage =
                                      await SharedPreferences.getInstance();
                                  var cookies =
                                      localStorage.getString('cookies');
                                  var url =
                                      'http://200.105.69.227/tusmateriales-api/public/index.php/addresses/active/$id';
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
                                        builder: (context) => ListAddress(),
                                      ),
                                    );
                                  }
                                },
                                child: Text('Estado'),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewAddress(
                  idUser: idUser,
                  onShop: false,
                ),
              ),
            );
          },
          backgroundColor: Color(0xffe9501c),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<String> getAddress() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    idUser = localStorage.getString('id');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/addresses/get/all/$idUser'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(body);

    return "Sucess";
  }
}
