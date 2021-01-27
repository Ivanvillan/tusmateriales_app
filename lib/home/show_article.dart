import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/home.dart';

class ShowArticle extends StatefulWidget {
  final idArticle;
  ShowArticle({Key key, @required this.idArticle}) : super(key: key);
  @override
  _ShowArticleState createState() => _ShowArticleState();
}

class _ShowArticleState extends State<ShowArticle> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List<dynamic> data;

  @override
  void initState() {
    getArticle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Información del artículo'),
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
        body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            Widget showImage() {
              if (data[i]['pictures'] != false) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 4,
                        height: MediaQuery.of(context).size.height / 6,
                        child: InkWell(
                          onTap: () {
                            showDialog<bool>(
                              context: context,
                              builder: (c) => AlertDialog(
                                title: Text('Aviso'),
                                content: Text('¿Eliminar imagen?'),
                                actions: [
                                  FlatButton(
                                    child: Text('Si'),
                                    onPressed: () async {
                                      SharedPreferences localStorage =
                                          await SharedPreferences.getInstance();
                                      var cookies =
                                          localStorage.getString('cookies');
                                      var url =
                                          'http://200.105.69.227/tusmateriales-api/public/index.php/articles/deleteimage/${data[i]['pictures']['idpicture']}';
                                      var response = await http.post(url,
                                          headers: {
                                            'Accept': 'application/json',
                                            'Cookie': cookies
                                          });
                                      print(response.statusCode);
                                      print(response.body);
                                      if (response.statusCode == 200) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ShowArticle(
                                              idArticle: data[i]['article']
                                                  ['idarticle'],
                                            ),
                                          ),
                                        );
                                        scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                            content: Text('Imagen eliminada'),
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
                                      Navigator.pop(c, false);
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              'http://200.105.69.227/tusmateriales-api/uploads/${data[i]['pictures']['name']}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  showImage(),
                  Card(
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('DATOS DEL ARTICULO',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Divider(
                          color: Colors.black38,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text('NOMBRE',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(data[i]['article']['detail'] ?? 'N/A'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text('DETALLE',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(data[i]['article']['denomination'] ?? 'N/A'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text('MARCA',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(data[i]['article']['Test'] ?? 'N/A'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text('DESCRIPCION',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(data[i]['article']['nomenclature'] ?? 'N/A'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text('PRECIO',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(data[i]['article']['price'] ?? 'N/A'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text('CANTIDAD',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(data[i]['article']['quantity'] ?? 'N/A'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text('CATEGORIA',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(data[i]['article']['denomination'] ?? 'N/A'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text('CORRALON',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(data[i]['article']['businessname'] ?? 'N/A'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<String> getArticle() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/articles/getbyid/${widget.idArticle}'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    Map<String, dynamic> map = json.decode(response.body);
    print(map);
    setState(() {
      data = map["result"];
    });
    return "Sucess";
  }
}
