import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tus_materiales_app/home/home.dart';
import 'package:tus_materiales_app/login/not_connection.dart';
import 'package:tus_materiales_app/login/init.dart';
import 'package:tus_materiales_app/provider/cart_bloc.dart';
import 'package:retry/retry.dart';
import 'package:http/http.dart' as http;


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
  var statusCode;

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
        home: ConnectivityCheck(
          child: initializationApp(),
        )
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

void httpConnection() async{
      final r = RetryOptions(maxAttempts: 8);
      final response = await r.retry(
      // Make a GET request
      () => http.get('https://google.com').timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );  
    print(response.statusCode);
    statusCode = response.statusCode;
    // if (response.statusCode == 200) {
    //   checkLogin();
    // }else{
    //     Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => NotConnection(
    //       ),
    //     ),
    //   );
    // }
  }

  Widget initializationApp(){
    if (isLogin == true){
      return Home(
              stateOrders: 'all',
              typeUser: typeUser,
            );
    } else{
      return Init();
    }
  }

}
