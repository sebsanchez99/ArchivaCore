import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/administration/view/adminitration_view.dart';
import 'package:frontend/presentation/pages/file_explorer/view/file_explorer_view.dart';

//Sirve para guardar elementos de las vistas
final Map<int, Map<String, dynamic>> menuItems = {
  0: {
    "title": "Administrar",
    "icon": Icon(Icons.admin_panel_settings),
    "widget": AdministrationView(),
  },
  1: {
    "title": "Archivos",
    "icon": Icon(Icons.folder),
    "widget": FileExplorerView(),
  },
  2: {
    "title": "Cerrar Sesion",
    "icon": Icon(Icons.verified_user_outlined),
    "widget": Text("Vista de cerrar sesion"),
  },
};
