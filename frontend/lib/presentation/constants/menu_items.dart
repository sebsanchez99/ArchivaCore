import 'package:flutter/material.dart';

//Sirve para guardar elementos de las vistas
final Map<int, Map<String, dynamic>> menuItems = {
  0: {
    "title": "Carpetas",
    "icon": Icon(Icons.folder),
    "widget": Text("Vista de Carpetas"),
  },
  1: {
    "title": "Usuarios",
    "icon": Icon(Icons.verified_user),
    "widget": Text("Vista de Usuarios"),
  },
  2: {
    "title": "Cerrar Sesion",
    "icon": Icon(Icons.verified_user_outlined),
    "widget": Text("Vista de cerrar sesion"),
  },
};
