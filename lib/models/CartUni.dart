
class CartUni {
  String nombre;
  String img;
  int precio;
  int cantidad;

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'img': img,
      'precio': precio,
      'cantidad': cantidad,
    };
  }

  CartUni({this.nombre, this.img, this.precio, this.cantidad});
}
