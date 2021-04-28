// Librerias
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/list_categories.dart';

//
class NewCategory extends StatefulWidget {
  // Parametros iniciales
  final roleUser;
  NewCategory({Key key, @required this.roleUser}) : super(key: key);
  //
  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  // Variables globales
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  var loading = false;
  //
  // Control del valor de los inputs
  final TextEditingController denominationController =
      new TextEditingController();
  final TextEditingController descriptionController =
      new TextEditingController();
  //

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        // Appbar
        appBar: AppBar(
          title: Text('Agregar categoria'),
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
                                controller: denominationController,
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
                            Icon(Icons.description),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: descriptionController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.text,
                                decoration:
                                    InputDecoration(labelText: 'Descripción'),
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
                content: Text('¿Crear categoria?'),
                actions: [
                  FlatButton(
                    child: Text('Si'),
                    onPressed: () async {
                      SharedPreferences localStorage =
                          await SharedPreferences.getInstance();
                      var cookies = localStorage.getString('cookies');
                      var url =
                          'http://200.105.69.227/tusmateriales-api/public/index.php/categories/create';
                      var response = await http.post(url, headers: {
                        'Accept': 'application/json',
                        'Cookie': cookies
                      }, body: {
                        "denomination": denominationController.text,
                        "description": descriptionController.text,
                      });
                      print(response.statusCode);
                      print(response.body);
                      if (response.statusCode == 200) {
                        Navigator.pop(c, false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListCategories(
                              idCorral: '',
                              roleUser: widget.roleUser,
                            ),
                          ),
                        );
                        scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text('Categoria creada'),
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
