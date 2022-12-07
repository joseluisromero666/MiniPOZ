import 'package:app_contabilidad/models/productos.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductoService extends ChangeNotifier {
  static Future<DocumentReference> addNewProduct(ProductosModel pr) {
    return FirebaseFirestore.instance.collection('products').add(pr.toMap());
  }

  static Future<DocumentReference> removeTagFromProducts(String tagName) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('tag', arrayContains: tagName)
        .get()
        // ignore: missing_return
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({'tag': null});
      });
    });
  }

  static Future<DocumentReference> editTagFromProducts(
      String oldTagName, Etiqueta newTag) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('tag', arrayContains: oldTagName)
        .get()
        // ignore: missing_return
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({
          'tag': [newTag.color, newTag.nombreEtiqueta]
        });
      });
    });
  }

  static Future<DocumentReference> addVarianToProduct(
      String productName, Variante variant) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('name', isEqualTo: productName)
        .get()
        // ignore: missing_return
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({
          'variants': [
            ...doc.get('variants'),
            {'name': variant.nombreV, 'value': variant.valorV}
          ]
        });
      });
    });
  }
}
