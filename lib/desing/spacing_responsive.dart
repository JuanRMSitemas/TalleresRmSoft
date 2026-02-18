import 'package:flutter/material.dart';

///  Clase para manejar espaciados y márgenes responsivos en toda la app.
/// Usa proporciones basadas en el ancho o alto del dispositivo.
class AppSpacing {
  /// Obtiene un porcentaje del ancho de la pantalla.
  static double width(BuildContext context, double percent) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (percent / 100);
  }

  /// Obtiene un porcentaje del alto de la pantalla.
  static double height(BuildContext context, double percent) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * (percent / 100);
  }

  /// SizedBox horizontal dinámico
  static SizedBox horizontal(BuildContext context, double percent) =>
      SizedBox(width: width(context, percent));

  /// SizedBox vertical dinámico
  static SizedBox vertical(BuildContext context, double percent) =>
      SizedBox(height: height(context, percent));

  /// Margenes predefinidos (puedes ajustarlos)
  static EdgeInsets screenPadding(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: width(context, 4), vertical: height(context, 2));

  static EdgeInsets cardPadding(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: width(context, 3), vertical: height(context, 1));

  static EdgeInsets left(BuildContext context, double percent) =>
      EdgeInsets.only(left: width(context, percent));

  static EdgeInsets right(BuildContext context, double percent) =>
      EdgeInsets.only(right: width(context, percent));

  static EdgeInsets top(BuildContext context, double percent) =>
      EdgeInsets.only(top: height(context, percent));

  static EdgeInsets bottom(BuildContext context, double percent) =>
      EdgeInsets.only(bottom: height(context, percent));
}
