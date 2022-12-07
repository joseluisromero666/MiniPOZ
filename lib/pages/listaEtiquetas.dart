import 'package:app_contabilidad/Services/EtiquetaService.dart';
import 'package:app_contabilidad/Services/ProductoService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../models/productos.dart';
import 'package:app_contabilidad/constants.dart';

import 'editarEtiqueta.dart';

class ListaEtiquetas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaEtiquetasState();
  }
}

class ListaEtiquetasState extends State<ListaEtiquetas> {
  var tagView = 1;
  var oldTagName;
  var oldTagColor;
  String filter = "";

  Stream collectionSnp(filter) {
    var coll = FirebaseFirestore.instance
        .collection('tags')
        .orderBy('lowerName')
        .startAt([filter.toLowerCase()]).endAt(
            [filter.toLowerCase() + '\uf8ff']).snapshots();
    return coll;
  }

  changeTagView(int tagViewNumber) {
    this.setState(() {
      tagView = tagViewNumber;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          Container(
            height: 10,
          ),
          (tagView == 1)
              ? TextFormField(
                  initialValue: filter,
                  onChanged: (value) {
                    this.setState(() {
                      filter = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Buscar por nombre",
                    fillColor: Colors.white.withOpacity(0.7),
                    filled: true,
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(20 * 0.70),
                      child: Icon(
                        FeatherIcons.search,
                        color: Color(0xFFB4AEE8),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                )
              : Container(),
          Expanded(
            child: tagView == 1
                ? StreamBuilder(
                    stream: collectionSnp(filter),
                    builder: (context, snapshot) => snapshot.hasData
                        ? (snapshot.data.docs.length != 0
                            ? GridView.count(
                                scrollDirection: Axis.vertical,
                                primary: false,
                                crossAxisSpacing: 0.0,
                                mainAxisSpacing: 0.0,
                                crossAxisCount: 3,
                                childAspectRatio: 1,
                                children: List.generate(
                                  snapshot.data.docs.length,
                                  (index) => Card(
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 0, bottom: 0),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ListTile(
                                                    title: Text(
                                                        '#' +
                                                            snapshot.data
                                                                .docs[index]
                                                                .get('name'),
                                                        style: TextStyle(
                                                            color: getColorFromHex(
                                                                snapshot.data
                                                                    .docs[index]
                                                                    .get(
                                                                        'color'))))),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    IconButton(
                                                      icon: Icon(Icons.edit),
                                                      color: secundarioDark,
                                                      onPressed: () {
                                                        this.setState(() {
                                                          oldTagName = snapshot
                                                              .data.docs[index]
                                                              .get('name');
                                                          oldTagColor = snapshot
                                                              .data.docs[index]
                                                              .get('color');
                                                          tagView = 2;
                                                        });
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons.delete),
                                                      color: secundarioDark,
                                                      onPressed: () {
                                                        EtiquetaService
                                                            .removeTag(snapshot
                                                                .data
                                                                .docs[index]
                                                                .get('name'));
                                                        ProductoService
                                                            .removeTagFromProducts(
                                                                snapshot.data
                                                                    .docs[index]
                                                                    .get(
                                                                        'name'));
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ]))),
                                ),
                              )
                            : Text('No existen etiquetas en la Base de Datos'))
                        : Text('Cargando...'))
                : EditarEtiqueta(
                    changeTagView: changeTagView,
                    oldTagName: oldTagName,
                    oldTagColor: oldTagColor),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: secundarioLight,
          onPressed: () {
            changeTagView(2);
          }),
    );
  }
}
