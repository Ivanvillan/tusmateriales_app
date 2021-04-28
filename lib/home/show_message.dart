// Librerias
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

//
class ShowMessage extends StatefulWidget {
  // Parametros inciales
  final id;
  final client;
  ShowMessage({Key key, @required this.id, @required this.client})
      : super(key: key);
  //
  @override
  _ShowMessageState createState() => _ShowMessageState();
}

class _ShowMessageState extends State<ShowMessage> {
  // Variables globales
  List data = List();
  List data2 = List();
  List data3 = List();
  var reason;
  bool _loading = true;
  //

  @override
  void initState() {
    // Funciones iniciales
    getMessage();
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(child: Center(child: CircularProgressIndicator()));
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Información del mensaje'),
          backgroundColor: Color(0xfff2920a),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            if (data[i]['reason'] == '1') {
              reason = 'Solicitud';
            } else if (data[i]['reason'] == '2') {
              reason = 'Acopio';
            } else {
              reason = 'Otro';
            }
            if (widget.client == true) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('DATOS DEL MENSAJE',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Divider(
                        color: Colors.black38,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text('DE:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(data3[i]['name'].toUpperCase() ?? 'N/A'),
                                Divider(
                                  indent: 3,
                                ),
                                Text(
                                    data3[i]['surname'].toUpperCase() ?? 'N/A'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text('MAIL:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(data3[i]['email'].toUpperCase() ?? 'N/A'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text('TELÉFONO:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(data3[i]['phone'].toUpperCase() ?? 'N/A'),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black38,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text('PARA:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(data2[i]['businessname'].toUpperCase() ??
                                'N/A'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            _launchURL('mailto:${data2[i]['email']}');
                          },
                          child: Column(
                            children: <Widget>[
                              Text('MAIL:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(data2[i]['email'].toUpperCase() ?? 'N/A'),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _launchURL('tel://${data2[i]['phone']}');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text('TELÉFONO:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(data2[i]['phone'].toUpperCase() ?? 'N/A'),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black38,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text('RAZÓN',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(reason ?? 'N/A'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text('MENSAJE',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(data[i]['text'] ?? 'N/A'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('DATOS DEL MENSAJE',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Divider(
                        color: Colors.black38,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text('DE:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(data3[i]['name'].toUpperCase() ?? 'N/A'),
                                Divider(
                                  indent: 3,
                                ),
                                Text(
                                    data3[i]['surname'].toUpperCase() ?? 'N/A'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _launchURL('mailto:${data3[i]['email']}');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text('MAIL:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(data3[i]['email'].toUpperCase() ?? 'N/A'),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _launchURL('tel://${data3[i]['phone']}');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text('TELÉFONO:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(data3[i]['phone'].toUpperCase() ?? 'N/A'),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black38,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text('PARA:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(data2[i]['businessname'].toUpperCase() ??
                                'N/A'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text('MAIL:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(data2[i]['email'].toUpperCase() ?? 'N/A'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text('TELÉFONO:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(data2[i]['phone'].toUpperCase() ?? 'N/A'),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black38,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text('RAZÓN',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(reason ?? 'N/A'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text('MENSAJE',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(data[i]['text'] ?? 'N/A'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Funciones
  Future<String> getMessage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/messages/getbyid/${widget.id}'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    getCorral();
    getUser();
    return "Sucess";
  }

  Future<String> getCorral() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/corrals/getbyid/${data[0]['idcorral']}'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data2 = body["result"];
    });
    print(body);
    return "Sucess";
  }

  Future<String> getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/users/getbyid/${data[0]['iduser']}'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data3 = body["result"];
    });
    print(body);
    _loading = false;
    return "Sucess";
  }

  _launchURL(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      throw 'Could not launch $command';
    }
  }
  //
}
