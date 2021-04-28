// librerias
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/home.dart';
import 'package:tus_materiales_app/home/new_message.dart';
import 'package:tus_materiales_app/home/show_message.dart';

//
class ListMessage extends StatefulWidget {
  // parametros iniciales
  final idCorral;
  final idUser;
  final client;
  final roleUser;
  ListMessage(
      {Key key,
      @required this.idCorral,
      @required this.idUser,
      @required this.client,
      @required this.roleUser})
      : super(key: key);
  //
  @override
  _ListMessageState createState() => _ListMessageState();
}

class _ListMessageState extends State<ListMessage> {
  // variables globales
  List data = List();
  //
  @override
  void initState() {
    // funciones iniciales
    getMessage();
    //
    super.initState();
  }

  // muestra un floating button si es un cliente
  Widget _floatingButton() {
    if (widget.client == true) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewMessage(
                roleUser: widget.roleUser,
              ),
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
          title: Text('Listado de mensajes'),
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
                  typeUser: widget.roleUser,
                ),
              ),
            ),
          ),
        ),
        //
        body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            var reason;
            if (data[i]['reason'] == '1') {
              reason = 'Solicitud';
            } else if (data[i]['reason'] == '2') {
              reason = 'Acopio';
            } else {
              reason = 'Otro';
            }
            // listado de mensajes si es cliente
            if (widget.client == true) {
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
                                child: Text(reason.toUpperCase() ?? 'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    data[i]['businessname'].toUpperCase() ??
                                        'N/A'),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                child: RaisedButton(
                                  onPressed: () {
                                    final id = data[i]['idmessage'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShowMessage(
                                          id: id,
                                          client: true,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('Ver'),
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
              //
              // listado de mensajes si es corralon o administrador
            } else {
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
                                child: Text(reason.toUpperCase() ?? 'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    data[i]['since'].toUpperCase() ?? 'N/A'),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                child: RaisedButton(
                                  onPressed: () {
                                    final id = data[i]['idmessage'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShowMessage(
                                          id: id,
                                          client: false,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('Ver'),
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
            }
          },
        ),
        floatingActionButton: _floatingButton(),
      ),
    );
  }

  // Funciones
  Future<String> getMessage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/messages/get/${widget.idCorral}/${widget.idUser}'),
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
