// Librerias
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tus_materiales_app/home/list_message.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

//
class NewMessage extends StatefulWidget {
  // Parametros iniciales
  final roleUser;
  NewMessage({Key key, @required this.roleUser}) : super(key: key);
  //
  @override
  _NewMessageState createState() => _NewMessageState();
}

// Dropdown para elegir el motivo del mensaje
class Reason {
  int id;
  String name;

  Reason(this.id, this.name);

  static List<Reason> getReason() {
    return <Reason>[
      Reason(1, 'Solicitud'),
      Reason(2, 'Acopio'),
      Reason(3, 'Otro'),
    ];
  }
}

//
class _NewMessageState extends State<NewMessage> {
  // Variables globales
  List<Reason> _reason = Reason.getReason();
  List<DropdownMenuItem<Reason>> _dropdownMenuItems;
  Reason _selectedReason;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List data = List();
  List data2 = List();
  List data3 = List();
  var loading = false;
  var iduser;
  // ignore: unused_field
  var _corral;
  var corral;
  // ignore: unused_field
  String _mySelection;
  var id;
  //
  // Control del valor de los inputs
  final TextEditingController textController = new TextEditingController();
  //
  @override
  void initState() {
    // Funciones y valores inciales
    _dropdownMenuItems = buildDropdownMenuItems(_reason);
    getCorral();
    getUser();
    //
    super.initState();
  }

  // Modal para elegir corralon en mensaje
  void showModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(8.0),
          height: 200,
          alignment: Alignment.center,
          child: ListView.separated(
            itemCount: data == null ? 0 : data.length,
            separatorBuilder: (context, int) {
              return Divider(
                height: 10.0,
              );
            },
            itemBuilder: (context, i) {
              return GestureDetector(
                child: Text(
                  data[i]["businessname"] != null
                      ? '${data[i]["businessname"]}'
                      : 'No hay corralones agregados',
                  style: TextStyle(fontSize: 16.0),
                ),
                onTap: () {
                  setState(
                    () {
                      corral = data[i]["businessname"];
                      _mySelection = data[i]["idcorral"];
                      _corral = '${data[i]["businessname"]}';
                    },
                  );
                  getCorralById();
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }
  //

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        // Appbar
        appBar: AppBar(
          title: Text('Enviar mensaje'),
          backgroundColor: Color(0xfff2920a),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        //
        body: ListView(
          children: [
            Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.question_answer),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextField(
                                controller: textController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.text,
                                maxLines: 3,
                                decoration: InputDecoration(
                                    labelText: 'Escriba su mensaje aquí'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.read_more),
                          SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            child: DropdownButton(
                              hint: Text('Razón'),
                              value: _selectedReason,
                              items: _dropdownMenuItems,
                              onChanged: onChangeDropdownItem,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RaisedButton(
                            color: Color(0xff2e2925),
                            textColor: Color(0xffFFFBFB),
                            child: Text(_corral != null
                                ? '$_corral'
                                : 'Seleccione un corralon'),
                            onPressed: () => showModal(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          // Funcion
          onPressed: () {
            showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text('Aviso'),
                content: Text('¿Enviar mensaje?'),
                actions: [
                  FlatButton(
                      child: Text('Si'),
                      onPressed: () async {
                        SharedPreferences localStorage =
                            await SharedPreferences.getInstance();
                        var cookies = localStorage.getString('cookies');
                        var url =
                            'http://200.105.69.227/tusmateriales-api/public/index.php/messages/create';
                        var response = await http.post(url, headers: {
                          'Accept': 'application/json',
                          'Cookie': cookies
                        }, body: {
                          "iduser": iduser.toString(),
                          "idcorral": _mySelection.toString(),
                          "reason": _selectedReason.id.toString(),
                          "text": textController.text
                        });
                        print(response.statusCode);
                        print(response.body);
                        if (response.statusCode == 200) {
                          sendMail();
                          Navigator.pop(c, false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListMessage(
                                idCorral: 'all',
                                idUser: iduser,
                                client: true,
                                roleUser: widget.roleUser,
                              ),
                            ),
                          );
                          scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text('Mensaje enviado'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          Navigator.pop(c, false);
                          scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text('Error'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }),
                  FlatButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                ],
              ),
            );
          },
          //
          backgroundColor: Color(0xffe9501c),
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Funciones
  List<DropdownMenuItem<Reason>> buildDropdownMenuItems(List reasons) {
    List<DropdownMenuItem<Reason>> items = List();
    for (Reason reason in reasons) {
      items.add(
        DropdownMenuItem(
          value: reason,
          child: Text(reason.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Reason selectedReason) {
    if (!mounted) return;
    setState(() {
      _selectedReason = selectedReason;
    });
  }

  Future<String> getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    iduser = localStorage.getString('id');
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/users/getbyid/$iduser'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data2 = body["result"];
    });
    print(body);

    return 'success';
  }

  Future<String> getCorral() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/corrals/get/1/all'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(body);

    return "Sucess";
  }

  Future<String> getCorralById() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/corrals/getbyid/$_mySelection'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data3 = body["result"];
    });
    return "Sucess";
  }

  sendMail() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var name = localStorage.getString('username').toUpperCase();
    String username = 'tusmaterialesapp@gmail.com';
    String password = 'materialesapp1';
    final smtpServer =
        SmtpServer('smtp.gmail.com', username: username, password: password);

    final message = Message()
      ..from = Address(username)
      ..recipients.add(data3[0]['email'])
      ..ccRecipients.addAll(['maximiliano.albitre@gerdau.com'])
      ..bccRecipients.add(Address('ivanvillan54@gmail.com'))
      ..subject = 'Nuevo mensaje de: $name'
      ..text = '\nINFORMACIÓN\n'
          ' · Razón: ${_selectedReason.name}\n'
          ' · Teléfono: ${data2[0]['phone']}\n'
          ' · Teléfono: ${data2[0]['email']}\n'
          '\nMENSAJE\n'
          '· ${textController.text}';
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
    }
  }
  //
}
