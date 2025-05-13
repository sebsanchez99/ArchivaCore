import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_state.dart';
import 'package:frontend/presentation/pages/file_explorer/view/file_explorer_view.dart';
import 'package:frontend/presentation/widgets/buttons/customButton2.dart';
import 'package:frontend/presentation/widgets/folder/custom_folder.dart';
import 'package:frontend/presentation/widgets/states/failure_state.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';
import 'dart:async'; // Import necesario para debounce

class FileExplorer2View extends StatefulWidget {
  const FileExplorer2View({super.key});

  @override
  _FileExplorerViewState createState() => _FileExplorerViewState();
}

class _FileExplorerViewState extends State<FileExplorer2View> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _folders = [
    {"name": "ArchivaCoreeeee", "fileCount": "5 archivos", "size": "3 MB"},
    {"name": "ArchivaCore", "fileCount": "5 archivos", "size": "3 MB"},
    {"name": "ArchivaCore", "fileCount": "2 archivos", "size": "1 MB"},
    {"name": "ArchivaCore", "fileCount": "9 archivos", "size": "4 MB"},
    {"name": "ArchivaCore", "fileCount": "6 archivos", "size": "3 MB"},
    {"name": "ArchivaCore", "fileCount": "8 archivos", "size": "5 MB"},
    {"name": "ArchivaCore", "fileCount": "8 archivos", "size": "5 MB"},
    {"name": "ArchivaCore", "fileCount": "8 archivos", "size": "5 MB"},
    {"name": "ArchivaCore", "fileCount": "8 archivos", "size": "5 MB"},
    {"name": "ArchivaCore", "fileCount": "8 archivos", "size": "5 MB"},
    {"name": "ArchivaCore", "fileCount": "8 archivos", "size": "5 MB"},
    {"name": "ArchivaCore", "fileCount": "8 archivos", "size": "5 MB"},
    {"name": "ArchivaCore", "fileCount": "8 archivos", "size": "5 MB"},
    {"name": "ArchivaCore", "fileCount": "8 archivos", "size": "5 MB"},
    {"name": "ArchivaCore", "fileCount": "8 archivos", "size": "5 MB"},
    {"name": "ArchivaCore", "fileCount": "8 archivos", "size": "5 MB"},
    {"name": "ArchivaCore", "fileCount": "8 archivos", "size": "5 MB"},
    {"name": "ArchivaCore", "fileCount": "8 archivos", "size": "5 MB"},
    {"name": "ArchivaCore", "fileCount": "8 archivos", "size": "5 MB"},
    {"name": "ArchivaCore", "fileCount": "8 archivos", "size": "5 MB"},
    {"name": "ArchivaCore", "fileCount": "8 archivos", "size": "5 MB"},
    {"name": "ArchivaCore", "fileCount": "8 archivos", "size": "5 MB"},
  ];
  List<Map<String, String>> _filteredFolders = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _filteredFolders = _folders;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredFolders =
            _folders.where((folder) {
              return folder["name"]!.toLowerCase().contains(query);
            }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider<FileExplorerBloc>(
      create:
          (_) =>
              FileExplorerBloc(FileExplorerState.loading())
                ..add(InitializeEvent()),
      child: BlocConsumer<FileExplorerBloc, FileExplorerState>(
        listener: (context, state) {},
        builder: (context, state) {
          return state.map(
            loading: (_) => LoadingState(),
            loaded: (value) {
              return Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Carpetas",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            CustomButton2(onPressed: () {}, message: 'Tipo'),
                            SizedBox(width: 20),
                            CustomButton2(onPressed: () {}, message: 'Persona'),
                            SizedBox(width: 20),
                            CustomButton2(onPressed: () {}, message: 'Fecha'),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Barra de búsqueda
                        Center(
                          child: SizedBox(
                            width: 500,
                            height: 40,
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: "Buscar carpetas...",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          height: height * 0.7,
                          width: width * 0.9,
                          child: GridView.count(
                            crossAxisCount: 7,
                            crossAxisSpacing: 5,
                            children:
                                _filteredFolders.map((folder) {
                                  return Expanded(
                                    flex: 3,
                                    child: SizedBox(
                                      child: Stack(
                                        children: [
                                          CustomFolder(
                                            icon: Icons.folder,
                                            name: folder["name"]!,
                                            fileCount: folder["fileCount"]!,
                                            size: folder["size"]!,
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: PopupMenuButton<String>(
                                              tooltip: 'Opciones',
                                              icon: Icon(
                                                Icons.more_horiz,
                                                size: 20,
                                              ),
                                              elevation: 7,
                                              color: SchemaColors.background,
                                              onSelected: (String option) {
                                                if (option == 'edit') {
                                                  // Acción para editar
                                                  print(
                                                    'Editar carpeta: ${folder["name"]}',
                                                  );
                                                } else if (option ==
                                                    'organize') {
                                                  // Acción para organizar
                                                  print(
                                                    'Organizar carpeta: ${folder["name"]}',
                                                  );
                                                }
                                              },
                                              itemBuilder:
                                                  (
                                                    BuildContext context,
                                                  ) => <PopupMenuEntry<String>>[
                                                    PopupMenuItem<String>(
                                                      value: 'edit',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.edit,
                                                            size: 20,
                                                          ),
                                                          SizedBox(width: 3),
                                                          Text('Editar'),
                                                        ],
                                                      ),
                                                    ),
                                                    PopupMenuItem<String>(
                                                      value: 'organize',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.folder_open,
                                                            size: 20,
                                                          ),
                                                          SizedBox(width: 3),
                                                          Text('Organizar'),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.grid_view,
                    color: SchemaColors.primary700,
                    size: 40,
                  ),
                  tooltip: 'ir a vista',
                  elevation: 7,
                  color: SchemaColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  onSelected: (String route) {
                    if (route == 'FileExplorerView') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FileExplorerView(),
                        ),
                      );
                    } else if (route == 'FileExplorer2View') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FileExplorer2View(),
                        ),
                      );
                    }
                  },
                  itemBuilder:
                      (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'FileExplorerView',
                          child: Text('Ir a FileExplorerView'),
                        ),
                        PopupMenuItem<String>(
                          value: 'FileExplorer2View',
                          child: Text('Ir a FileExplorer2View'),
                        ),
                      ],
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
              );
            },
            failed:
                (value) => FailureState(failure: value.failure, onRetry: () {}),
          );
        },
      ),
    );
  }
}
