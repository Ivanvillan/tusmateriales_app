import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tus_materiales_app/home/list_users.dart';

class EditUser extends StatefulWidget {
  final id;
  EditUser({Key key, @required this.id}) : super(key: key);
  @override
  _EditUserState createState() => _EditUserState();
}

class Role {
  int id;
  String name;

  Role(this.id, this.name);

  static List<Role> getRole() {
    return <Role>[
      Role(1, 'Administrador'),
      Role(2, 'Responsable'),
      Role(3, 'Cliente'),
    ];
  }
}

class _EditUserState extends State<EditUser> {
  List data = List();
  var state;
  var rol;
  List<Role> _role = Role.getRole();
  List<DropdownMenuItem<Role>> _dropdownMenuItems;
  Role _selectedRole;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool loading = false;

  TextEditingController nameController;
  TextEditingController surnameController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController phoneController;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_role);
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Editar usuario'),
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
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.verified_user),
                          SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            child: DropdownButton(
                              hint: Text('Rol del usuario'),
                              value: _selectedRole,
                              items: _dropdownMenuItems,
                              onChanged: onChangeDropdownItem,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: RaisedButton(
                    color: Color(0xff2e2925),
                    textColor: Color(0xffffffff),
                    onPressed: () {
                      showDialog<bool>(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: Text('Aviso'),
                          content: Text('¿Crear usuario?'),
                          actions: [
                            FlatButton(
                              child: Text('Si'),
                              onPressed: () async {
                                SharedPreferences localStorage =
                                    await SharedPreferences.getInstance();
                                var cookies = localStorage.getString('cookies');
                                var url =
                                    'http://200.105.69.227/tusmateriales-api/public/index.php/users/edit';
                                var response = await http.post(url, headers: {
                                  'Accept': 'application/json',
                                  'Cookie': cookies
                                }, body: {
                                  "name": nameController.text,
                                  "surname": surnameController.text,
                                  "email": emailController.text,
                                  "phone": phoneController.text,
                                  "password": passwordController.text,
                                  "role": _selectedRole.id.toString(),
                                  "id": widget.id
                                });
                                print(response.statusCode);
                                print(response.body);
                                if (response.statusCode == 200) {
                                  Navigator.pop(c, false);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ListUsers(),
                                    ),
                                  );
                                  scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text('Usuario editado'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  Navigator.pop(c, false);
                                  scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Error al editar usuario, comprueba tus datos'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
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

  List<DropdownMenuItem<Role>> buildDropdownMenuItems(List roles) {
    List<DropdownMenuItem<Role>> items = List();
    for (Role role in roles) {
      items.add(
        DropdownMenuItem(
          value: role,
          child: Text(role.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Role selectedRole) {
    if (!mounted) return;
    setState(() {
      _selectedRole = selectedRole;
    });
  }

  Future<String> getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/users/getbyid/${widget.id}'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });

    nameController = new TextEditingController(text: data[0]['name']);
    surnameController = new TextEditingController(text: data[0]['surname']);
    emailController = new TextEditingController(text: data[0]['email']);
    phoneController = new TextEditingController(text: data[0]['phone']);

    return "Sucess";
  }
}
