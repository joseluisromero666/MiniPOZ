import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewEmployee extends StatelessWidget {
  final int index;
  final employeesCollection =
      FirebaseFirestore.instance.collection('employees').snapshots();
  final changeView;
  ViewEmployee({@required this.index, this.changeView});

  Widget textfield({@required String text}) {
    return Material(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: text,
          hintStyle: TextStyle(
            letterSpacing: 2,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          fillColor: Colors.white30,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: secundarioLight,
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              color: secundarioDark,
              onPressed: () {
                changeView(1);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(),
        child: StreamBuilder(
          stream: employeesCollection,
          builder: (context, snapshot) => snapshot.hasData
              ? (snapshot.data.docs.length != 0
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 300,
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  textfield(
                                      text: snapshot.data.docs[index]
                                          .get('email')),
                                  textfield(
                                      text: snapshot.data.docs[index]
                                          .get('role')),
                                  textfield(
                                      text: snapshot.data.docs[index]
                                          .get('phone')),
                                  textfield(
                                      text: snapshot.data.docs[index]
                                          .get('document')),
                                ],
                              ),
                            ),
                          ],
                        ),
                        CustomPaint(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                          ),
                          painter: HeaderCurvedContainer(),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                snapshot.data.docs[index].get('name'),
                                style: TextStyle(
                                    fontSize: 35,
                                    letterSpacing: 1.5,
                                    color: secundarioDark,
                                    fontWeight: FontWeight.w600,
                                    height: 0.9),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 5),
                                shape: BoxShape.circle,
                                color: Colors.white,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    snapshot.data.docs[index].get('urlImg'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Text('There is no employees'))
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = secundarioLight;
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
