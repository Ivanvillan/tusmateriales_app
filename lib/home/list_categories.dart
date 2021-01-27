import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/cart_shop.dart';
import 'package:tus_materiales_app/home/edit_category.dart';
import 'package:tus_materiales_app/home/home.dart';
import 'package:tus_materiales_app/home/list_article.dart';
import 'package:tus_materiales_app/home/new_category.dart';
import 'package:http/http.dart' as http;
import 'package:tus_materiales_app/provider/cart_bloc.dart';

class ListCategories extends StatefulWidget {
  final idCorral;
  final roleUser;
  ListCategories({Key key, @required this.idCorral, @required this.roleUser})
      : super(key: key);
  @override
  _ListCategoriesState createState() => _ListCategoriesState();
}

class _ListCategoriesState extends State<ListCategories> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List data = List();

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  Widget _floatingButton() {
    if (widget.idCorral == '') {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewCategory(
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

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CustomerList>(context);
    int totalCount = 0;
    if (bloc.customers.length > 0) {
      totalCount = bloc.customers.length;
    }
    if (widget.idCorral == '') {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Listado de categorias'),
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
                                    data[i]['denomination'].toUpperCase() ??
                                        'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    data[i]['description'].toUpperCase() ??
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
                                    final id = data[i]['idcategorie'];
                                    final state = data[i]['enabled'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditCategory(
                                          id: id,
                                          state: state,
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
                                    final id = data[i]['idcategorie'];
                                    SharedPreferences localStorage =
                                        await SharedPreferences.getInstance();
                                    var cookies =
                                        localStorage.getString('cookies');
                                    var url =
                                        'http://200.105.69.227/tusmateriales-api/public/index.php/categories/visible/$id';
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
                                          builder: (context) => ListCategories(
                                            idCorral: '',
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
          floatingActionButton: _floatingButton(),
        ),
      );
    } else {
      return MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text('Listado de categorias'),
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
              return Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      final idCorral = widget.idCorral;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListArticles(
                            idCorral: idCorral,
                            client: true,
                          ),
                        ),
                      );
                    },
                    child: Card(
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
                                      data[i]['denomination'].toUpperCase() ??
                                          'N/A'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      data[i]['description'].toUpperCase() ??
                                          'N/A'),
                                ),
                              ],
                            ),
                            Container(
                              child: Icon(Icons.arrow_right),
                            )
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

  Future<String> getCategories() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/categories/get/all/all'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(body);

    return "Sucess";
  }
}
