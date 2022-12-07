import 'package:flutter/material.dart';

const TextStyle optionStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w600,
);

const TextStyle appBarTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.normal,
  color: Colors.black,
);

const Color appBarBackground = Color(0xFFFAFAFA);

//Primarios
const Color primario = Color(0xFF90a4ae);
const Color primarioLight = Color(0xFFc1d5e0);
const Color primarioDark = Color(0xFF62757f);

//Secundarios
const Color secundario = Color(0xFFb39ddb);
const Color secundarioLight = Color(0xFFe6ceff);
const Color secundarioDark = Color(0xFF836fa9);

final kHintTextStyle = TextStyle(
  color: Colors.black54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.black54,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF9e9e9e),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
