import 'package:app_contabilidad/Services/EmployeeService.dart';
import 'package:app_contabilidad/constants.dart';
import 'package:app_contabilidad/pages/addEmployee.dart';
import 'package:app_contabilidad/pages/viewEmployee.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_contabilidad/main.dart';

class EmployeesPage extends StatefulWidget {
  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  var employeesCollection =
      FirebaseFirestore.instance.collection('employees').snapshots();
  int employeesView = 1;
  var currentEmployee;
  changeView(view) {
    this.setState(() {
      employeesView = view;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: employeesView == 1
            ? Padding(
                padding: EdgeInsets.only(),
                child: StreamBuilder(
                  stream: employeesCollection,
                  builder: (context, snapshot) => snapshot.hasData
                      ? (snapshot.data.docs.length != 0
                          ? ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      snapshot.data.docs[index].get('name'),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(snapshot
                                          .data.docs[index]
                                          .get('urlImg')),
                                    ),
                                    subtitle: Text(
                                      snapshot.data.docs[index].get('email'),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    trailing: _selectOption(
                                        index, snapshot.data.docs[index]),
                                  ),
                                ],
                              ),
                            )
                          : Text('There is no employees'))
                      : CircularProgressIndicator(),
                ),
              )
            : (employeesView == 2
                ? AddEmployee(addView: true, changeView: changeView)
                : (employeesView == 3
                    ? ViewEmployee(
                        index: currentEmployee, changeView: changeView)
                    : AddEmployee(
                        addView: false,
                        changeView: changeView,
                        index: currentEmployee))),
        floatingActionButton:
            employeesView == 2 || employeesView == 3 || employeesView == 4
                ? null
                : (role == 'administrador')
                    ? FloatingActionButton(
                        onPressed: () {
                          this.setState(() {
                            employeesView = 2;
                          });
                        },
                        child: Icon(Icons.add),
                        backgroundColor: secundarioLight,
                      )
                    : null);
  }

  Widget _selectOption(int index, employee) => PopupMenuButton<int>(
        itemBuilder: (context) => (role == 'administrador')
            ? [
                PopupMenuItem(
                  value: 0,
                  child: Text('View'),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text('Edit'),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text('Delete'),
                ),
              ]
            : [
                PopupMenuItem(
                  value: 0,
                  child: Text('View'),
                ),
              ],
        icon: Icon(Icons.more_vert),
        onSelected: (value) {
          if (value == 0) {
            currentEmployee = index;
            changeView(3);
          } else if (value == 1) {
            currentEmployee = index;
            changeView(4);
          } else if (value == 2) {
            _alertDelete(employee);
          }
        },
      );

  Future<void> _alertDelete(employee) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Elimiar empleado'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(employee.get('name') + ' será eliminad@.'),
                  Text('Seguro de que desea hacerlo?'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  ApplicationState.deleteEmployee(employee.get('document'));
                  Navigator.of(context).pop();
                },
                child: Text('Acepto'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
            ],
          );
        });
  }
}
