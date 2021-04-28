// Librerias
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/list_product.dart';

//
class EditProduct extends StatefulWidget {
  // Parametros iniciales
  final id;
  final roleUser;
  EditProduct({Key key, @required this.id, @required this.roleUser})
      : super(key: key);
  //
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  // Variables globales
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List data = List();
  List data2 = List();
  var loading = false;
  // ignore: unused_field
  var _cat;
  var cat;
  // ignore: unused_field
  String _mySelection;
  //
  // Control del valor de los inputs
  TextEditingController detailController = new TextEditingController();
  TextEditingController additionalinformationController =
      new TextEditingController();
  //

  @override
  void initState() {
    // Funciones iniciales
    getCategories();
    getProduct();
    //
    super.initState();
  }

  // modal para elegir el producto
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
                  data[i]["denomination"] != null
                      ? data[i]["description"]
                      : 'No hay productos agregados',
                  style: TextStyle(fontSize: 16.0),
                ),
                onTap: () {
                  setState(
                    () {
                      cat = data[i]["denomination"];
                      _mySelection = data[i]["idcategorie"];
                      _cat = data[i]["denomination"];
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
          title: Text('Agregar producto'),
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
                                controller: detailController,
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
                            Icon(Icons.list),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: additionalinformationController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: 'Información adicional'),
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
                            child: Text(_cat != null
                                ? '$_cat'
                                : 'Seleccione una categoria'),
                            onPressed: () => showModal(context),
                          ),
                        ),
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
                content: Text('Editar producto?'),
                actions: [
                  FlatButton(
                    child: Text('Si'),
                    onPressed: () async {
                      SharedPreferences localStorage =
                          await SharedPreferences.getInstance();
                      var cookies = localStorage.getString('cookies');
                      var url =
                          'http://200.105.69.227/tusmateriales-api/public/index.php/generics/update';
                      var response = await http.post(url, headers: {
                        'Accept': 'application/json',
                        'Cookie': cookies
                      }, body: {
                        "detail": detailController.text,
                        "additionalinformation":
                            additionalinformationController.text,
                        "idcategorie": _mySelection.toString(),
                        "idgeneric": widget.id.toString()
                      });
                      print(response.statusCode);
                      print(response.body);
                      if (response.statusCode == 200) {
                        Navigator.pop(c, false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListProduct(
                              roleUser: widget.roleUser,
                            ),
                          ),
                        );
                        scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text('Producto Editado'),
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

  // Funciones
  Future<String> getCategories() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/categories/get/1/all'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(body);

    return "Sucess";
  }

  Future<String> getProduct() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    // username = localStorage.getString('username');
    // email = localStorage.getString('email');
    // role = localStorage.getString('role');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/generics/getbyid/${widget.id}'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data2 = body["result"];
    });

    detailController = new TextEditingController(text: data2[0]['detail']);
    additionalinformationController =
        new TextEditingController(text: data2[0]['additionalinformation']);
    return "Sucess";
  }
  //
}
