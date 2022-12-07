import 'package:app_contabilidad/constants.dart';
import 'package:app_contabilidad/pages/item_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'carrito.dart';

class TomarOrden extends StatefulWidget {
  TomarOrden({Key key}) : super(key: key);

  @override
  _TomarOrdenState createState() => _TomarOrdenState();
}

class _TomarOrdenState extends State<TomarOrden> {
  final collectionSnp = FirebaseFirestore.instance.collection('products').get();
  var currentView = 1;

  changeView(int view) {
    this.setState(() {
      currentView = view;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentView == 1)
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Orden',
            style: appBarTextStyle,
          ),
          backgroundColor: secundarioLight,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: FutureBuilder(
              future: collectionSnp,
              builder: (context, snapshot) => snapshot.hasData
                  ? (snapshot.data.docs.length != 0
                      ? GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20.0,
                            crossAxisSpacing: 20.0,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) => ItemCard(
                            product: snapshot.data.docs[index],
                          ),
                        )
                      : Text('No existen productos en la Base de Datos'))
                  : Center(
                      child: CircularProgressIndicator(),
                    )),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_shopping_cart),
          backgroundColor: secundarioLight,
          onPressed: () => {
            this.setState(() {
              currentView = 2;
            })
          },
        ),
      );
    else
      return Carrito(
        changeView: changeView,
      );
  }
}
