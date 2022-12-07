import 'package:app_contabilidad/models/carritoCompras.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationStateL extends ChangeNotifier {
  static Future<DocumentReference> addNewCart(CarritoCompras cr) {
    return FirebaseFirestore.instance
        .collection('ComprasHechas')
        .add(cr.toMap());
  }
}
