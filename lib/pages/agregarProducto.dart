import 'dart:io';

import 'package:app_contabilidad/Services/ExpandableFab.dart';
import 'package:app_contabilidad/Services/ProductoService.dart';
import 'package:app_contabilidad/models/carritoCompras.dart';
import 'package:app_contabilidad/models/productos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:app_contabilidad/constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../Services/message.dart';
import 'dart:convert';

class AgregarProducto extends StatefulWidget {
  final changeView;

  AgregarProducto({this.changeView});
  @override
  State<StatefulWidget> createState() {
    return AgregarProductoState();
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

class AgregarProductoState extends State<AgregarProducto> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  ProductosModel temProduct = ProductosModel();
  final collectionSnp = FirebaseFirestore.instance.collection('tags').get();
  final formKey = GlobalKey<FormState>();
  Object value = 0;
  Object tax;
  List<DropdownMenuItem> temp = [];
  List<String> taxes = ['IVA 5%', 'IVA 15%', 'IVA 19%', 'CONSUMO 18%'];

  String p;

  String peso;
  void getToken() async {
    await messaging.getToken().then((String result) => p = result.toString());
    print(p);
    token = p;
    temProduct.token = p;
  }

  int _messageCount = 0;
  String constructFCMPayload(String token) {
    _messageCount++;
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': _messageCount.toString(),
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (#$_messageCount) was created via FCM!',
      },
    });
  }

  String _token;

  @override
  void initState() {
    super.initState();
    getToken();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        Navigator.pushNamed(context, '/message',
            arguments: MessageArguments(message, true));
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(context, '/message',
          arguments: MessageArguments(message, true));
    });
  }

  Future<void> sendPushMessage() async {
    _token = token;
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(_token),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadData() async {
    var value = Uuid().v1();
    String refe = "/Products/$value.jpg";
    FirebaseStorage.instance.ref().child(refe).putFile(image);
    refProduct = FirebaseStorage.instance.ref(refe);
  }

  String linkk;
  Future<void> _downloadLink() async {
    var value = Uuid().v1();
    String refe = "/Products/$value.jpg";
    await FirebaseStorage.instance.ref().child(refe).putFile(image);
    refProduct = FirebaseStorage.instance.ref(refe);

    final link = await refProduct.getDownloadURL();
    linkk = link;
    uuid = linkk;
    temProduct.urlImagen = uuid.toString();
  }

//temProduct.urlImagen = url
  final picker = ImagePicker();
  Future getImageCamera() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      setState(() {
        if (pickedFile != null) {
          image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      Text('No tiene Camara');
    }
  }

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  agregarProducto() async {
    await _downloadLink();
    ProductoService.addNewProduct(temProduct);
    ProductoService.addVarianToProduct(
        temProduct.nombre, Variante(nombreV: peso, valorV: temProduct.valor)
        );
    widget.changeView(1);
    sendPushMessage();
    image = null;
  }

  Widget _buildAlertDialog() {
    return AlertDialog(
      title: Text('Error'),
      content: Text("Por favor, seleccione una imagen. :)"),
      actions: [
        TextButton(
            child: Text("Aceptar"),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    );
  }

  Future _showMyDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => _buildAlertDialog(),
    );
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.all(24),
          child: ListView(children: [
            Form(
                key: formKey,
                child: Container(
                  margin: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: image == null
                            ? SizedBox(
                                height: 80,
                                child: Image(
                                  image: NetworkImage(
                                      'https://i.ibb.co/0Jmshvb/no-image.png'),
                                ),
                              )
                            : SizedBox(height: 80, child: Image.file(image)),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nombre del producto...',
                        ),
                        validator: (nombre) {
                          if (nombre.isEmpty) {
                            return 'El producto debe tener un nombre.';
                          }
                          temProduct.nombre = nombre;
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Valor del producto...',
                        ),
                        validator: (valor) {
                          if (valor.isEmpty) {
                            return 'El producto debe tener un valor.';
                          }
                          try {
                            double.parse(valor);
                            temProduct.valor = valor;
                          } catch (e) {
                            return 'El valor del producto es inválido';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Peso/tamaño del producto...',
                        ),
                        validator: (valor) {
                          if (valor.isEmpty) {
                            return 'El producto debe tener un Peso/tamaño.';
                          }
                          peso = valor;
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        validator: (val) {
                          if (val == null)
                            return 'El producto debe tener un impuesto';
                          else
                            return null;
                        },
                        hint: Text('Seleccionar impuesto...'),
                        onChanged: (e) => this.setState(() {
                          tax = e;
                          temProduct.tipoImpuesto = e;
                        }),
                        value: tax,
                        items: <DropdownMenuItem>[
                          ...taxes.map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                          future: collectionSnp,
                          // ignore: missing_return
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              for (var i = 0;
                                  i < snapshot.data.docs.length;
                                  i++) {
                                if (temp.any((el) =>
                                    el.value.nombreEtiqueta ==
                                    snapshot.data.docs[i].get('name'))) {
                                } else
                                  temp.add(DropdownMenuItem(
                                    child: Text(
                                      '#' + snapshot.data.docs[i].get('name'),
                                      style: TextStyle(
                                          color: getColorFromHex(snapshot
                                              .data.docs[i]
                                              .get('color'))),
                                    ),
                                    value: Etiqueta(
                                        nombreEtiqueta:
                                            snapshot.data.docs[i].get('name'),
                                        color:
                                            snapshot.data.docs[i].get('color')),
                                  ));
                              }
                              return DropdownButtonFormField(
                                hint: Text('Elegir etiqueta...'),
                                onChanged: (e) => this.setState(() {
                                  value = e;
                                  if (e == 0) {
                                    temProduct.etiqueta = null;
                                  } else {
                                    temProduct.etiqueta = e;
                                  }
                                }),
                                value: value,
                                items: <DropdownMenuItem>[
                                  DropdownMenuItem(
                                    child: Text('Sin etiqueta'),
                                    value: 0,
                                  ),
                                  ...temp
                                ],
                              );
                            } else
                              return Text('Cargando...');
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    (image != null)
                                        ? agregarProducto()
                                        : _showMyDialog(context);
                                  }
                                },
                                child: Text('Crear Producto'),
                                style: ElevatedButton.styleFrom(
                                    primary: secundario)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: TextButton(
                                onPressed: () {
                                  widget.changeView(1);
                                  image = null;
                                },
                                child: Text('Cancelar'),
                                style: TextButton.styleFrom(primary: primario)),
                          )
                        ],
                      ),
                    ],
                  ),
                ))
          ])),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: getImageCamera,
            icon: const Icon(Icons.add_a_photo),
          ),
          ActionButton(
            onPressed: getImageGallery,
            icon: const Icon(Icons.insert_photo),
          ),
        ],
      ),
    );
  }
}
