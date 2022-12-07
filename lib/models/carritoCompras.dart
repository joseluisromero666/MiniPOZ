import 'dart:io';

import 'package:app_contabilidad/models/Cart.dart';
import 'package:app_contabilidad/models/CartUni.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CarritoCompras {
  String token;
  String nombre;
  String cedula;
  String celular;
  String medioPago;
  List<Map> listcart;
  int valorTotal;

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'nombre': nombre,
      'cedula': cedula,
      'celular': celular,
      'medioPago': medioPago,
      'listcart': listcart,
      'valorTotal': valorTotal,
    };
  }

  CarritoCompras(
      {this.token,
      this.nombre,
      this.cedula,
      this.celular,
      this.medioPago,
      this.listcart,
      this.valorTotal});
}

List<Map> misMaps = [];
List<Cart> misCarts = [];
int totalPriceP = 0;
CarritoCompras mycarritoCompras = CarritoCompras();
List<Cart> localMisCarts = misCarts;
String pago = "";
String token;
File image;
Reference refEmployee;
Reference refProduct;
String uuid;
List<CartUni> misCartsUni = [];
CartUni newCartUni = CartUni();
