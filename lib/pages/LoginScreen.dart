import 'package:app_contabilidad/Services/AuthenticationService.dart';
import 'package:app_contabilidad/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({this.scaffold});

  final ScaffoldState scaffold;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _verificationId;
  bool _passwordObscured;
  bool _showEmailForm;

  @override
  void initState() {
    super.initState();
    _passwordObscured = true;
    _showEmailForm = true;
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (_showEmailForm) ? 'Correo Electrónico' : 'Número de teléfono',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60,
          child: TextFormField(
            controller:
                (_showEmailForm) ? emailController : _phoneNumberController,
            keyboardType: (_showEmailForm)
                ? TextInputType.emailAddress
                : TextInputType.phone,
            decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 0, height: 0),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                (_showEmailForm) ? Icons.email : Icons.phone,
                color: Colors.white,
              ),
              hintText:
                  (_showEmailForm) ? 'Ingrese su correo' : 'Ingrese su número',
              hintStyle: kHintTextStyle,
            ),
            validator: (value) {
              if (value.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: (_showEmailForm)
                        ? Text('Debe ingresar un correo')
                        : Text('Debe ingresar un número'),
                    duration: Duration(milliseconds: 1500),
                    width: 280,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                );
                return "";
              }
              return null;
            },
          ),
        )
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (_showEmailForm) ? 'Contraseña' : 'Código de verificación',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60,
          child: TextFormField(
            controller: (_showEmailForm) ? passwordController : _smsController,
            keyboardType: (_showEmailForm)
                ? TextInputType.visiblePassword
                : TextInputType.number,
            decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 0, height: 0),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: (_showEmailForm)
                  ? 'Ingrese su contraseña'
                  : 'Ingrese su código',
              hintStyle: kHintTextStyle,
            ),
            validator: (value) {
              if (value.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: (_showEmailForm)
                        ? Text('Debe ingresar una contraseña')
                        : Text('Debe ingresar un código de verificación'),
                    duration: Duration(milliseconds: 1500),
                    width: 280,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                );
                return "";
              }
              return null;
            },
            obscureText: !_passwordObscured,
          ),
        )
      ],
    );
  }

  Widget _buildPasswordObscuredCheckbox() {
    return Container(
      height: 20,
      child: Row(
        children: [
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.black12),
            child: Checkbox(
              value: _passwordObscured,
              checkColor: secundarioDark,
              activeColor: secundarioLight,
              onChanged: (value) {
                setState(() {
                  _passwordObscured = value;
                });
              },
            ),
          ),
          Text('Mostrar contraseña'),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            signIn(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 5,
          padding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          primary: Color(0xFFb39ddb),
        ),
        child: Text(
          'ACCEDER',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.2,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
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

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => signInWithGitHub(),
            AssetImage(
              'assets/github.png',
            ),
          ),
          _buildSocialBtn(
            () => signInWithGoogle(),
            AssetImage(
              'assets/google-logo.png',
            ),
          ),
          _buildSocialBtn(
            () => {
              setState(() {
                _showEmailForm = !_showEmailForm;
              })
            },
            AssetImage(
              (_showEmailForm) ? 'assets/phone.png' : 'assets/mail.png',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 120,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'OpenSans',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          (_showEmailForm)
                              ? Column(
                                  children: [
                                    _buildEmailTF(),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    _buildPasswordTF(),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    _buildPasswordObscuredCheckbox(),
                                    _buildLoginBtn(),
                                  ],
                                )
                              : Column(
                                  children: [
                                    _buildEmailTF(),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 25),
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () => _verifyPhoneNumber(),
                                        style: ElevatedButton.styleFrom(
                                          elevation: 5,
                                          padding: EdgeInsets.all(15),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          primary: Color(0xFFb39ddb),
                                        ),
                                        child: Text(
                                          'Verificar número',
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'OpenSans',
                                          ),
                                        ),
                                      ),
                                    ),
                                    _buildPasswordTF(),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 25),
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            _signInWithPhoneNumber(),
                                        style: ElevatedButton.styleFrom(
                                          elevation: 5,
                                          padding: EdgeInsets.all(15),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          primary: Color(0xFFb39ddb),
                                        ),
                                        child: Text(
                                          'Iniciar sesión',
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'OpenSans',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          Text(
                            '- O -',
                            style: TextStyle(color: Colors.black54),
                          ),
                          _buildSocialBtnRow(),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SIGN IN WITH EMAIL AND PASSWORD
  Future<void> signIn({String email, String password}) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      userId = credential.user.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'El correo electronico es incorrecto, intentelo de nuevo.'),
            duration: Duration(milliseconds: 1500),
            width: 280,
            padding: EdgeInsets.symmetric(horizontal: 20),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      }
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('El usuario no ha sido encontrado, intentelo de nuevo.'),
            duration: Duration(milliseconds: 1500),
            width: 280,
            padding: EdgeInsets.symmetric(horizontal: 20),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      }
      if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('La contraseña es incorrecta, intentelo de nuevo.'),
            duration: Duration(milliseconds: 1500),
            width: 280,
            padding: EdgeInsets.symmetric(horizontal: 20),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      }
    }
  }

  // GITHUB AUTH

  Future<void> signInWithGitHub() async {
    try {
      UserCredential userCredential;

      final GitHubSignIn gitHubSignIn = GitHubSignIn(
          clientId: "1cd97913bebffc5d6b69",
          clientSecret: "c4fe89980633dd2f5d928a857f258f98aa298bd4",
          redirectUrl:
              "https://pos-flutter-26725.firebaseapp.com/__/auth/handler");
      final result = await gitHubSignIn.signIn(context);

      final githubAuthCredential = GithubAuthProvider.credential(result.token);

      userCredential = await FirebaseAuth.instance
          .signInWithCredential(githubAuthCredential);
      final user = userCredential.user;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.email} ha iniciado sesión con Google.'),
          duration: Duration(milliseconds: 1500),
          width: 280,
          padding: EdgeInsets.symmetric(horizontal: 20),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  // GOOGLE AUTH

  Future<void> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
        await _auth.signInWithPopup(googleAuthProvider);
      } else {
        final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final GoogleAuthCredential googleAuthCredential =
            GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }

      final user = userCredential.user;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.email} ha iniciado sesión con Google.'),
          duration: Duration(milliseconds: 1500),
          width: 280,
          padding: EdgeInsets.symmetric(horizontal: 20),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    return null;
  }

  // PHONE NUMBER AUTHENTICATION

  Future<void> _verifyPhoneNumber() async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
    };

    PhoneVerificationFailed verificationFailed = (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('El número no es valido, intentelo de nuevo'),
            duration: Duration(milliseconds: 1500),
            width: 280,
            padding: EdgeInsets.symmetric(horizontal: 20),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      }
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumberController.text,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: Duration(milliseconds: 1500),
          width: 280,
          padding: EdgeInsets.symmetric(horizontal: 20),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    }
  }

  Future<void> _signInWithPhoneNumber() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _smsController.text);
    await _auth.signInWithCredential(credential);
  }
}
