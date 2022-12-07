import 'package:app_contabilidad/pages/agregarEtiqueta.dart';
import 'package:app_contabilidad/pages/agregarVariante.dart';
import 'package:app_contabilidad/pages/listaEtiquetas.dart';
import 'package:app_contabilidad/pages/listaProductos.dart';
import 'package:app_contabilidad/main.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'agregarProducto.dart';
import 'mostrarVariantes.dart';

class ProductosPage extends StatefulWidget {
  @override
  State<ProductosPage> createState() {
    return new ProductosState();
  }
}

class ProductosState extends State<ProductosPage> {
  int viewProducts = 1;
  int viewTags = 1;
  int addView = 1;
  String filter = "";
  final formKey = GlobalKey<FormState>();
  var productVariants;
  changeViewProducts(index) {
    this.setState(() {
      viewProducts = index;
    });
  }

  changeViewTags(index) {
    this.setState(() {
      viewTags = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: viewProducts == 3
              ? IconButton(
                  onPressed: () {
                    changeViewProducts(1);
                  },
                  icon: Icon(Icons.arrow_back))
              : null,
          backgroundColor: secundarioLight,
          bottom: TabBar(
            onTap: (index) => this.setState(() {
              addView = index + 1;
            }),
            tabs: [
              Tab(icon: Icon(Icons.toc)),
              Tab(
                icon: Icon(Icons.tag),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            if (viewProducts == 1)
              ListaProductos(
                changeView: (int a, dynamic b) {
                  this.setState(() {
                    viewProducts = a;
                    productVariants = b;
                  });
                },
                filter: filter,
                changeFilter: (String fil) {
                  this.setState(() {
                    filter = fil;
                  });
                },
              )
            else if (viewProducts == 2)
              AgregarProducto(changeView: changeViewProducts)
            else if (viewProducts == 3)
              MostrarVariantes(
                  productVariants: productVariants,
                  changeView: changeViewProducts)
            else
              AgregarVariante(
                  changeView: changeViewProducts,
                  productName: productVariants.get('name')),
            viewTags == 2
                ? AgregarEtiqueta(changeView: changeViewTags)
                : ListaEtiquetas()
          ],
        ),
        floatingActionButton: (role == 'administrador')
            ? (viewProducts == 4 || viewProducts == 2)
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      if (addView == 1) {
                        if (viewProducts == 3)
                          changeViewProducts(4);
                        else
                          changeViewProducts(2);
                      } else {
                        changeViewTags(2);
                      }
                    },
                    child: Icon(Icons.add),
                    backgroundColor: secundarioLight,
                  )
            : null,
      ),
      initialIndex: 0,
    );
  }
}
