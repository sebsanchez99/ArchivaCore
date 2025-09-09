import 'package:flutter/material.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/buttons/custom_icon_button.dart';

class LocationPickerModal extends StatefulWidget {
  final List<FolderModel> rootFolders;

  const LocationPickerModal({super.key, required this.rootFolders});

  @override
  State<LocationPickerModal> createState() => _LocationPickerModalState();
}

class _LocationPickerModalState extends State<LocationPickerModal> {
  List<String> path = []; 
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
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_sweep_outlined,
                              color: Colors.grey,
                              size: 40,
                            ),
                            Text(
                              'Carpeta vacía.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                        )
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
                          return Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.folder),
                                color: SchemaColors.warning,
                                onPressed: () => _navigateTo(folder),
                                iconSize: 40,
                              ),
                              Text(
                                folder.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      actions: [
        if (path.isNotEmpty)
          CustomIconButton(
            icon: Icons.keyboard_arrow_left,
            onPressed: _goBack, 
            message: "Atrás",
            height: 15,
            width: 15,
          ),
        CustomButton(
          onPressed: () => Navigator.pop(context), 
          message: "Cancelar",
          height: 15,
          width: 15,
          color: SchemaColors.error,
        ),
        CustomButton(
          onPressed: _selectLocation,
          message: "Seleccionar",
          height: 15,
          width: 15,
          color: SchemaColors.success,
        ),
      ],
    );
  }
}
