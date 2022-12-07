import 'package:app_contabilidad/models/carritoCompras.dart';
import 'package:app_contabilidad/pages/Payment.dart';
import 'home.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class Carrito extends StatefulWidget {
  final changeView;
  Carrito({this.changeView});
  @override
  _CarritoState createState() => _CarritoState();
}

class _CarritoState extends State<Carrito> {
  final imageWidget = "";
  int paymentView = 1;

  bool isEmpty() {
    bool isEmpty = true;
    localMisCarts.forEach((element) {
      element.cantidades.forEach((key, value) {
        print(value);
        if (value > 0) {
          isEmpty = false;
        }
      });
    });
    return isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildListProduct() {
      return ListView.builder(
        itemCount: localMisCarts.length,
        itemBuilder: (context, index) {
          List<Widget> variants = [];
          localMisCarts[index].cantidades.forEach((nombre, cantidad) {
            var precio = 0;
            localMisCarts[index].variantes.forEach((element) {
              if (element.nombreV == nombre) {
                precio = int.parse(element.valorV);
              }
            });
            if (cantidad > 0) {
              variants.add(Column(
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 16.0,
                                      top: 16.0,
                                      right: 8.0,
                                      bottom: 16.0),
                                  child: Image(
                                    image: localMisCarts[index].img != null
                                        ? NetworkImage(localMisCarts[index].img)
                                        : NetworkImage(
                                            'https://i.ibb.co/0Jmshvb/no-image.png'),
                                  ),
                                )),
                            Expanded(
                                flex: 3,
                                child: Column(children: <Widget>[
                                  Text(
                                    "${misCarts[index].nombre} $nombre \$$precio ",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(children: <Widget>[
                                        Text('Cantidad',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1),
                                        SizedBox(
                                          height: 18.0,
                                        ),
                                        Row(
                                          children: [
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                //padding: EdgeInsets.all(1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  localMisCarts[index]
                                                      .variantes
                                                      .forEach((element) {
                                                    if (element.nombreV ==
                                                        nombre) {
                                                      print(element);
                                                      print(element.valorV);
                                                      totalPriceP += int.parse(
                                                          element.valorV);
                                                      localMisCarts[index]
                                                          .cantidades[nombre]++;
                                                    }
                                                  });
                                                });
                                              },
                                              child: Icon(Icons.add,
                                                  size: 21.0,
                                                  color: Colors.black),
                                            ),
                                            Text("$cantidad",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5),
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                //padding: EdgeInsets.all(1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  //Resta cantidad al producto
                                                  localMisCarts[index]
                                                      .variantes
                                                      .forEach((element) {
                                                    if (element.nombreV ==
                                                        nombre) {
                                                      totalPriceP -= int.parse(
                                                          element.valorV);
                                                      localMisCarts[index]
                                                          .cantidades[nombre]--;
                                                    }
                                                  });
                                                });
                                              },
                                              child: Icon(Icons.remove,
                                                  size: 21.0,
                                                  color: Colors.black),
                                            )
                                          ],
                                        ),
                                      ]),
                                      Expanded(
                                          child: Column(
                                        children: [
                                          Text('Total',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1),
                                          SizedBox(
                                            height: 15.0,
                                          ),
                                          Text("\$${cantidad * precio}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1)
                                        ],
                                      )),
                                    ],
                                  )
                                ])), // Constructor del Card

                            IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () => this.setState(() {
                                      localMisCarts[index]
                                          .variantes
                                          .forEach((element) {
                                        if (element.nombreV == nombre) {
                                          totalPriceP -= cantidad *
                                              int.parse(element.valorV);
                                          precio = int.parse(element.valorV);
                                          localMisCarts[index]
                                              .cantidades[nombre] = 0;
                                        }
                                      });
                                    })),
                          ],
                        ),
                      )),
                ],
              ));
            }
          });
          print(variants);
          return Column(children: variants);
        },
      );
    }

    Widget _buildTotalPrice() {
      final totalPrice = Column(children: <Widget>[
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Precio Total',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text("\$$totalPriceP", style: Theme.of(context).textTheme.headline6)
          ],
        )
      ]);
      return totalPrice;
    }

    Widget _buildLoginBtn() {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        width: double.infinity,
        child: ElevatedButton(
          //elevation: 5.0,
          onPressed: () => {
            this.setState(() {
              paymentView = 2;
            }),

            /*  Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeView(selectedIndex: 4),
                ))*/
          },
          style: ElevatedButton.styleFrom(
            elevation: 5.0,
            padding: EdgeInsets.all(10.0),
            primary: Color(0xFFb39ddb),
          ),
          child: Text(
            'CONTINUAR',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      );
    }

    return (paymentView == 1)
        ? Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_left),
                onPressed: () {
                  misCarts = localMisCarts;
                  widget.changeView(1);
                },
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.shopping_cart),
                  Text(
                    'Mi Carrito',
                    style: appBarTextStyle,
                  ),
                ],
              ),
              elevation: 0.0,
              backgroundColor: appBarBackground,
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 05.0,
                ),
                Expanded(
                  child: (isEmpty())
                      ? Center(
                          child: Text("No hay nada en el carrito :c",
                              style: Theme.of(context).textTheme.headline6),
                        )
                      : _buildListProduct(),
                ),
                _buildTotalPrice(),
                _buildLoginBtn()
              ],
            ),
          )
        : PaymentUser(
            changeView: (int value) {
              this.setState(() {
                paymentView = value;
              });
            },
            goToOrder: widget.changeView,
          );
  }
}
