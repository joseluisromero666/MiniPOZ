import 'package:app_contabilidad/models/Cart.dart';
import 'package:app_contabilidad/models/carritoCompras.dart';
import 'package:app_contabilidad/models/productos.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatefulWidget {
  final QueryDocumentSnapshot product;
  // final Function press;
  ItemCard({
    Key key,
    this.product,
    // this.press,
  }) : super(key: key);
  @override
  _ItemCardState createState() => _ItemCardState();
}



class _ItemCardState extends State<ItemCard> {
  CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');

  Cart thisCart = Cart(cantidad: 0, precio: 0, cantidades: {}, variantes: []);
  String productName = '';
  String productValue = '';

  var nm;
  @override
  void initState() {
    bool add = false;
    super.initState();
    totalPriceP += thisCart.precio;
    productName = widget.product.get('name').toString();
    productValue = widget.product.get('variants')[0]['value'];
    nm = widget.product.get('variants')[0]['name'];

    for (var i = 0; i < misCarts.length; i++) {
      if (misCarts[i].nombre == widget.product.get('name')) {
        add = true;
        thisCart = misCarts[i];
        productValue = misCarts[i].precio.toString();
      }
    }
    if (add == false) {
      thisCart.nombre = productName;
      thisCart.img = widget.product.get('url');
      thisCart.precio = int.parse(productValue);
      widget.product.get('variants').forEach((variante) {
        thisCart.cantidades.addAll({variante['name'].toString(): 0});
        thisCart.variantes.add(Variante(
            nombreV: variante['name'].toString(),
            valorV: variante['value'].toString()));
      });
      misCarts.add(thisCart);
      print(thisCart.cantidades);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()  {
        setState(() {
          thisCart.cantidades[nm]++;
          totalPriceP += int.parse(productValue);
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          PopupMenuButton<dynamic>(
            child: Icon(Icons.more_horiz),
            itemBuilder: (context) {
              return widget.product.get('variants').map<PopupMenuItem>((index) {
                return PopupMenuItem<dynamic>(
                  child: Text(index['name'].toString() +
                      " " +
                      index['value'].toString()),
                  value: {'val': index['value'], 'name': index['name']},
                );
              }).toList();
            },
            onSelected: (value) {
              setState(() {
                nm = value['name'];
                productValue = value['val'];
              });
            },
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: GestureDetector(
                onLongPress: () {
                  print("onLongPress");
                },
                child: Image(
                  image: widget.product.get('url') != null
                      ? NetworkImage(widget.product.get('url'))
                      : NetworkImage('https://i.ibb.co/0Jmshvb/no-image.png'),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0 / 4),
            child: Center(
              child: AutoSizeText(
                productName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                maxLines: 2,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AutoSizeText(
                productValue.toString(),
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              AutoSizeText(
                thisCart.cantidades[nm].toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  //padding: EdgeInsets.all(1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    if (thisCart.cantidades[nm] > 0) {
                      thisCart.cantidades[nm]--;
                      totalPriceP -= int.parse(productValue);
                    }
                  });
                },
                child: Icon(
                  Icons.remove,
                  color: Colors.purple,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
