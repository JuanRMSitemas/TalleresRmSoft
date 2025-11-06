//import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextStyles {
  static const TextStyle bodyText = TextStyle(color: Color.fromARGB(255, 63, 63, 66), fontSize: 18);
  static const TextStyle h1 = TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold);
  static const TextStyle h2 = TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500);
  static const TextStyle h3 = TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400);
  static const TextStyle h4 = TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600);

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