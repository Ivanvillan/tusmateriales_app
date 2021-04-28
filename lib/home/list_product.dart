// Librerias
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/edit_product.dart';
import 'package:tus_materiales_app/home/home.dart';
import 'package:tus_materiales_app/home/new_product.dart';
import 'package:http/http.dart' as http;
import 'package:tus_materiales_app/home/show_product.dart';

//
class ListProduct extends StatefulWidget {
  // Parametros iniciales
  final roleUser;
  ListProduct({
    Key key,
    @required this.roleUser,
  }) : super(key: key);
  //
  @override
  _ListProductState createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  // Variables iniciales
  List data = List();
  //

  @override
  void initState() {
    // Funciones iniciales
    getProducts();
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // Appbar
        appBar: AppBar(
          title: Text('Listado de productos'),
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
                                  data[i]['detail'].toUpperCase() ?? 'N/A'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(data[i]['additionalinformation']
                                      .toUpperCase() ??
                                  'N/A'),
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
                                  final idProduct = data[i]['idgeneric'];
                                  final idCat = data[i]['idcategorie'];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShowProduct(
                                        idProduct: idProduct,
                                        idCat: idCat,
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
                                  final id = data[i]['idgeneric'];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProduct(
                                        id: id,
                                        roleUser: widget.roleUser,
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
                                  final id = data[i]['idgeneric'];
                                  SharedPreferences localStorage =
                                      await SharedPreferences.getInstance();
                                  var cookies =
                                      localStorage.getString('cookies');
                                  var url =
                                      'http://200.105.69.227/tusmateriales-api/public/index.php/generics/enabled/$id';
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
                                        builder: (context) => ListProduct(
                                          roleUser: widget.roleUser,
                                        ),
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
                builder: (context) => NewProduct(
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
        ),
      ),
    );
  }

  // Funciones
  Future<String> getProducts() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/generics/get/all/all'),
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
