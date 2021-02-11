import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tus_materiales_app/home/cart_shop.dart';
import 'package:tus_materiales_app/home/detail_order.dart';
import 'package:tus_materiales_app/home/edit_article.dart';
import 'package:tus_materiales_app/home/edit_cant.dart';
import 'package:tus_materiales_app/home/list_address.dart';
import 'package:tus_materiales_app/home/list_article.dart';
import 'package:tus_materiales_app/home/list_categories.dart';
import 'package:tus_materiales_app/home/list_corral.dart';
import 'package:tus_materiales_app/home/list_message.dart';
import 'package:tus_materiales_app/home/list_order.dart';
import 'package:tus_materiales_app/home/list_product.dart';
import 'package:tus_materiales_app/home/list_users.dart';
import 'package:tus_materiales_app/home/new_address.dart';
import 'package:tus_materiales_app/home/new_article.dart';
import 'package:tus_materiales_app/home/new_category.dart';
import 'package:tus_materiales_app/home/new_corral.dart';
import 'package:tus_materiales_app/home/new_message.dart';
import 'package:tus_materiales_app/home/new_product.dart';
import 'package:tus_materiales_app/home/show_article.dart';
import 'package:tus_materiales_app/login/init.dart';
import 'package:tus_materiales_app/login/register.dart';
import 'package:tus_materiales_app/provider/cart_bloc.dart';

class Home extends StatefulWidget {
  final stateOrders;
  final typeUser;
  Home({Key key, @required this.stateOrders, @required this.typeUser})
      : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  String username;
  String email;
  var role;
  var id;
  List dataCorral = List();
  List dataCorrals = List();
  List dataOrders = List();
  List dataArticles = List();
  bool _loading = true;
  var roleProfile;
  var state;

  @override
  void initState() {
    initVar();
    super.initState();
  }

  _handleDrawer() async {
    setState(() {
      if (widget.typeUser == '1') {
        roleProfile = 'Administrador';
      } else if (widget.typeUser == '2') {
        roleProfile = 'Responsable';
      } else {
        roleProfile = 'Cliente';
      }
    });
    scaffoldKey.currentState.openDrawer();
  }

  Widget _buildDrawer() {
    if (roleProfile == 'Administrador') {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.all(0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xff57575b),
                          backgroundImage: AssetImage(
                            'assets/img/only-logo.png',
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(username.toString() != null
                                ? username.toString()
                                : ''),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(email.toString() != null
                                ? email.toString()
                                : ''),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(roleProfile.toString() != null
                                ? roleProfile.toString()
                                : ''),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          height: 30.0,
                          child: RaisedButton(
                            onPressed: () {
                              logout();
                            },
                            child: Text('Salir'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ExpansionTile(
              title: Text("Órdenes de pedido"),
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(
                            stateOrders: '1',
                            typeUser: widget.typeUser,
                          ),
                        ),
                      );
                    },
                    child: Text('Pendientes'),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(
                            stateOrders: '2',
                            typeUser: widget.typeUser,
                          ),
                        ),
                      );
                    },
                    child: Text('Realizadas'),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(
                            stateOrders: '3',
                            typeUser: widget.typeUser,
                          ),
                        ),
                      );
                    },
                    child: Text('Rechazadas'),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Corralones"),
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListCorral(
                            role: widget.typeUser,
                          ),
                        ),
                      );
                    },
                    child: Text('Administrar'),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewCorral(),
                        ),
                      );
                    },
                    child: Text('Nuevo Corralon'),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Usuarios"),
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListUsers(),
                        ),
                      );
                    },
                    child: Text('Administrar'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Register(
                                typeuser: '2',
                              ),
                            ),
                          );
                        },
                        child: Text('Nuevo Resp.'),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Register(
                                typeuser: '1',
                              ),
                            ),
                          );
                        },
                        child: Text('Nuevo Admin.'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Categorias"),
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListCategories(
                            idCorral: '',
                            roleUser: '1',
                          ),
                        ),
                      );
                    },
                    child: Text('Administrar'),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewCategory(
                            roleUser: '1',
                          ),
                        ),
                      );
                    },
                    child: Text('Nueva Categoria'),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Productos"),
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListProduct(
                            roleUser: '1',
                          ),
                        ),
                      );
                    },
                    child: Text('Administrar'),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewProduct(
                            roleUser: '1',
                          ),
                        ),
                      );
                    },
                    child: Text('Nuevo Producto'),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Mensajes"),
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListMessage(
                            idCorral: 'all',
                            idUser: 'all',
                            client: false,
                            roleUser: '1',
                          ),
                        ),
                      );
                    },
                    child: Text('Administrar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (roleProfile == 'Responsable') {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.all(0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xff57575b),
                          backgroundImage: AssetImage(
                            'assets/img/only-logo.png',
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(username.toString() != null
                                ? username.toString()
                                : ''),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(email.toString() != null
                                ? email.toString()
                                : ''),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(roleProfile.toString() != null
                                ? roleProfile.toString()
                                : ''),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          height: 30.0,
                          child: RaisedButton(
                            onPressed: () {
                              logout();
                            },
                            child: Text('Salir'),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            ExpansionTile(
              title: Text("Categorias"),
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListCategories(
                            idCorral: '',
                            roleUser: '2',
                          ),
                        ),
                      );
                    },
                    child: Text('Administrar'),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewCategory(
                            roleUser: '2',
                          ),
                        ),
                      );
                    },
                    child: Text('Nueva Categoria'),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Productos"),
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListProduct(
                            roleUser: '2',
                          ),
                        ),
                      );
                    },
                    child: Text('Administrar'),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewProduct(
                            roleUser: '2',
                          ),
                        ),
                      );
                    },
                    child: Text('Nuevo Producto'),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Articulos"),
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListArticles(
                            idCorral: dataCorral[0]['idcorral'],
                            client: false,
                          ),
                        ),
                      );
                    },
                    child: Text('Administrar'),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewArticle(
                            idCorral: dataCorral[0]['idcorral'],
                          ),
                        ),
                      );
                    },
                    child: Text('Nuevo Articulo'),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Mensajes"),
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListMessage(
                            idCorral: dataCorral[0]['idcorral'],
                            idUser: 'all',
                            client: false,
                            roleUser: '2',
                          ),
                        ),
                      );
                    },
                    child: Text('Administrar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.all(0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xff57575b),
                          backgroundImage: AssetImage(
                            'assets/img/only-logo.png',
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(username.toString() != null
                                ? username.toString()
                                : ''),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(email.toString() != null
                                ? email.toString()
                                : ''),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(roleProfile.toString() != null
                                ? roleProfile.toString()
                                : ''),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          height: 30.0,
                          child: RaisedButton(
                            onPressed: () {
                              logout();
                            },
                            child: Text('Salir'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ExpansionTile(
              title: Text("Corralones"),
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(
                            stateOrders: 'all',
                            typeUser: widget.typeUser,
                          ),
                        ),
                      );
                    },
                    child: Text('Listar'),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Órdenes de pedido"),
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListOrder(
                            stateOrder: '1',
                            idUser: id,
                          ),
                        ),
                      );
                    },
                    child: Text('Pendientes'),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListOrder(
                            stateOrder: '2',
                            idUser: id,
                          ),
                        ),
                      );
                    },
                    child: Text('Realizadas'),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListOrder(
                            stateOrder: '3',
                            idUser: id,
                          ),
                        ),
                      );
                    },
                    child: Text('Rechazadas'),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Mensajes"),
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListMessage(
                            idCorral: 'all',
                            idUser: id,
                            client: true,
                            roleUser: '3',
                          ),
                        ),
                      );
                    },
                    child: Text('Listar'),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewMessage(
                            roleUser: '3',
                          ),
                        ),
                      );
                    },
                    child: Text('Nuevo Mensaje'),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Direcciones"),
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListAddress(),
                        ),
                      );
                    },
                    child: Text('Listar'),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewAddress(
                            idUser: id,
                            onShop: false,
                          ),
                        ),
                      );
                    },
                    child: Text('Nuevo Mensaje'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.typeUser == '1') {
      return WillPopScope(
        onWillPop: () => showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text('Aviso'),
            content: Text('¿Quiere salir de la aplicación?'),
            actions: [
              FlatButton(
                child: Text('Si'),
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () => Navigator.pop(c, false),
              ),
            ],
          ),
        ),
        child: MaterialApp(
          home: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text('Inicio'),
              backgroundColor: Color(0xfff2920a),
              automaticallyImplyLeading: true,
              leading:
                  IconButton(icon: Icon(Icons.menu), onPressed: _handleDrawer),
            ),
            drawer: _buildDrawer(),
            body: ListView.builder(
              itemCount: dataOrders == null ? 0 : dataOrders.length,
              itemBuilder: (BuildContext context, i) {
                var stateOrder;
                if (dataOrders[i]['state'] == '1') {
                  stateOrder = 'Pendiente';
                } else if (dataOrders[i]['state'] == '2') {
                  stateOrder = 'Realizada';
                } else {
                  stateOrder = 'Rechazada';
                }
                return Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        final idOrder = dataOrders[i]['idorder'];
                        print(idOrder);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailOrder(
                              idOrder: idOrder,
                              client: false,
                              orderState: dataOrders[i]['state'],
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
                                    child: Text(dataOrders[i]['customer']
                                            .toUpperCase() ??
                                        'N/A'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(dataOrders[i]['location']
                                            .toUpperCase() ??
                                        'N/A'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Text(stateOrder.toUpperCase() ?? 'N/A'),
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
          ),
        ),
      );
    } else if (widget.typeUser == '2') {
      return WillPopScope(
        onWillPop: () => showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text('Aviso'),
            content: Text('¿Quiere salir de la aplicación?'),
            actions: [
              FlatButton(
                child: Text('Si'),
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () => Navigator.pop(c, false),
              ),
            ],
          ),
        ),
        child: MaterialApp(
          home: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text('Inicio'),
              backgroundColor: Color(0xfff2920a),
              automaticallyImplyLeading: true,
              leading:
                  IconButton(icon: Icon(Icons.menu), onPressed: _handleDrawer),
            ),
            drawer: _buildDrawer(),
            body: ListView.builder(
              itemCount: dataArticles == null ? 0 : dataArticles.length,
              itemBuilder: (BuildContext context, i) {
                if (dataArticles[i]['enabled'] == "1") {
                  state = 'Activo';
                } else {
                  state = 'Inactivo';
                }
                Widget _imageShow() {
                  if (dataArticles[i]['picture'] == 'NO IMAGE') {
                    return Container();
                  } else {
                    return Container(
                      width: MediaQuery.of(context).size.width / 6,
                      height: MediaQuery.of(context).size.height / 6,
                      child: Image.network(
                        'http://200.105.69.227/tusmateriales-api/uploads/${dataArticles[i]['picture']}',
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
                                      child: Text(dataArticles[i]['detail']
                                              .toUpperCase() ??
                                          'N/A'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(dataArticles[i]['brand']
                                              .toUpperCase() ??
                                          'N/A'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(dataArticles[i]
                                                  ['businessname']
                                              .toUpperCase() ??
                                          'N/A'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                          '\$${dataArticles[i]['price']}' ??
                                              'N/A'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                          dataArticles[i]['quantity'] ?? 'N/A'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(state),
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
                                      final idArticle =
                                          dataArticles[i]['idarticle'];
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
                                      final id = dataArticles[i]['idarticle'];
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
                                      final id = dataArticles[i]['idarticle'];
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
                                ),
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
                    builder: (context) => NewArticle(
                      idCorral: dataCorral[0]['idcorral'],
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
        ),
      );
    } else if (widget.typeUser == '3') {
      var bloc = Provider.of<CustomerList>(context);
      int totalCount = 0;
      if (bloc.customers.length > 0) {
        totalCount = bloc.customers.length;
      }
      return WillPopScope(
        onWillPop: () => showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text('Aviso'),
            content: Text('¿Quiere salir de la aplicación?'),
            actions: [
              FlatButton(
                child: Text('Si'),
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () => Navigator.pop(c, false),
              ),
            ],
          ),
        ),
        child: MaterialApp(
          home: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text('Inicio'),
              backgroundColor: Color(0xfff2920a),
              actions: <Widget>[
                InkWell(
                  onTap: () {
                    if (totalCount == 0) {
                      scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text(
                              'Agregue materiales al carrito para acceder'),
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
              leading:
                  IconButton(icon: Icon(Icons.menu), onPressed: _handleDrawer),
            ),
            drawer: _buildDrawer(),
            body: ListView.builder(
              itemCount: dataCorrals == null ? 0 : dataCorrals.length,
              itemBuilder: (BuildContext context, i) {
                // var state;
                // if (data[i]['enabled'] == '1') {
                //   state = 'Activo';
                // } else {
                //   state = 'Deshabilitado';
                // }
                return Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        final idCorral = dataCorrals[i]['idcorral'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListCategories(
                              idCorral: idCorral,
                              roleUser: '3',
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
                                    child: Text(dataCorrals[i]['businessname']
                                            .toUpperCase() ??
                                        'N/A'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(dataCorrals[i]['address']
                                            .toUpperCase() ??
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
          ),
        ),
      );
    } else {
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: InkWell(
              onTap: () {
                logout();
              },
              child: Text('Presiona para iniciar sesión'),
            ),
          ),
        ),
      );
    }
  }

  void initVar() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    username = localStorage.getString('username');
    email = localStorage.getString('email');
    role = localStorage.getString('role');
    id = localStorage.getString('id');
    if (widget.typeUser == '1') {
      getOrders();
    } else if (widget.typeUser == '2') {
      getCorral();
    } else if (widget.typeUser == '3') {
      getCorrals();
    } else {
      print('error');
    }
  }

  Future<String> getCorral() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var id = localStorage.getString('id');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/corrals/get/1/$id'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      dataCorral = body["result"];
    });
    print(body);
    getArticles();
    return "Sucess";
  }

  Future<String> getCorrals() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/corrals/get/1/all'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    print(body);
    setState(() {
      dataCorrals = body["result"];
    });
    print(dataCorrals);
    _loading = false;
    return "Sucess";
  }

  Future<String> getOrders() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/orders/get/${widget.stateOrders}/all'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      dataOrders = body["result"];
    });
    print(dataOrders);
    _loading = false;
    return "Sucess";
  }

  Future<String> getArticles() async {
    var idCorral = dataCorral[0]['idcorral'];
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/articles/get/$idCorral/all/all'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      dataArticles = body["result"];
    });
    print(body);
    _loading = false;
    return "Sucess";
  }

  logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var id = localStorage.getString('id');
    var url =
        'http://200.105.69.227/tusmateriales-api/public/index.php/users/logout';
    var response = await http.post(url,
        headers: {'Accept': 'application/json', 'Cookie': cookies},
        body: {"id": id.toString()});
    print(response.body);
    if (response.statusCode == 200) {
      localStorage.remove('cookies');
      localStorage.remove('role');
      localStorage.remove('email');
      localStorage.remove('username');
      localStorage.remove('id');
      Navigator.push(context, MaterialPageRoute(builder: (context) => Init()));
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Error al cerrar sesión'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
