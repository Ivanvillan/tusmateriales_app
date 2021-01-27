import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tus_materiales_app/home/home.dart';

class Register extends StatefulWidget {
  final typeuser;
  Register({Key key, @required this.typeuser}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

// class Role {
//   int id;
//   String name;

//   Role(this.id, this.name);

//   static List<Role> getRole() {
//     return <Role>[
//       Role(1, 'Administrador'),
//       Role(2, 'Usuario'),
//       Role(3, 'Invitado'),
//     ];
//   }
// }

class _RegisterState extends State<Register> {
  // List<Role> _role = Role.getRole();
  // List<DropdownMenuItem<Role>> _dropdownMenuItems;
  // Role _selectedRole;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool loading = false;
  // bool loading = false;

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController surnameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();

  @override
  void initState() {
    print(widget.typeuser);
    // _dropdownMenuItems = buildDropdownMenuItems(_role);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Registro de usuario'),
          backgroundColor: Color(0xfff2920a),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
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
                            Icon(Icons.person),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: nameController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: 'Ingrese su nombre'),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.perm_identity),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: surnameController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: 'Ingrese su apellido'),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.smartphone),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    labelText: 'Ingrese su nro. telefónico'),
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
                      ),
                      // SizedBox(
                      //   height: 10.0,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: <Widget>[
                      //     Icon(Icons.verified_user),
                      //     SizedBox(
                      //       width: 10.0,
                      //     ),
                      //     Container(
                      //       child: DropdownButton(
                      //         hint: Text('Rol del usuario'),
                      //         value: _selectedRole,
                      //         items: _dropdownMenuItems,
                      //         onChanged: onChangeDropdownItem,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                // loading
                //     ? Padding(
                //         padding: const EdgeInsets.only(top: 20.0),
                //         child: Container(
                //           child: CircularProgressIndicator(),
                //         ),
                //       )
                //     :
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: RaisedButton(
                    color: Color(0xff2e2925),
                    textColor: Color(0xffffffff),
                    onPressed: () {
                      // if (_formKey.currentState.validate()) {
                      //   Scaffold.of(context).showSnackBar(
                      //       SnackBar(content: Text('Processing Data')));
                      // }
                      showDialog<bool>(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: Text('Aviso'),
                          content: Text('¿Crear usuario?'),
                          actions: [
                            FlatButton(
                              child: Text('Si'),
                              onPressed: () async {
                                if (widget.typeuser == 1) {
                                  var url =
                                      'http://200.105.69.227/tusmateriales-api/public/index.php/users/register';
                                  var response = await http.post(url, headers: {
                                    'Accept': 'application/json'
                                    // 'Cookie': cookies
                                  }, body: {
                                    "name": nameController.text,
                                    "surname": surnameController.text,
                                    "email": emailController.text,
                                    "phone": phoneController.text,
                                    "password": passwordController.text,
                                    "role": 3.toString()
                                  });
                                  print(response.statusCode);
                                  print(response.body);
                                  var body = json.decode(response.body);
                                  if (body['response'] ==
                                      'EL USUARIO SE CREO CORRECTAMENTE') {
                                    login();
                                  } else {
                                    scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Error al crear usuario, comprueba tus datos'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                } else if (widget.typeuser == 2) {
                                  SharedPreferences localStorage =
                                      await SharedPreferences.getInstance();
                                  var cookies =
                                      localStorage.getString('cookies');
                                  var url =
                                      'http://200.105.69.227/tusmateriales-api/public/index.php/users/register';
                                  var response = await http.post(
                                    url,
                                    headers: {
                                      'Accept': 'application/json',
                                      'Cookie': cookies
                                    },
                                    body: {
                                      "name": nameController.text,
                                      "surname": surnameController.text,
                                      "email": emailController.text,
                                      "phone": phoneController.text,
                                      "password": passwordController.text,
                                      "role": 2.toString()
                                    },
                                  );
                                  print(response.statusCode);
                                  print(response.body);
                                  var body = json.decode(response.body);
                                  if (body['response'] ==
                                      'EL USUARIO SE CREO CORRECTAMENTE') {
                                    Navigator.pop(c, false);
                                    scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text('Usuario creado'),
                                      duration: Duration(seconds: 2),
                                    ));
                                    setState(
                                      () {
                                        nameController.clear();
                                        surnameController.clear();
                                        emailController.clear();
                                        phoneController.clear();
                                        passwordController.clear();
                                        // _selectedRole = null;
                                      },
                                    );
                                  } else {
                                    Navigator.pop(c, false);
                                    scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Error al crear usuario, comprueba tus datos'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                } else {
                                  SharedPreferences localStorage =
                                      await SharedPreferences.getInstance();
                                  var cookies =
                                      localStorage.getString('cookies');
                                  var url =
                                      'http://200.105.69.227/tusmateriales-api/public/index.php/users/register';
                                  var response = await http.post(
                                    url,
                                    headers: {
                                      'Accept': 'application/json',
                                      'Cookie': cookies
                                    },
                                    body: {
                                      "name": nameController.text,
                                      "surname": surnameController.text,
                                      "email": emailController.text,
                                      "phone": phoneController.text,
                                      "password": passwordController.text,
                                      "role": 1.toString()
                                    },
                                  );
                                  print(response.statusCode);
                                  print(response.body);
                                  var body = json.decode(response.body);
                                  if (body['response'] ==
                                      'EL USUARIO SE CREO CORRECTAMENTE') {
                                    Navigator.pop(c, false);
                                    scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text('Usuario creado'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                    setState(
                                      () {
                                        nameController.clear();
                                        surnameController.clear();
                                        emailController.clear();
                                        phoneController.clear();
                                        passwordController.clear();
                                        // _selectedRole = null;
                                      },
                                    );
                                  } else {
                                    Navigator.pop(c, false);
                                    scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Error al crear usuario, comprueba tus datos'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                }
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
                    child: Text('ACEPTAR'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // List<DropdownMenuItem<Role>> buildDropdownMenuItems(List roles) {
  //   List<DropdownMenuItem<Role>> items = List();
  //   for (Role role in roles) {
  //     items.add(
  //       DropdownMenuItem(
  //         value: role,
  //         child: Text(role.name),
  //       ),
  //     );
  //   }
  //   return items;
  // }

  // onChangeDropdownItem(Role selectedRole) {
  //   if (!mounted) return;
  //   setState(() {
  //     _selectedRole = selectedRole;
  //   });
  // }

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
            stateOrders: '',
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
