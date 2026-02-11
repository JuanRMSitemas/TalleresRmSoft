//import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextStyles {
  static const TextStyle bodyText = TextStyle(color: Colors.black, fontSize: 16);
  static const TextStyle bodyTextBold = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);
  static const TextStyle subtitle = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);

  static const TextStyle h2Sub = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
  static const TextStyle h2Subb = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);

  //Scaffold titles
  static const TextStyle scaffoldTitle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

  //Encabezados
  static const TextStyle h1 = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
  static const TextStyle h2 = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
  static const TextStyle h3 = TextStyle(fontSize: 20, fontWeight: FontWeight.w400);
  static const TextStyle h4 = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const TextStyle h4Color = TextStyle(fontSize: 18, fontWeight: FontWeight.w900);

  static const TextStyle h5 = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600);

  static const TextStyle alert = TextStyle(color: Color.fromARGB(255, 173, 0, 0), fontSize: 20, fontWeight: FontWeight.w600);

}


//Pasar a mayusculas
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}