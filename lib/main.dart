import 'package:app_contabilidad/constants.dart';
import 'package:app_contabilidad/pages/LoginScreen.dart';
import 'package:app_contabilidad/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app_contabilidad/Services/AuthenticationService.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          initialData: null,
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        ),
      ],
      child: MaterialApp(
        title: 'POS',
        theme: ThemeData(
          primaryColor: primario,
          primaryColorLight: primarioLight,
          primaryColorDark: primarioDark,
          accentColor: secundario,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('You have an error! ${snapshot.error.toString()}');
                return Text('Something went wrong!');
              } else if (snapshot.hasData) {
                return AuthenticationWrapper();
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeView(
      selectedIndex: 0,
    );
    final firebaseuser = context.watch<User>();
    if (firebaseuser != null) {
      FirebaseFirestore.instance
          .collection("employees")
          .doc(firebaseuser.uid)
          .get()
          .then((value) => role = value['role'])
          .catchError((err) => print(err));
      return HomeView(
        selectedIndex: 0,
      );
    }
    return LoginScreen();
  }
}

String role;
