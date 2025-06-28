import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/recycling/view/recycling_view.dart';
import 'package:frontend/presentation/pages/resume_analizer/view/resume_analizer_view.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:frontend/presentation/pages/administration/view/adminitration_view.dart';
import 'package:frontend/presentation/pages/file_explorer/view/file_explorer_view.dart';

/// [Map] que contiene elementos que definen las vistas de la aplicación
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
    "title": "Analizador HV",
    "icon": Icon(LucideIcons.bot),
    "widget": ResumeAnalizerView(),
  },
  3: {
    "title": "Reciclaje",
    "icon": Icon(Icons.delete),
    "widget": RecyclingView(),
  },
};
