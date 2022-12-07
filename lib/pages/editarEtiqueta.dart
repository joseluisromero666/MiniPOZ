import 'package:app_contabilidad/Services/EtiquetaService.dart';
import 'package:app_contabilidad/models/productos.dart';
import 'package:flutter/material.dart';
import 'package:app_contabilidad/constants.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// ignore: must_be_immutable
class EditarEtiqueta extends StatefulWidget {
  final changeTagView;
  final oldTagName;
  final oldTagColor;
  EditarEtiqueta({this.changeTagView, this.oldTagName, this.oldTagColor});

  @override
  _EditarEtiquetaState createState() => _EditarEtiquetaState();
}
class _EditarEtiquetaState extends State<EditarEtiqueta> {
  Etiqueta temEtiqueta = Etiqueta();

  final formKey = GlobalKey<FormState>();
  Color currentColor = Colors.blueAccent;
  void changeColor(Color color) => setState(() => currentColor = color);

  @override
  Widget build(Object context) {
    List<Widget> misWidget = [
       TextFormField(
            decoration: InputDecoration(
                hintText: 'Nombre de la etiqueta...',
                border: OutlineInputBorder()),
            initialValue: widget.oldTagName,
            validator: (nombre) {
              if (nombre.isEmpty) {
                return 'La etiqueta debe tener un nombre.';
              }
              temEtiqueta.nombreEtiqueta = nombre;
              return null;
            },
          ),
      //Seleccion de Colores
      SizedBox(
        height: 30,
      ),
      ColorPicker(
        pickerColor: currentColor,
        onColorChanged: changeColor,
        colorPickerWidth: 300.0,
        pickerAreaHeightPercent: 0.7,
        enableAlpha: true,
        displayThumbColor: true,
        showLabel: true,
        paletteType: PaletteType.hsv,
        pickerAreaBorderRadius: const BorderRadius.only(
          topLeft: const Radius.circular(2.0),
          topRight: const Radius.circular(2.0),
        ),
      ),
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (formKey.currentState.validate()) {
                          temEtiqueta.color = currentColor.value.toRadixString(16);
                        EtiquetaService.ediTag(widget.oldTagName, temEtiqueta);
                        widget.changeTagView(1);
                      }
                    },
                    child: Text('Editar Etiqueta'),
                    style: ElevatedButton.styleFrom(primary: secundario)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextButton(
                    onPressed: () {
                      widget.changeTagView(1);
                    },
                    child: Text('Cancelar'),
                    style: TextButton.styleFrom(primary: primario)),
              )
            ],
          ),
    ];
    Widget _buildListProduct() {
      final liprod = ListView.builder(
        itemCount: misWidget.length,
        itemBuilder: (BuildContext context, int index) => Column(
          children: [misWidget[index]],
        ),
      );
      return liprod;
    }

    return Scaffold(
        body: Container(
      margin: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 05.0,
          ),
          Expanded(
            child: Form(
              key: formKey,
              child: _buildListProduct(),
            ),
          ),
        ],
      ),
    ));
  }
}
