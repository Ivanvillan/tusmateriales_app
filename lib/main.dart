// Librerias
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/home.dart';
import 'package:tus_materiales_app/login/init.dart';
import 'package:tus_materiales_app/provider/cart_bloc.dart';

//
//
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Variables globales
  var isLogin = false;
  var typeUser;
  var statusCode;
  //
  //
  @override
  void initState() {
    super.initState();
    // Funciones iniciales
    checkLogin();
    //
    //
  }

  @override
  Widget build(BuildContext context) {
    // Provider para los articulos del carrito
    return ChangeNotifierProvider<CustomerList>(
      builder: (context) => CustomerList(
        customers: [],
      ),
      //
      // inicio de la app
      child: MaterialApp(home: initializationApp()),
      //
    );
  }

  // Funciones
  checkLogin() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    typeUser = localStorage.getString('role');
    if (cookies != null) {
      setState(() {
        isLogin = true;
      });
    }
  }

  Widget initializationApp() {
    if (isLogin == true) {
      return Home(
        stateOrders: 'all',
        typeUser: typeUser,
      );
    } else {
      return Init();
    }
  }
  //
}
