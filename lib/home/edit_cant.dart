import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/home.dart';
import 'package:tus_materiales_app/home/list_article.dart';

class EditCant extends StatefulWidget {
  final id;
  EditCant({Key key, @required this.id}) : super(key: key);
  @override
  _EditCantState createState() => _EditCantState();
}

class _EditCantState extends State<EditCant> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var loading = false;

  List<dynamic> data;

  @override
  void initState() {
    getArticle();
    super.initState();
  }

  TextEditingController quantityController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Editar cantidad y precio del artículo'),
          backgroundColor: Color(0xfff2920a),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(
                  stateOrders: '',
                  typeUser: '2',
                ),
              ),
            ),
          ),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_shopping_cart),
                      SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2 + 20,
                        child: TextFormField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Cantidad'),
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
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.payment),
                      SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2 + 20,
                        child: TextFormField(
                          controller: priceController,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Precio'),
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
                  SizedBox(
                    height: 5.0,
                  ),
                  loading
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Container(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: RaisedButton(
                            onPressed: () async {
                              SharedPreferences localStorage =
                                  await SharedPreferences.getInstance();
                              var cookies = localStorage.getString('cookies');
                              var url =
                                  'http://200.105.69.227/tusmateriales-api/public/index.php/articles/save';
                              var response = await http.post(url, headers: {
                                'Accept': 'application/json',
                                'Cookie': cookies
                              }, body: {
                                "idgeneric": data[0]['article']['idgeneric'],
                                "idcorral": data[0]['article']['idcorral'],
                                "brand": data[0]['article']['brand'],
                                "nomenclature": data[0]['article']
                                    ['nomenclature'],
                                "price": priceController.text,
                                "quantity": quantityController.text,
                                "idarticle": widget.id.toString(),
                              });
                              print(response.statusCode);
                              print(response.body);
                              if (response.statusCode == 200) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ListArticles(
                                      client: false,
                                      idCorral: data[0]['article']['idcorral'],
                                    ),
                                  ),
                                );
                                scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text('Articulo editado'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text('Error'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            color: Color(0xffe9501c),
                            child: Text(
                              'Editar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getArticle() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/articles/getbyid/${widget.id}'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    Map<String, dynamic> map = json.decode(response.body);
    print(map);
    setState(() {
      data = map["result"];
    });
    quantityController =
        TextEditingController(text: data[0]['article']['quantity']);
    priceController = TextEditingController(text: data[0]['article']['price']);
    return "Sucess";
  }
}
