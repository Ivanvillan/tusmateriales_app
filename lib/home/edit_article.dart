// Librerias
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tus_materiales_app/home/home.dart';
import 'package:tus_materiales_app/home/list_article.dart';
//

class EditArticle extends StatefulWidget {
  // Parametros iniciales
  final id;
  EditArticle({Key key, @required this.id}) : super(key: key);
  //
  @override
  _EditArticleState createState() => _EditArticleState();
}

class _EditArticleState extends State<EditArticle> {
  // Variables globales
  List data = List();
  List data2 = List();
  List data3 = List();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  var loading = false;
  // ignore: unused_field
  var _prod;
  var prod;
  // ignore: unused_field
  String _mySelection;
  Future<File> file;
  File tmpFile;
  String errMessage = 'Error al subir imagen';
  String status = '';
  bool redirect = false;
  //
  // Control del valor de los inputs
  TextEditingController brandController;
  TextEditingController nomenclatureController;
  TextEditingController priceController;
  TextEditingController quantityController;
  //
  //
  // Widget para mostrar imagen a subir
  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 3 - 60,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error al elegir imagen',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'Ninguna imagen seleccionada',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  //
  //
  // Modal para elegir el producto a subir
  void showModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(8.0),
          height: 200,
          alignment: Alignment.center,
          child: ListView.separated(
            itemCount: data2 == null ? 0 : data2.length,
            separatorBuilder: (context, int) {
              return Divider(
                height: 10.0,
              );
            },
            itemBuilder: (context, i) {
              return GestureDetector(
                child: Text(
                  data2[i]["detail"] != null
                      ? '${data2[i]["detail"]} ${data2[i]["additionalinformation"]}'
                      : 'No hay productos agregados',
                  style: TextStyle(fontSize: 16.0),
                ),
                onTap: () {
                  setState(
                    () {
                      prod = data2[i]["detail"];
                      _mySelection = data2[i]["idgeneric"];
                      _prod =
                          '${data2[i]["detail"]} ${data2[i]["additionalinformation"]} ';
                    },
                  );
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
  void initState() {
    // Funciones iniciales
    getArticle();
    getGeneric();
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        // Appbar
        appBar: AppBar(
          title: Text('Editar artículo'),
          backgroundColor: Color(0xfff2920a),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListArticles(
                  client: false,
                  idCorral: data[0]['article']['idcorral'],
                ),
              ),
            ),
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
                            Icon(Icons.local_offer),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: brandController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(labelText: 'Marca'),
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
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.article),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: nomenclatureController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.text,
                                decoration:
                                    InputDecoration(labelText: 'Descripción'),
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
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.payment),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: priceController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecoration(labelText: 'Precio'),
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
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.add_shopping_cart),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 + 20,
                              child: TextFormField(
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecoration(labelText: 'Cantidad'),
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
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RaisedButton(
                            color: Color(0xff2e2925),
                            textColor: Color(0xffFFFBFB),
                            child: Text(_prod != null
                                ? '$_prod'
                                : 'Seleccione un producto'),
                            onPressed: () => showModal(context),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 4 + 20,
                              child: RaisedButton(
                                  color: Color(0xff2e2925),
                                  textColor: Color(0xffFFFBFB),
                                  child: Text('Elegir imagen'),
                                  onPressed: () => chooseImageGallery()),
                            ),
                            Divider(
                              indent: 10.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 4 + 20,
                              child: RaisedButton(
                                  color: Color(0xff2e2925),
                                  textColor: Color(0xffFFFBFB),
                                  child: Text('Tomar imagen'),
                                  onPressed: () => chooseImageShot()),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      SizedBox(
                        height: 100,
                        child: Column(
                          children: [
                            showImage(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      loading
                          ? Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: RaisedButton(
                                // Funcion
                                onPressed: () async {
                                  SharedPreferences localStorage =
                                      await SharedPreferences.getInstance();
                                  var cookies =
                                      localStorage.getString('cookies');
                                  var url =
                                      'http://200.105.69.227/tusmateriales-api/public/index.php/articles/save';
                                  var response = await http.post(url, headers: {
                                    'Accept': 'application/json',
                                    'Cookie': cookies
                                  }, body: {
                                    "idgeneric": _mySelection,
                                    "idcorral": data[0]['article']['idcorral'],
                                    "brand": brandController.text,
                                    "nomenclature": nomenclatureController.text,
                                    "price": priceController.text,
                                    "quantity": quantityController.text,
                                    "idarticle": widget.id.toString(),
                                  });
                                  print(response.statusCode);
                                  print(response.body);
                                  if (response.statusCode == 200) {
                                    startUpload();
                                    scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text('Articulo editado'),
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
                                },
                                //
                                color: Color(0xffe9501c),
                                child: Text(
                                  'Editar artículo',
                                  style: TextStyle(color: Colors.white),
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
      ),
    );
  }

  // Funciones
  Future<String> getArticle() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/articles/getbyid/${widget.id}'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data = body["result"];
    });
    print(data);
    brandController =
        new TextEditingController(text: data[0]['article']['brand']);
    nomenclatureController =
        new TextEditingController(text: data[0]['article']['nomenclature']);
    priceController =
        new TextEditingController(text: data[0]['article']['price']);
    quantityController =
        new TextEditingController(text: data[0]['article']['quantity']);

    return "Sucess";
  }

  Future<String> getGeneric() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    var response = await http.get(
        ('http://200.105.69.227/tusmateriales-api/public/index.php/generics/get/all/all'),
        headers: {'Accept': 'application/json', 'Cookie': cookies});
    var body = json.decode(response.body);
    setState(() {
      data2 = body["result"];
    });

    return "Sucess";
  }

  chooseImageShot() {
    setState(() {
      // ignore: deprecated_member_use
      file = ImagePicker.pickImage(
          source: ImageSource.camera, maxHeight: 480, maxWidth: 640);
    });
  }

  chooseImageGallery() {
    setState(() {
      // ignore: deprecated_member_use
      file = ImagePicker.pickImage(
          source: ImageSource.gallery, maxHeight: 480, maxWidth: 640);
    });
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName);
  }

  upload(String fileName) async {
    setState(() {
      loading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    Map<String, String> headers = {'Cookie': cookies};
    var stream =
        // ignore: deprecated_member_use
        new http.ByteStream(DelegatingStream.typed(tmpFile.openRead()));
    var length = await tmpFile.length();
    var uri = Uri.parse(
        'http://200.105.69.227/tusmateriales-api/public/index.php/articles/addimage');
    final multipartRequest = new http.MultipartRequest('POST', uri);
    multipartRequest.headers.addAll(headers);
    multipartRequest.fields['idArticle'] = widget.id.toString();
    multipartRequest.files.add(http.MultipartFile("picture[]", stream, length,
        filename: basename(tmpFile.path),
        contentType: MediaType('image', 'png')));
    var response = await multipartRequest.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.push(
        scaffoldKey.currentContext,
        MaterialPageRoute(
          builder: (context) => ListArticles(
            client: false,
            idCorral: data[0]['article']['idcorral'],
          ),
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
    setState(() {
      loading = false;
    });
  }
  //
}
