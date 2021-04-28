// Librerias
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/list_address.dart';
import 'package:tus_materiales_app/home/send_order.dart';

//
class NewAddress extends StatefulWidget {
  // Parametros iniciales
  final idUser;
  final onShop;
  NewAddress({Key key, @required this.idUser, @required this.onShop})
      : super(key: key);
  //
  @override
  _NewAddressState createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  // Variables globales
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  //
  // Control del valor de los inputs
  final TextEditingController locationController = new TextEditingController();
  final TextEditingController cityController = new TextEditingController();
  //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        // Appbar
        appBar: AppBar(
          title: Text('Agregar dirección'),
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
                            Icon(Icons.house),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: locationController,
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
                            Icon(Icons.location_on),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: cityController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.text,
                                decoration:
                                    InputDecoration(labelText: 'Ciudad'),
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
                    ],
                  ),
                ),
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
                content: Text('¿Crear dirección?'),
                actions: [
                  FlatButton(
                    child: Text('Si'),
                    onPressed: () async {
                      SharedPreferences localStorage =
                          await SharedPreferences.getInstance();
                      var cookies = localStorage.getString('cookies');
                      var url =
                          'http://200.105.69.227/tusmateriales-api/public/index.php/addresses/add';
                      var response = await http.post(url, headers: {
                        'Accept': 'application/json',
                        'Cookie': cookies
                      }, body: {
                        "location": locationController.text,
                        "city": cityController.text,
                        "iduser": widget.idUser.toString()
                      });
                      print(response.statusCode);
                      print(response.body);
                      if (response.statusCode == 200 && widget.onShop == true) {
                        Navigator.pop(c, false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendOrder(),
                          ),
                        );
                        scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text('Dirección creada'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else if (response.statusCode == 200 &&
                          widget.onShop == false) {
                        Navigator.pop(c, false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListAddress(),
                          ),
                        );
                        scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text('Dirección creada'),
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
}
