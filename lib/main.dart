import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/home.dart';
import 'package:tus_materiales_app/login/init.dart';
import 'package:tus_materiales_app/provider/cart_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var isLogin = false;
  var typeUser;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CustomerList>(
      builder: (context) => CustomerList(
        customers: [],
      ),
      child: MaterialApp(
        home: isLogin
            ? Home(
                stateOrders: 'all',
                typeUser: typeUser,
              )
            : Init(),
      ),
    );
  }

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
}
