import 'package:app_contabilidad/Services/AuthenticationService.dart';
import 'package:app_contabilidad/constants.dart';
import 'package:app_contabilidad/models/commerce.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommerceProfilePage extends StatefulWidget {
  @override
  _CommerceProfilePageState createState() => _CommerceProfilePageState();
}

class _CommerceProfilePageState extends State<CommerceProfilePage> {
  final FirebaseAuth auth;

  _CommerceProfilePageState({this.auth});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secundarioLight,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.attachment_sharp),
            onPressed: () async {
              final GoogleSignInAccount googleUser =
                  await GoogleSignIn().signIn();
              final GoogleSignInAuthentication googleAuth =
                  await googleUser.authentication;
              final GoogleAuthCredential googlecredential =
                  GoogleAuthProvider.credential(
                      accessToken: googleAuth.accessToken,
                      idToken: googleAuth.idToken);
              final UserCredential googleUserCredential = await FirebaseAuth
                  .instance
                  .signInWithCredential(googlecredential);
              googleUserCredential.user
                  .linkWithPhoneNumber(auth.currentUser.phoneNumber);
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 30),
                    color: Color(0xFFe6ceff),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Hero(
                            tag: 1,
                            child: Image.network(
                              shops[0].logo,
                              width: size.width * 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 75,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(shops[0].logo),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shops[0].nombre,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    shops[0].paginaWeb,
                                  )
                                ],
                              ),
                              Expanded(child: Container()),
                              Text('Commerce')
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            shops[0].descripcion,
                            style: TextStyle(height: 1.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 120,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        shops[0].nombre,
                        style: TextStyle(
                          color: Color(0xFF836fa9),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        shops[0].sucursales[0].ubicacion.ciudad,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        size: 18,
                        color: Color(0xFFb39ddb),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        shops[0].sucursales[0].ubicacion.direccion,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF90a4ae),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListView.builder(
                itemCount: shops[0].sucursales.length,
                itemBuilder: (BuildContext context, int index) => Column(
                  children: [
                    Divider(
                      height: 8,
                    ),
                    ListTile(
                      title: Text(
                        shops[0].sucursales[index].nombre,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(shops[0].sucursales[index].ubicacion.direccion),
                          Text(shops[0].sucursales[index].telefono)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
