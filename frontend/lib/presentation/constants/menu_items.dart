import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/administration/view/adminitration_view.dart';

/// [Map] que contiene elementos que definen las vistas de la aplicación
final Map<int, Map<String, dynamic>> menuItems = {
  0: {
    "title": "Administrar",
    "icon": Icon(Icons.admin_panel_settings),
    "widget": AdministrationView(),
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