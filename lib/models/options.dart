import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OptionsModel {
  String title;
  Icon icono;
  OptionsModel({this.title, this.icono});
}

List<OptionsModel> options = [
  new OptionsModel(title: 'Tomar orden', icono: Icon(Icons.touch_app)),
  new OptionsModel(title: 'Buscar producto', icono: Icon(Icons.image_search)),
  //new OptionsModel(title: '', icono: Icon(Icons.plus_one))
];
