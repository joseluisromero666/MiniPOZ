import 'dart:convert';

import 'package:app_contabilidad/Services/ComprasHechasService.dart';
import 'package:app_contabilidad/models/carritoCompras.dart';
import 'package:app_contabilidad/pages/home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_contabilidad/constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import '../Services/message.dart';

class PaymentUser extends StatefulWidget {
  var changeView;
  var goToOrder;
  PaymentUser({this.changeView, this.goToOrder});
  @override
  _PaymentState createState() => _PaymentState();
}

final usuario = TextEditingController();
final cedula = TextEditingController();
final celular = TextEditingController();
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

class _PaymentState extends State<PaymentUser> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Widget _buildName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Nombre',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: usuario,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Ingrese su Nombre ',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCedula() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Cedula',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: cedula,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.closed_caption_rounded,
                color: Colors.white,
              ),
              hintText: 'Ingrese su Número de Cédula',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildnumCel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Celular',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: celular,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.white,
              ),
              hintText: 'Ingrese su Número de Celular',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _mediosDePagoText() {
    return Text(
      'Medios de pago',
      style: TextStyle(
        color: Colors.black54,
        fontFamily: 'OpenSans',
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSocialBtn(String pagof, AssetImage logo) {
    return GestureDetector(
      onTap: () => {pago = pagof},
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.transparent,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _mediosDePago() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildSocialBtn(
                  'Pse',
                  AssetImage(
                    'assets/pse.png',
                  )),
              _buildSocialBtn(
                'Nequi',
                AssetImage(
                  'assets/nequi.png',
                ),
              ),
              _buildSocialBtn(
                'Visa',
                AssetImage(
                  'assets/visa.png',
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialBtn(
                'Master Cart',
                AssetImage(
                  'assets/master.png',
                ),
              ),
              _buildSocialBtn(
                'Efectivo',
                AssetImage(
                  'assets/efectivo.png',
                ),
              ),
              _buildSocialBtn(
                'Baloto',
                AssetImage(
                  'assets/Baloto.png',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCupertinoAlertDialog() {
    return CupertinoAlertDialog(
      title: Text('Error'),
      content: Text("Por favor rellene todos los campos :)"),
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
    return showCupertinoDialog(
      context: context,
      builder: (_) => _buildCupertinoAlertDialog(),
    );
  }

  String p;
  void getToken() async {
    await messaging.getToken().then((String result) => p = result.toString());
    print(p);
    token = p;
    mycarritoCompras.token = token;
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

  Widget _buildBoton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        //elevation: 5.0,
        onPressed: () => {
          if (usuario.text == "" ||
              cedula.text == "" ||
              celular.text == "" ||
              pago == "")
            {_showMyDialog(context)}
          else
            {
              getToken(),
              sendPushMessage(),
              ingProdHechas(),
              misCarts = localMisCarts,
              widget.goToOrder(1),

              /*
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeView(selectedIndex: 0),
                  )),*/
            }
        },
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          primary: Color(0xFFb39ddb),
        ),
        child: Text(
          'CONTINUAR',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  void ingProdHechas() {
    for (var index = 0; index < localMisCarts.length; index++) {
      localMisCarts[index].cantidades.forEach((nombre, cantidad) {
        var precio = 0;
        localMisCarts[index].variantes.forEach((element) {
          if (element.nombreV == nombre) {
            precio = int.parse(element.valorV);
          }
        });
        if (cantidad > 0) {
          newCartUni.nombre = "${misCarts[index].nombre} $nombre \$$precio";
          newCartUni.cantidad = cantidad;
          newCartUni.precio = precio;
          newCartUni.img = localMisCarts[index].img;
          misMaps.add(newCartUni.toMap());
        }
      });
    }
    getToken();
    mycarritoCompras.nombre = usuario.text;
    mycarritoCompras.cedula = cedula.text;
    mycarritoCompras.celular = celular.text;
    mycarritoCompras.medioPago = pago;
    mycarritoCompras.listcart = misMaps;
    mycarritoCompras.valorTotal = totalPriceP;
    ApplicationStateL.addNewCart(mycarritoCompras);
    localMisCarts = [];
    misCarts = [];
    totalPriceP = 0;
    misMaps = [];
    usuario.text = "";
    cedula.text = "";
    celular.text = "";
    pago = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: appBarBackground,
          leading: IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              widget.changeView(1);
            },
          )),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Confirmar Pago',
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildName(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildCedula(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildnumCel(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _mediosDePagoText(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _mediosDePago(),
                      _buildBoton(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
