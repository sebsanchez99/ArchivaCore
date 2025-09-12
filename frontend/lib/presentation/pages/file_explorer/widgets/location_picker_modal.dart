import 'package:flutter/material.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/buttons/custom_icon_button.dart';

class LocationPickerModal extends StatefulWidget {
  final List<FolderModel> rootFolders;
  final FolderModel? excludedFolder; // 👈 Carpeta a excluir (opcional)

  const LocationPickerModal({
    super.key,
    required this.rootFolders,
    this.excludedFolder,
  });

  @override
  State<LocationPickerModal> createState() => _LocationPickerModalState();
}

class _LocationPickerModalState extends State<LocationPickerModal> {
  List<String> path = [];
  List<FolderModel> currentFolders = [];
  FolderModel? currentSelectedFolder;

  @override
  void initState() {
    super.initState();
    currentFolders = _filterExcluded(widget.rootFolders, widget.excludedFolder);
  }

  /// Filtra la carpeta excluida y todas sus subcarpetas
  List<FolderModel> _filterExcluded(List<FolderModel> folders, FolderModel? excluded) {
    if (excluded == null) return folders;

    return folders
        .where((f) => f.path != excluded.path)
        .map((f) => FolderModel(
              name: f.name,
              files: f.files,
              path: f.path,
              subFolders: _filterExcluded(f.subFolders, excluded),
            ))
        .toList();
  }

  void _navigateTo(FolderModel folder) {
    setState(() {
      path.add(folder.name);
      currentFolders = _filterExcluded(folder.subFolders, widget.excludedFolder);
      currentSelectedFolder = folder;
    });
  }

  void _goBack() {
    if (path.isNotEmpty) {
      setState(() {
        path.removeLast();
        List<FolderModel> folders =
            _filterExcluded(widget.rootFolders, widget.excludedFolder);
        FolderModel? parentFolder;
        for (var segment in path) {
          parentFolder = folders.firstWhere((f) => f.name == segment);
          folders = _filterExcluded(parentFolder.subFolders, widget.excludedFolder);
        }
        currentFolders = folders;
        currentSelectedFolder = parentFolder;
      });
    } else {
      setState(() {
        currentSelectedFolder = null;
        currentFolders =
            _filterExcluded(widget.rootFolders, widget.excludedFolder);
      });
    }
  }

  void _selectLocation() {
    String location;
    if (currentSelectedFolder != null) {
      location = currentSelectedFolder!.path;
    } else {
      location = "/";
    }
    Navigator.pop(context, location);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: SchemaColors.neutral100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Seleccionar ubicación"),
      actionsAlignment: MainAxisAlignment.center,
      content: SizedBox(
        width: 400,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.home, size: 18, color: SchemaColors.textPrimary),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      path.clear();
                      currentFolders = _filterExcluded(
                          widget.rootFolders, widget.excludedFolder);
                      currentSelectedFolder = null;
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
                  const Text(" > ", style: TextStyle(color: SchemaColors.textSecondary)),
                  Text(segment, style: const TextStyle(color: SchemaColors.textPrimary)),
                ],
              ],
            ),
            const Divider(),
            Expanded(
              child: currentFolders.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_sweep_outlined,
                              color: Colors.grey, size: 40),
                          Text(
                            'Carpeta vacía.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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
                              icon: const Icon(Icons.folder),
                              color: SchemaColors.warning,
                              onPressed: () => _navigateTo(folder),
                              iconSize: 40,
                            ),
                            Text(folder.name, overflow: TextOverflow.ellipsis),
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
