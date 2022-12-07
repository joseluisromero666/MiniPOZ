import 'package:app_contabilidad/models/employees.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationState extends ChangeNotifier {
  final String uid;
  ApplicationState({this.uid});

  static CollectionReference employeesCollection =
      FirebaseFirestore.instance.collection('employees');

  static Future<void> addEmployee(EmployeeModel employee) {
    return employeesCollection.add(employee.toMap());
  }

  static Future<void> editEmployee(EmployeeModel employee) {
    return employeesCollection
        .where('document', isEqualTo: employee.documento)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update(
          {
            'name': employee.nombre,
            'urlImg': employee.foto,
            'document': employee.documento,
            'email': employee.correo,
          },
        );
      });
    }).catchError((err) => print("Failed to update employee: $err"));
  }

  static Future<void> deleteEmployee(String documento) {
    return employeesCollection
        .where('document', isEqualTo: documento)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    }).catchError((err) => print("Failed to delete employee: $err"));
  }
}
