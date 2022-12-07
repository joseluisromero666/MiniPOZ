import 'package:app_contabilidad/models/productos.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ProductoService.dart';

class EtiquetaService extends ChangeNotifier {
  static Future<DocumentReference> addNewTag(Etiqueta tag) {
    return FirebaseFirestore.instance.collection('tags').add(tag.toMap());
  }

  static Future<DocumentReference> removeTag(String tagName) {
    return FirebaseFirestore.instance
        .collection('tags')
        .where('name', isEqualTo: tagName)
        .get()
        // ignore: missing_return
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

  static Future<DocumentReference> ediTag(String oldname, Etiqueta tag) {
    return FirebaseFirestore.instance
        .collection('tags')
        .where('name', isEqualTo: oldname)
        .get()
        // ignore: missing_return
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({
          'name': tag.nombreEtiqueta,
          'color': tag.color,
          'lowerName': tag.nombreEtiqueta.toLowerCase()
        });
        ProductoService.editTagFromProducts(oldname, tag);
      });
    });
  }
}
