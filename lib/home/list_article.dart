import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/cart_shop.dart';
import 'package:tus_materiales_app/home/edit_article.dart';
import 'package:tus_materiales_app/home/edit_cant.dart';
import 'package:tus_materiales_app/home/home.dart';
import 'package:tus_materiales_app/home/new_article.dart';
import 'package:tus_materiales_app/home/show_article.dart';
import 'package:tus_materiales_app/provider/cart_bloc.dart';

class ListArticles extends StatefulWidget {
  final idCorral;
  final client;

  ListArticles({Key key, @required this.idCorral, @required this.client})
      : super(key: key);
  @override
  _ListArticlesState createState() => _ListArticlesState();
}

class _ListArticlesState extends State<ListArticles> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  var idImage;
  List data = List();
  List data2 = List();

  final TextEditingController quantityController = new TextEditingController();

  @override
  void initState() {
    getArticles();
    super.initState();
  }

  Widget _floatingButton() {
    if (widget.client == false) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewArticle(
                idCorral: widget.idCorral,
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

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CustomerList>(context);
    int totalCount = 0;
    if (bloc.customers.length > 0) {
      totalCount = bloc.customers.length;
    }
    if (widget.client == false) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Listado de artículos'),
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
                    typeUser: '2',
                  ),
                ),
              ),
            ),
          ),
          body: ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, i) {
              Widget _imageShow() {
                if (data[i]['picture'] == 'NO IMAGE') {
                  return Container();
                } else {
                  return Container(
                    width: MediaQuery.of(context).size.width / 6,
                    height: MediaQuery.of(context).size.height / 6,
                    child: Image.network(
                      'http://200.105.69.227/tusmateriales-api/uploads/${data[i]['picture']}',
                      fit: BoxFit.cover,
                    ),
                  );
                }
              }

              return Column(
                children: <Widget>[
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              _imageShow(),
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                        data[i]['detail'].toUpperCase() ??
                                            'N/A'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                        data[i]['brand'].toUpperCase() ??
                                            'N/A'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                        data[i]['businessname'].toUpperCase() ??
                                            'N/A'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(data[i]['price'] ?? 'N/A'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(data[i]['quantity'] ?? 'N/A'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                child: RaisedButton(
                                  onPressed: () {
                                    final idArticle = data[i]['idarticle'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShowArticle(
                                          idArticle: idArticle,
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
                                    final id = data[i]['idarticle'];
                                    print(id);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditArticle(
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
                                  onPressed: () {
                                    final id = data[i]['idarticle'];
                                    print(id);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditCant(
                                          id: id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('Cant./Prec.'),
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
          floatingActionButton: _floatingButton(),
        ),
      );
    } else {
      return MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text('Listado de artículos'),
            backgroundColor: Color(0xfff2920a),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(Icons.search),
              ),
              InkWell(
                onTap: () {
                  if (totalCount == 0) {
                    scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content:
                            Text('Agregue materiales al carrito para acceder'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartShop(),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 6,
                    child: Stack(
                      children: <Widget>[
                        new IconButton(
                          icon: new Icon(
                            Icons.shopping_cart,
                            color: Color(0xff2e2925),
                            size: 32.0,
                          ),
                          onPressed: null,
                        ),
                        new Positioned(
                          child: new Stack(
                            children: <Widget>[
                              new Icon(
                                Icons.brightness_1,
                                size: 16.0,
                                color: Color(0xff2e2925),
                              ),
                              new Positioned(
                                top: 1.0,
                                right: 4.0,
                                child: new Center(
                                  child: new Text(
                                    '$totalCount',
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, i) {
              Widget _imageShow() {
                if (data[i]['picture'] == 'NO IMAGE') {
                  return Container();
                } else {
                  return Container(
                    width: MediaQuery.of(context).size.width / 6 + 40,
                    height: MediaQuery.of(context).size.height / 6,
                    child: Image.network(
                      'http://200.105.69.227/tusmateriales-api/uploads/${data[i]['picture']}',
                      fit: BoxFit.cover,
                    ),
                  );
                }
              }

              return Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 120.0,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Center(child: Text('Agregar cantidad')),
                                  Container(
                                    height: 30.0,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: TextFormField(
                                      controller: quantityController,
                                      textAlign: TextAlign.center,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('Cerrar',
                                              style: TextStyle(
                                                  color: Color(0xff57575b))),
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3 -
                                              20,
                                          height: 20.0,
                                          child: RaisedButton(
                                            color: Color(0xffe9501c),
                                            textColor: Colors.white,
                                            onPressed: () {
                                              Provider.of<CustomerList>(context)
                                                  .addToCart(i);
                                              Provider.of<CustomerList>(context)
                                                  .addCustomer(
                                                Customer(
                                                  idcorral: widget.idCorral
                                                      .toString(),
                                                  detail: data[i]['detail'],
                                                  brand: data[i]['brand'],
                                                  idarticle: data[i]
                                                          ["idarticle"]
                                                      .toString(),
                                                  price: data[i]["price"],
                                                  quantity: int.parse(
                                                      quantityController.text),
                                                ),
                                              );
                                              quantityController.clear();
                                              Navigator.pop(context);
                                              //Provider.of<CustomerList>(context).addProdList();
                                            },
                                            child: Text('Listo'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            _imageShow(),
                            Column(
                              children: <Widget>[
                                Text(data[i]['detail'].toUpperCase() ?? 'N/A'),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                      data[i]['brand'].toUpperCase() ?? 'N/A'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                      data[i]['businessname'].toUpperCase() ??
                                          'N/A'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text('\$${data[i]['price']}' ?? 'N/A'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: _floatingButton(),
        ),
      );
    }
  }

  Future<String> getArticles() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/articles/get/${widget.idCorral}/all/all'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(body);
    return "Sucess";
  }

  // Future<String> getImages(id) async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var cookies = localStorage.getString('cookies');
  //   var response = await http.get(
  //       ('http://200.105.69.227/tusmateriales-api/public/index.php/articles/getimages/$id'),
  //       headers: {'Accept': 'application/json', 'Cookie': cookies});
  //   var body = json.decode(response.body);
  //   setState(() {
  //     data2 = body["result"];
  //   });
  //   print(body);
  //   return "Sucess";
  // }
}
