import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/productos.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

// ignore: must_be_immutable
class ListaProductos extends StatefulWidget {
  ListaProductos({this.changeView, this.filter, this.changeFilter});
  var changeView;
  var changeFilter;
  String filter;
  @override
  State<StatefulWidget> createState() {
    return ListaProductosState();
  }
}

class ListaProductosState extends State<ListaProductos> {
  Stream collectionSnp(filter) {
    var coll = FirebaseFirestore.instance
        .collection('products')
        .orderBy('tagName')
        .startAt([filter.toLowerCase()]).endAt(
            [filter.toLowerCase() + '\uf8ff']).snapshots();
    return coll;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        TextFormField(
          initialValue: widget.filter,
          onChanged: (value) {
            widget.changeFilter(value);
          },
          decoration: InputDecoration(
            hintText: "Buscar por etiqueta",
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
        ),
        Expanded(
            child: StreamBuilder(
                stream: collectionSnp(widget.filter),
                builder: (context, snapshot) => snapshot.hasData
                    ? (snapshot.data.docs.length != 0
                        ? ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                  onTap: () {
                                    widget.changeView(
                                        3, snapshot.data.docs[index]);
                                  },
                                  child: Column(
                                    children: [
                                      Divider(
                                        height: 8,
                                      ),
                                      ListTile(
                                        title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data.docs[index]
                                                    .get('name'),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    snapshot.data.docs[index]
                                                        .get('tax'),
                                                  ),
                                                ],
                                              )
                                            ]),
                                        leading: Image(
                                            image: snapshot.data.docs[index]
                                                        .get('url') !=
                                                    null
                                                ? NetworkImage(snapshot
                                                    .data.docs[index]
                                                    .get('url'))
                                                : NetworkImage(
                                                    'https://i.ibb.co/0Jmshvb/no-image.png')),
                                        subtitle: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('\$' +
                                                snapshot.data.docs[index]
                                                    .get('value')),
                                            snapshot.data.docs[index]
                                                        .get('tag') !=
                                                    null
                                                ? Text(
                                                    '#' +
                                                        (snapshot
                                                            .data.docs[index]
                                                            .get('tag')[1]),
                                                    style: TextStyle(
                                                      color: (snapshot.data
                                                                      .docs[index]
                                                                      .get(
                                                                          'tag')[
                                                                  0] !=
                                                              null
                                                          ? getColorFromHex(
                                                              snapshot.data
                                                                  .docs[index]
                                                                  .get(
                                                                      'tag')[0])
                                                          : Colors.redAccent),
                                                    ))
                                                : Text('')
                                          ],
                                        ),
                                      ),
                                    ],
                                  ));
                            })
                        : Text('No existen productos en la Base de Datos'))
                    : Text('Cargando...')))
      ]),
    );
  }
}
