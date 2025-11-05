//import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextStyles {
  static const TextStyle bodyText = TextStyle(color: Color.fromARGB(255, 63, 63, 66), fontSize: 18);
  static const TextStyle h1 = TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold);
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