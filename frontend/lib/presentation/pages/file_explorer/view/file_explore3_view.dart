import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_state.dart';
import 'package:frontend/presentation/pages/file_explorer/view/file_explorer2_view.dart';
import 'package:frontend/presentation/pages/file_explorer/view/file_explorer_view.dart';
import 'package:frontend/presentation/widgets/buttons/customButton2.dart';
import 'package:frontend/presentation/widgets/folder/custom_folder.dart';
import 'package:frontend/presentation/widgets/folder/custom_folder2.dart';
import 'package:frontend/presentation/widgets/states/failure_state.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';
import 'dart:async'; // Import necesario para debounce

class FileExplorer3View extends StatefulWidget {
  const FileExplorer3View({super.key});

  @override
  _FileExplorerViewState createState() => _FileExplorerViewState();
}

class _FileExplorerViewState extends State<FileExplorer3View> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _folders = [
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
  ];
  List<Map<String, String>> _filteredFolders = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _filteredFolders = _folders; // Inicialmente muestra todas las carpetas
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                body: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: width * 0.2,
                          height: height * 0.8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListView(
                                  children: [
                                    CustomFolder2(
                                      leading: Icons.folder,
                                      title: 'Documento 1',
                                    ),
                                    CustomFolder2(
                                      leading: Icons.folder,
                                      title: 'Documento 1',
                                    ),
                                    CustomFolder2(
                                      leading: Icons.folder,
                                      title: 'Documento 1',
                                    ),
                                    CustomFolder2(
                                      leading: Icons.folder,
                                      title: 'Documento 1',
                                    ),
                                    CustomFolder2(
                                      leading: Icons.folder,
                                      title: 'Documento 1',
                                    ),
                                    CustomFolder2(
                                      leading: Icons.folder,
                                      title: 'Documento 1',
                                    ),
                                    CustomFolder2(
                                      leading: Icons.folder,
                                      title: 'Documento 1',
                                    ),
                                    CustomFolder2(
                                      leading: Icons.folder,
                                      title: 'Documento 1',
                                    ),
                                    CustomFolder2(
                                      leading: Icons.folder,
                                      title: 'Documento 1',
                                    ),
                                    CustomFolder2(
                                      leading: Icons.folder,
                                      title: 'Documento 1',
                                    ),
                                    CustomFolder2(
                                      leading: Icons.folder,
                                      title: 'Documento 1',
                                    ),
                                    CustomFolder2(
                                      leading: Icons.folder,
                                      title: 'Documento 1',
                                    ),
                                    CustomFolder2(
                                      leading: Icons.folder,
                                      title: 'Documento 1',
                                    ),
                                    CustomFolder2(
                                      leading: Icons.folder,
                                      title: 'Documento 1',
                                    ),
                                    CustomFolder2(
                                      leading: Icons.folder,
                                      title: 'Documento 1',
                                    ),
                                    CustomFolder2(
                                      leading: Icons.folder,
                                      title: 'Documento 2',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: width * 0.7,
                            height: height * 0.8,
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      ('Nombre de la carpeta'),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        CustomButton2(
                                          onPressed: () {},
                                          message: 'Tipo',
                                        ),
                                        SizedBox(width: 20),
                                        CustomButton2(
                                          onPressed: () {},
                                          message: 'Persona',
                                        ),
                                        SizedBox(width: 20),
                                        CustomButton2(
                                          onPressed: () {},
                                          message: 'Fecha',
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(
                                      width: 500,
                                      height: 40,
                                      child: TextField(
                                        controller: _searchController,
                                        decoration: InputDecoration(
                                          hintText: "Buscar carpetas...",
                                          prefixIcon: Icon(Icons.search),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 15,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
