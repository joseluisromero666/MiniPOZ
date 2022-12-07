import 'package:app_contabilidad/Services/ProductoService.dart';
import 'package:app_contabilidad/models/productos.dart';
import 'package:flutter/material.dart';
import 'package:app_contabilidad/constants.dart';

// ignore: must_be_immutable
class AgregarVariante extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final changeView;
  final productName;
  AgregarVariante({this.changeView, this.productName});
  Variante tempVariant = Variante();
  @override
  Widget build(Object context) {
    return Form(
      key: formKey,
      child: Container(
        margin: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Peso de la variante...',
              ),
              validator: (peso) {
                if (peso.isEmpty) {
                  return 'La variante debe tener un peso.';
                }
                tempVariant.nombreV = peso;
                return null;
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Valor de la variante...',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'La variente debe tener un valor.';
                }
                try {
                  double.parse(value);
                  tempVariant.valorV = value;
                } catch (e) {
                  return 'El valor de la variante es inválido';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          ProductoService.addVarianToProduct(
                              productName, tempVariant);
                          changeView(1);
                        }
                      },
                      child: Text('Agregar Variante'),
                      style: ElevatedButton.styleFrom(primary: secundario)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: TextButton(
                      onPressed: () {
                        changeView(3);
                      },
                      child: Text('Cancelar'),
                      style: TextButton.styleFrom(primary: primario)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
