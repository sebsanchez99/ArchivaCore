import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_state.dart';
import 'package:frontend/presentation/widgets/folder/custom_folder.dart';
import 'package:frontend/presentation/widgets/states/failure_state.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';

class FileExplorerView extends StatelessWidget {
  const FileExplorerView({super.key});

  @override
  Widget build(BuildContext context) {
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
                body: Padding(
                  padding: EdgeInsets.all(16.0),
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
                      SizedBox(height: 10),
                      Center(
                        child: SizedBox(
                          height: 150,
                          width: 850,
                          child: GridView.count(
                            crossAxisCount: 5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 6,
                            children: [
                              CustomFolder(
                                icon: Icons.folder,
                                name: "ArchivaCore",
                                fileCount: "5 archivos",
                                size: "3 MB",
                              ),
                              CustomFolder(
                                icon: Icons.folder,
                                name: "ArchivaCore",
                                fileCount: "2 archivos",
                                size: "1 MB",
                              ),
                              CustomFolder(
                                icon: Icons.folder,
                                name: "ArchivaCore",
                                fileCount: "9 archivos",
                                size: "4 MB",
                              ),
                              CustomFolder(
                                icon: Icons.folder,
                                name: "ArchivaCore",
                                fileCount: "6 archivos",
                                size: "3 MB",
                              ),
                              CustomFolder(
                                icon: Icons.folder,
                                name: "ArchivaCore",
                                fileCount: "8 archivos",
                                size: "5 MB",
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(),
                      SizedBox(height: 10),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Todos los archivos",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Modificado por",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Última vez",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Detalles",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.folder,
                                  color: SchemaColors.warning,
                                  size: 40,
                                ),
                                Text("Proyecto"),
                              ],
                            ),
                            Text("Camilo"),
                            Text("20 sep 9:30am"),
                          ],
                        ),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.insert_drive_file,
                                    color: SchemaColors.primary900,
                                    size: 30,
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.remove_red_eye),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
