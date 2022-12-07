//import 'package:app_contabilidad/constants.dart';
import 'package:app_contabilidad/pages/Payment.dart';
import 'package:app_contabilidad/pages/carrito.dart';
import 'package:app_contabilidad/pages/commerceProfile.dart';
import 'package:app_contabilidad/pages/employees.dart';
import 'package:app_contabilidad/pages/productos.dart';
import 'package:app_contabilidad/pages/tomar_orden.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// ignore: must_be_immutable
class HomeView extends StatefulWidget {
  HomeView({this.selectedIndex});
  var selectedIndex;
  @override
  _HomeViewState createState() => _HomeViewState(selectedIndex: selectedIndex);
}

class _HomeViewState extends State<HomeView> {
  _HomeViewState({this.selectedIndex});
  var selectedIndex;

  List<Widget> _widgetOptions = <Widget>[
    TomarOrden(),
    ProductosPage(),
    EmployeesPage(),
    CommerceProfilePage(),
    PaymentUser(),
    Carrito()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 20,
      //   title: Text('Home'),
      // ),
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.white, // Background color of bottomnavbar
            boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
            ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                rippleColor: Theme.of(context).primaryColor,
                hoverColor: Theme.of(context).backgroundColor,
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Theme.of(context).accentColor,
                tabs: [
                  GButton(
                    icon: Icons.queue_play_next_rounded,
                    text: 'Orden',
                  ),
                  GButton(
                    icon: Icons.add_business,
                    text: 'Productos',
                  ),
                  GButton(
                    icon: Icons.person_pin,
                    text: 'Empleados',
                  ),
                  GButton(
                    icon: Icons.contact_support_outlined,
                    text: 'Contacto',
                  ),
                ],
                selectedIndex: selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    selectedIndex = index;
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
