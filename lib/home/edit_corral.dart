// Librerias
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/list_corral.dart';
//

class EditCorral extends StatefulWidget {
  // Parametros iniciales
  final id;
  EditCorral({Key key, @required this.id}) : super(key: key);
  //
  @override
  _EditCorralState createState() => _EditCorralState();
}

class _EditCorralState extends State<EditCorral> {
  // Variables globales
  List data = List();
  List data2 = List();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  var loading = false;
  // ignore: unused_field
  var _client;
  var client;
  // ignore: unused_field
  String _mySelection;
  //
  // Control del valor de los inputs
  TextEditingController businessnameController;
  TextEditingController phoneController;
  TextEditingController alternativephoneController;
  TextEditingController emailController;
  TextEditingController addressController;
  //

  @override
  void initState() {
    // Funciones iniciales
    getClient();
    getCorral();
    //
    super.initState();
  }

  // Modal para agregar un responsable
  void showModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(8.0),
          height: 200,
          alignment: Alignment.center,
          child: ListView.separated(
            itemCount: data2 == null ? 0 : data2.length,
            separatorBuilder: (context, int) {
              return Divider(
                height: 10.0,
              );
            },
            itemBuilder: (context, i) {
              return GestureDetector(
                child: Text(
                  data2[i]["name"] != null
                      ? '${data2[i]["name"]} ${data2[i]["surname"]}'
                      : 'No hay responsables agregados',
                  style: TextStyle(fontSize: 16.0),
                ),
                onTap: () {
                  setState(
                    () {
                      client = data[i]["name"];
                      _mySelection = data[i]["iduser"];
                      _client = '${data2[i]["name"]} ${data2[i]["surname"]} ';
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
  //

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        // Appbar
        appBar: AppBar(
          title: Text('Editar corralon'),
          backgroundColor: Color(0xfff2920a),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        //
        body: ListView(
          children: [
            Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.local_offer),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: businessnameController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.text,
                                decoration:
                                    InputDecoration(labelText: 'Nombre'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Rellenar el campo';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.mail),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(labelText: 'Email'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Rellenar el campo';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.location_on),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: addressController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.text,
                                decoration:
                                    InputDecoration(labelText: 'Dirección'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Rellenar el campo';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.phone_android),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration:
                                    InputDecoration(labelText: 'Teléfono'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Rellenar el campo';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.phone),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: alternativephoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    labelText: 'Teléfono alternativo'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Rellenar el campo';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RaisedButton(
                            color: Color(0xff2e2925),
                            textColor: Color(0xffFFFBFB),
                            child: Text(_client != null
                                ? '$_client'
                                : 'Seleccione un responsable'),
                            onPressed: () => showModal(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          // Funcion
          onPressed: () {
            showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text('Aviso'),
                content: Text('¿Editar corralon?'),
                actions: [
                  FlatButton(
                      child: Text('Si'),
                      onPressed: () async {
                        print(_mySelection);
                        SharedPreferences localStorage =
                            await SharedPreferences.getInstance();
                        var cookies = localStorage.getString('cookies');
                        var url =
                            'http://200.105.69.227/tusmateriales-api/public/index.php/corrals/update';
                        var response = await http.post(url, headers: {
                          'Accept': 'application/json',
                          'Cookie': cookies
                        }, body: {
                          "businessname": businessnameController.text,
                          "email": emailController.text,
                          "phone": phoneController.text,
                          "alternative_phone": alternativephoneController.text,
                          "address": addressController.text,
                          "iduser": _mySelection.toString(),
                          "idcorral": widget.id.toString()
                        });
                        print(response.statusCode);
                        print(response.body);
                        if (response.statusCode == 200) {
                          Navigator.pop(c, false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListCorral(
                                role: '1',
                              ),
                            ),
                          );
                          scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text('Corralon editado'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          Navigator.pop(c, false);
                          scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text('Error'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }),
                  FlatButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                ],
              ),
            );
          },
          //
          backgroundColor: Color(0xffe9501c),
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Funciones
  showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Cerrar',
        onPressed: () {},
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<String> getClient() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/users/get/2/all'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data2 = body["result"];
    });
    print(body);

    return "Sucess";
  }

  Future<String> getCorral() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/corrals/getbyid/${widget.id}'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });

    businessnameController =
        new TextEditingController(text: data[0]['businessname']);
    phoneController = new TextEditingController(text: data[0]['phone']);
    alternativephoneController =
        new TextEditingController(text: data[0]['alternative_phone']);
    emailController = new TextEditingController(text: data[0]['email']);
    addressController = new TextEditingController(text: data[0]['address']);

    return "Sucess";
  }
  //
}
