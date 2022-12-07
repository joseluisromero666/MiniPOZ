import 'dart:io';

import 'package:app_contabilidad/constants.dart';
import 'package:app_contabilidad/models/carritoCompras.dart';
import 'package:app_contabilidad/models/employees.dart';
import 'package:app_contabilidad/Services/EmployeeService.dart';
import 'package:app_contabilidad/Services/ExpandableFab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Services/message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class AddEmployee extends StatefulWidget {
  final addView;
  final changeView;
  final index;
  AddEmployee({this.addView, this.changeView, this.index});
  @override
  AddEmployeeState createState() => AddEmployeeState(
      addView: this.addView, index: this.index, changeView: this.changeView);
}

class AddEmployeeState extends State<AddEmployee> {
  final changeView;
  final addView;
  final index;
  AddEmployeeState({this.changeView, @required this.addView, this.index});
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final EmployeeModel newEmployee = EmployeeModel();
  final formKey = GlobalKey<FormState>();

  final employeesCollection =
      FirebaseFirestore.instance.collection('employees').snapshots();

  Widget _buildNombreField({String name}) {
    return TextFormField(
      keyboardType: TextInputType.text,
      initialValue: (widget.addView) ? "" : name,
      decoration: InputDecoration(labelText: 'Nombre'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'El nombre está vacío.';
        }
        newEmployee.nombre = value;
        return null;
      },
    );
  }

  Widget _buildDocumentoField({String document}) {
    return TextFormField(
      keyboardType: TextInputType.number,
      initialValue: (widget.addView) ? "" : document,
      decoration: InputDecoration(labelText: 'Documento'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'El documento está vacío.';
        }
        newEmployee.documento = value;
        getToken();
        newEmployee.token = token;

        return null;
      },
    );
  }

  String p;
  void getToken() async {
    await messaging.getToken().then((String result) => p = result.toString());
    print(p);
    token = p;
    newEmployee.token = p;
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
    String refe = "/Employees/$value.jpg";
    FirebaseStorage.instance.ref().child(refe).putFile(image);
    refEmployee = FirebaseStorage.instance.ref(refe);
  }

  String linkk;
  Future<void> _downloadLink() async {
    var value = Uuid().v1();
    String refe = "/Employees/$value.jpg";
    await FirebaseStorage.instance.ref().child(refe).putFile(image);
    refEmployee = FirebaseStorage.instance.ref(refe);

    final link = await refEmployee.getDownloadURL();
    linkk = link;
    uuid = linkk;
    newEmployee.foto = uuid.toString();
  }

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

  agregarEmpleado() async {
    await _downloadLink();
    ApplicationState.addEmployee(newEmployee);
    getToken();
    sendPushMessage();
    image = null;
    refEmployee = null;
    changeView(1);
  }

  editarEmpleado() async {
    await _downloadLink();
    ApplicationState.editEmployee(newEmployee);
    getToken();
    sendPushMessage();
    image = null;
    refEmployee = null;
    changeView(1);
  }

  Widget _buildCorreoField({String urlImg}) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      initialValue: (widget.addView) ? "" : urlImg,
      decoration: InputDecoration(labelText: 'Correo'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Hay campos vacios';
        }
        newEmployee.correo = value;
        return null;
      },
    );
  }

  Widget _buildTelefonoField({String urlImg}) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      initialValue: (widget.addView) ? "" : urlImg,
      decoration: InputDecoration(labelText: 'Telefono'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'El Teléfono está vacío.';
        }
        newEmployee.telefono = value;
        return null;
      },
    );
  }

  InputDecoration formDecoration() {
    return InputDecoration(
      errorStyle: TextStyle(
        fontSize: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(width: 0, style: BorderStyle.none),
      ),
      fillColor: Color(0xFFF3F3F4),
      filled: true,
      hoverColor: Color(0xFFF3F3F4),
    );
  }

  Widget _buildRoleeField() {
    String selected;
    return DropdownButtonFormField<String>(
      decoration: formDecoration(),
      value: selected,
      items: ["cliente", "administrador"]
          .map(
            (label) => DropdownMenuItem(
              child: Text(
                label,
              ),
              value: label,
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          selected = value;
          newEmployee.role = value;
        });
      },
      validator: (String value) {
        if (value == null) {
          return "El rol está vacío.";
        }
        newEmployee.role = value;
        return null;
      },
    );
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.all(24),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    (addView) ? 'Agregar empleado' : 'Editar empleado',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (addView)
                            ? Column(
                                children: [
                                  Center(
                                    child: image == null
                                        ? SizedBox(
                                            height: 80,
                                            child: Image(
                                              image: NetworkImage(
                                                  'https://i.ibb.co/0Jmshvb/no-image.png'),
                                            ),
                                          )
                                        : SizedBox(
                                            height: 80,
                                            child: Image.file(image)),
                                  ),
                                  _buildNombreField(),
                                  _buildDocumentoField(),
                                  _buildCorreoField(),
                                  _buildTelefonoField(),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  _buildRoleeField()
                                ],
                              )
                            : StreamBuilder(
                                stream: employeesCollection,
                                builder: (context, snapshot) => snapshot.hasData
                                    ? (snapshot.data.docs.length != 0)
                                        ? Column(
                                            children: [
                                              Center(
                                                child: image == null
                                                    ? SizedBox(
                                                        height: 100,
                                                        child: Image(
                                                          image: NetworkImage(
                                                              snapshot
                                                                  .data
                                                                  .docs[widget
                                                                      .index]
                                                                  .get(
                                                                      'urlImg')),
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        height: 100,
                                                        child:
                                                            Image.file(image)),
                                              ),
                                              _buildNombreField(
                                                  name: snapshot
                                                      .data.docs[index]
                                                      .get('name')),
                                              _buildDocumentoField(
                                                  document: snapshot
                                                      .data.docs[index]
                                                      .get('document')),
                                              _buildCorreoField(
                                                  urlImg: snapshot
                                                      .data.docs[index]
                                                      .get('email')),
                                            ],
                                          )
                                        : Text('El empleado no exite')
                                    : CircularProgressIndicator()),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: secundarioLight,
                          onPrimary: Colors.black,
                          onSurface: secundarioDark,
                        ),
                        child: Text(
                          (addView) ? 'Agregar' : 'Editar',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () async {
                          if (formKey.currentState.validate()) {
                            (widget.addView)
                                ? (image != null)
                                    ? agregarEmpleado()
                                    : _showMyDialog(context)
                                : (image != null)
                                    ? editarEmpleado()
                                    : _showMyDialog(context);
                          }
                          formKey.currentState.save();
                        },
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                        ),
                        onPressed: () {
                          image = null;
                          refEmployee = null;
                          changeView(1);
                        },
                        child: Text('Cancelar'),
                      )
                    ],
                  )
                ],
              ),
            ],
          )),
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
