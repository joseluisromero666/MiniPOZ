import 'package:flutter/cupertino.dart';

class ProductosModel {
  String urlImagen;
  String nombre;
  String valor;
  List<Variante> variantes;
  String tipoImpuesto;
  Etiqueta etiqueta;
  String token;

  Map<String, dynamic> toMap() {
    return {
      'url': urlImagen,
      'name': nombre,
      'tagName':
          (etiqueta != null) ? etiqueta.nombreEtiqueta.toLowerCase() : "",
      'lowerName': nombre.toLowerCase(),
      'value': valor,
      'tax': tipoImpuesto,
      'tag': etiqueta != null
          ? [etiqueta.color.toString(), etiqueta.nombreEtiqueta]
          : null,
      'variants': [],
      'token': token
    };
  }

  ProductosModel(
      {this.urlImagen,
      this.nombre,
      this.valor,
      this.variantes,
      this.tipoImpuesto,
      this.etiqueta,
      this.token});
}

class Variante {
  String nombreV;
  String valorV;
  Variante({this.nombreV, this.valorV});
}

class Etiqueta {
  String nombreEtiqueta;
  String color;
  Etiqueta({this.nombreEtiqueta, this.color});

  Map<String, dynamic> toMap() {
    return {
      'name': nombreEtiqueta,
      'lowerName': nombreEtiqueta.toLowerCase(),
      'color': color,
    };
  }

  bool isEmpty() {
    if (this.nombreEtiqueta == null && this.color == null) return true;
    return false;
  }

  @override
  String toString() {
    return nombreEtiqueta + ' - ' + color;
  }
}

Color getColorFromHex(String hexColor) {
  if (hexColor.isEmpty) return null;
  Color hex;
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  if (hexColor.length == 8) {
    hex = Color(int.parse("0x$hexColor"));
  }
  return hex;
}
