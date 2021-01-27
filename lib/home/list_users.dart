import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/edit_user.dart';
import 'package:tus_materiales_app/home/home.dart';
import 'package:tus_materiales_app/home/show_user.dart';

class ListUsers extends StatefulWidget {
  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  List data = List();

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Listado de usuario'),
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
                  stateOrders: 'all',
                  typeUser: '1',
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
            var rol;
            if (data[i]['role'] == '1') {
              rol = 'Administrador';
            } else if (data[i]['role'] == '2') {
              rol = 'Responsable';
            } else {
              rol = 'Cliente';
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
                              child: Row(
                                children: [
                                  Text(data[i]['name'].toUpperCase() ?? 'N/A'),
                                  Divider(
                                    indent: 6.0,
                                  ),
                                  Text(data[i]['surname'].toUpperCase() ??
                                      'N/A'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(rol.toUpperCase() ?? 'N/A'),
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
                                  final id = data[i]['iduser'];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShowUser(id: id),
                                    ),
                                  );
                                },
                                child: Text('Ver'),
                              ),
                            ),
                            Container(
                              child: RaisedButton(
                                onPressed: () {
                                  final id = data[i]['iduser'];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditUser(id: id),
                                    ),
                                  );
                                },
                                child: Text('Editar'),
                              ),
                            ),
                            Container(
                              child: RaisedButton(
                                onPressed: () async {
                                  final id = data[i]['iduser'];
                                  SharedPreferences localStorage =
                                      await SharedPreferences.getInstance();
                                  var cookies =
                                      localStorage.getString('cookies');
                                  var url =
                                      'http://200.105.69.227/tusmateriales-api/public/index.php/users/change/$id';
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
                                        builder: (context) => ListUsers(),
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
      ),
    );
  }

  Future<String> getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/users/get/all/all'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(body);

    return "Sucess";
  }
}
