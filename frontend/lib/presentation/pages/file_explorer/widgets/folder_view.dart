import 'package:flutter/material.dart';
import 'package:frontend/presentation/widgets/folder/custom_folder2.dart';

class FolderView extends StatefulWidget {
  @override
  State<FolderView> createState() => _FolderPreviewDialogState();
}

class _FolderPreviewDialogState extends State<FolderView> {
  List<String> path = ['Inicio', 'Documentos', 'Proyectos'];
  List<String> currentItems = ['Proyecto A', 'Proyecto B'];
  String? selectedFile;

  void navigateToFolder(String folder) {
    setState(() {
      path.add(folder);
      currentItems = ['Archivo1.txt', 'Archivo2.pdf']; // Cambiar según lógica real
      selectedFile = null;
    });
  }

  void goToPath(int index) {
    setState(() {
      path = path.sublist(0, index + 1);
      currentItems = ['Proyecto A', 'Proyecto B']; // Volver a estado anterior
      selectedFile = null;
    });
  }

  void previewFile(String file) {
    setState(() {
      selectedFile = 'Contenido simulado de $file';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// IZQUIERDA: Explorador de carpetas
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Breadcrumbs
                Wrap(
                  spacing: 6,
                  children: List.generate(path.length, (index) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => goToPath(index),
                          child: Text(
                            path[index],
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        if (index != path.length - 1) Text(" > "),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 12),

                /// Lista de carpetas y archivos con customFolder2
                Expanded(
                  child: ListView.builder(
                    itemCount: currentItems.length,
                    itemBuilder: (context, index) {
                      final item = currentItems[index];
                      final isFolder = item.toLowerCase().contains("proyecto") || item.toLowerCase().contains("carpeta");

                      return  CustomFolder2(leading: Icons.add_ic_call_rounded, title: 'title');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        /// DIVISOR
        VerticalDivider(),

        /// DERECHA: Vista previa del archivo
        Expanded(
          flex: 3,
          child: Center(
            child: selectedFile == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.insert_drive_file, size: 60, color: Colors.grey),
                      SizedBox(height: 8),
                      Text("Selecciona un archivo", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Haz clic en un documento para ver su contenido", style: TextStyle(fontSize: 12)),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(selectedFile!),
                  ),
          ),
        ),
      ],
    );
  }
}
