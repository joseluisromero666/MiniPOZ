import 'productos.dart';

class Cart {
  String nombre;
  String img;
  int precio;
  int cantidad;
  Map<String, int> cantidades;
  List<Variante> variantes;

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'img': img,
      'precio': precio,
      'cantidad': cantidad,
      'cantidades':cantidades,
      'variantes':variantes,
    };
  }

  Cart({this.nombre, this.img, this.precio, this.cantidad,this.cantidades,this.variantes});
}

String valorini;