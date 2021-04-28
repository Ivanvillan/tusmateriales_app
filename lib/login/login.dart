// Librerias
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/home.dart';

//
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Variables globales
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool loading = false;
  var cookies = "";
  //
  // Controlador de valores en los inputs
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // Appbar
        appBar: AppBar(
          title: Text('Inicio de sesión'),
          backgroundColor: Color(0xfff2920a),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        //
        key: scaffoldKey,
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.mail),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: 'Ingrese su email'),
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
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.lock),
                          SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 + 20,
                            child: TextFormField(
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                  labelText: 'Ingrese su contraseña'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Rellenar el campo';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                loading
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: RaisedButton(
                          color: Color(0xff2e2925),
                          textColor: Color(0xffffffff),
                          onPressed: () {
                            login();
                          },
                          child: Text('INGRESAR'),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Cerrar',
        onPressed: () {},
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  // Funciones
  login() async {
    setState(() {
      loading = true;
    });
    var url =
        'http://200.105.69.227/tusmateriales-api/public/index.php/users/login';
    var response = await http.post(url, headers: {
      'Accept': 'application/json',
    }, body: {
      "email": emailController.text,
      "contrasenia": passwordController.text
    });
    var body = json.decode(response.body);
    print(body);
    if (body['response'] == true) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('cookies', response.headers['set-cookie']);
      var url =
          'http://200.105.69.227/tusmateriales-api/public/index.php/users/state';
      var res = await http.post(url, headers: {
        'Accept': 'application/json',
        'Cookie': response.headers['set-cookie']
      });
      var resbody = json.decode(res.body);
      print(resbody);
      localStorage.setString('username', resbody['result']['user']);
      localStorage.setString('email', resbody['result']['email']);
      localStorage.setString('role', resbody['result']['role']);
      localStorage.setString('id', resbody['result']['ID']);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Has iniciado sesión'),
        duration: Duration(seconds: 2),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            stateOrders: 'all',
            typeUser: resbody['result']['role'],
          ),
        ),
      );
    } else {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Error al iniciar sesión, comprueba tus datos'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    setState(() {
      loading = false;
    });
  }
}
