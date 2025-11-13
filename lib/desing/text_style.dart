//import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextStyles {
  static const TextStyle bodyText = TextStyle(color: Colors.black, fontSize: 16);
  static const TextStyle bodyTextBold = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);
  static const TextStyle subtitle = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);

  static const TextStyle h2Sub = TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500);


  static const TextStyle h1 = TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold);
  static const TextStyle h2 = TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500);
  static const TextStyle h3 = TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400);
  static const TextStyle h4 = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600);
  static const TextStyle h4Color = TextStyle(color: Color.fromARGB(255, 17, 42, 184), fontSize: 16, fontWeight: FontWeight.w600);

  static const TextStyle h5 = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600);

  static const TextStyle alert = TextStyle(color: Color.fromARGB(255, 1, 38, 160), fontSize: 20, fontWeight: FontWeight.w400);

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