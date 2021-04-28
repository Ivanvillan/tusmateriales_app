// Librerias
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/edit_corral.dart';
import 'package:tus_materiales_app/home/home.dart';
import 'package:tus_materiales_app/home/new_corral.dart';
import 'package:tus_materiales_app/home/show_corral.dart';

//
//
class ListCorral extends StatefulWidget {
  // Parametros iniciales
  final role;
  ListCorral({Key key, @required this.role}) : super(key: key);
  //
  @override
  _ListCorralState createState() => _ListCorralState();
}

class _ListCorralState extends State<ListCorral> {
  // Variables globales
  List data = List();
  //

  @override
  void initState() {
    // Funciones iniciales
    getCorral();
    //
    super.initState();
  }

  // Floatingbutton condicional para agregar un corralon
  Widget _floatingButton() {
    if (widget.role == '1') {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewCorral(),
            ),
          );
        },
        backgroundColor: Color(0xffe9501c),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      );
    } else {
      return Container();
    }
  }
  //

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // Appbar
        appBar: AppBar(
          title: Text('Listado de corralones'),
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
                  typeUser: widget.role,
                ),
              ),
            ),
          ),
        ),
        //
        body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            if (widget.role == '1') {
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
                                    data[i]['businessname'].toUpperCase() ??
                                        'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    data[i]['address'].toUpperCase() ?? 'N/A'),
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
                                    final id = data[i]['idcorral'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShowCorral(
                                          id: id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('Ver'),
                                ),
                              ),
                              Container(
                                child: RaisedButton(
                                  onPressed: () {
                                    final id = data[i]['idcorral'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditCorral(
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
                                    final id = data[i]['idcorral'];
                                    SharedPreferences localStorage =
                                        await SharedPreferences.getInstance();
                                    var cookies =
                                        localStorage.getString('cookies');
                                    var url =
                                        'http://200.105.69.227/tusmateriales-api/public/index.php/corrals/active/$id';
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
                                          builder: (context) => ListCorral(
                                            role: '1',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text('Estado'),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
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
                                    data[i]['businessname'].toUpperCase() ??
                                        'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    data[i]['address'].toUpperCase() ?? 'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(data[i]['phone'] ?? 'N/A'),
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
                                    // final id = data[i]['id'];
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => (
                                    //       id: id,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: Text('Ver'),
                                ),
                              ),
                              Container(
                                child: RaisedButton(
                                  onPressed: () {
                                    // final id = data[i]['id'];
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => (
                                    //       id: id,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: Text('Editar'),
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
            }
          },
        ),
        floatingActionButton: _floatingButton(),
      ),
    );
  }

  // Funciones
  Future<String> getCorral() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/corrals/get/all/all'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(body);

    return "Sucess";
  }
  //
}
