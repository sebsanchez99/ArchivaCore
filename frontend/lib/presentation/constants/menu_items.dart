import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/resume_analizer/view/resume_analizer_view.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:frontend/presentation/pages/administration/view/adminitration_view.dart';
import 'package:frontend/presentation/pages/file_explorer/view/file_explore3_view.dart';
import 'package:frontend/presentation/pages/file_explorer/view/file_explorer2_view.dart';
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
    "title": "Archivos2",
    "icon": Icon(Icons.folder),
    "widget": FileExplorer2View(),
  },
  3: {
    "title": "Archivos3",
    "icon": Icon(Icons.folder),
    "widget": FileExplorer3View(),
  },
  4: {
    "title": "Analizador HV",
    "icon": Icon(LucideIcons.bot),
    "widget": ResumeAnalizerView(),
  },
};
