import 'package:flutter/material.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

class LocationPickerModal extends StatefulWidget {
  final List<FolderModel> rootFolders;

  const LocationPickerModal({super.key, required this.rootFolders});

  @override
  State<LocationPickerModal> createState() => _LocationPickerModalState();
}

class _LocationPickerModalState extends State<LocationPickerModal> {
  List<String> path = []; // almacena la ruta actual
  List<FolderModel> currentFolders = [];

  @override
  void initState() {
    super.initState();
    currentFolders = widget.rootFolders;
  }

  void _navigateTo(FolderModel folder) {
    setState(() {
      path.add(folder.name);
      currentFolders = folder.subFolders;
    });
  }

  void _goBack() {
    if (path.isNotEmpty) {
      setState(() {
        path.removeLast();
        // reconstruir desde root
        List<FolderModel> folders = widget.rootFolders;
        for (var segment in path) {
          final next = folders.firstWhere((f) => f.name == segment);
          folders = next.subFolders;
        }
        currentFolders = folders;
      });
    }
  }

  void _selectLocation() {
    String location;
    if (path.isEmpty) {
      location = "/"; // raíz
    } else {
      location = "/${path.join("/")}";
    }
    Navigator.pop(context, location);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: SchemaColors.neutral100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Seleccionar ubicación"),
      content: SizedBox(
        width: 400,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Ruta actual con breadcrumbs
            Row(
              children: [
                const Icon(
                  Icons.home,
                  size: 18,
                  color: SchemaColors.textPrimary,
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      path.clear();
                      currentFolders = widget.rootFolders;
                    });
                  },
                  child: const Text(
                    "Inicio",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: SchemaColors.textPrimary,
                    ),
                  ),
                ),
                for (var segment in path) ...[
                  const Text(
                    " > ",
                    style: TextStyle(color: SchemaColors.textSecondary),
                  ),
                  Text(
                    segment,
                    style: const TextStyle(color: SchemaColors.textPrimary),
                  ),
                ],
              ],
            ),
            const Divider(),

            // 🔹 Grid de carpetas
            Expanded(
              child:
                  currentFolders.isEmpty
                      ? const Center(child: Text("Carpeta vacía"))
                      : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                        itemCount: currentFolders.length,
                        itemBuilder: (context, index) {
                          final folder = currentFolders[index];
                          return GestureDetector(
                            onTap: () => _navigateTo(folder),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.folder,
                                  color: SchemaColors.warning,
                                  size: 40,
                                ),
                                Text(
                                  folder.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      actions: [
        if (path.isNotEmpty)
          TextButton(onPressed: _goBack, child: const Text("Atrás")),
        TextButton(
          onPressed: () => Navigator.pop(context), // cancelar
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: _selectLocation,
          child: const Text("Seleccionar"),
        ),
      ],
    );
  }
}
