import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/repositories/file_explorer_repository.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/domain/enums/file_explorer_view_type.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_state.dart';
import 'package:frontend/presentation/pages/file_explorer/utils/utils.dart';
import 'package:frontend/presentation/pages/file_explorer/view/file_explorer_details_view.dart';
import 'package:frontend/presentation/pages/file_explorer/view/file_explorer_grid_view.dart';
import 'package:frontend/presentation/pages/file_explorer/view/file_explorer_list_view.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button2.dart';
import 'package:frontend/presentation/widgets/states/failure_state.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';

class FileExplorerView extends StatelessWidget {
  const FileExplorerView({super.key});

  @override
  Widget build(BuildContext context) {
    final widtdh = MediaQuery.of(context).size.width;
    return BlocProvider<FileExplorerBloc>(
      create:
          (_) => FileExplorerBloc(
            FileExplorerState.loading(),
            fileExplorerRepository: context.read<FileExplorerRepository>(),
          )..add(InitializeEvent()),
      child: BlocConsumer<FileExplorerBloc, FileExplorerState>(
        listener: (context, state) {},
        builder: (context, state) {
          final bloc = context.read<FileExplorerBloc>();
          return state.map(
            loading: (_) => LoadingState(),
            loaded: (value) {
              return Scaffold(
                body: Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Carpetas",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PopupMenuButton<String>(
                            tooltip: 'Crear Carpeta o Adjuntar Archivo',
                            offset: Offset(0, 40),
                            itemBuilder:
                                (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        value: 'Crear Carpeta',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.folder,
                                              size: 25,
                                              color: SchemaColors.warning,
                                            ),
                                            SizedBox(width: 10),
                                            Text('Crear Carpeta'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'Adjuntar Archivo',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.file_copy,
                                              size: 25,
                                              color: SchemaColors.secondary500,
                                            ),
                                            SizedBox(width: 10),
                                            Text('Adjuntar Archivo'),
                                          ],
                                        ),
                                      ),
                                    ],
                            onSelected: (String option) {
                              if (option == 'Crear Carpeta') {
                                showCreateFolderDialog(context);
                              } else if (option == 'Adjuntar Archivo') {
                                showAttachFolderDialog(context);
                              }
                            },
                            child: TextButton.icon(
                              icon: Icon(
                                Icons.add,
                                size: 30,
                                color: SchemaColors.primary700,
                              ),
                              label: Text(
                                'Agregar o crear',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: SchemaColors.primary700,
                                ),
                              ),
                              onPressed:
                                  null, // El PopupMenuButton maneja el onPressed
                              style: TextButton.styleFrom(
                                foregroundColor: SchemaColors.primary700,
                                backgroundColor: Colors.transparent,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                side: BorderSide(
                                  color: SchemaColors.border,
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Wrap(
                          verticalDirection: VerticalDirection.up,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          spacing: 30,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // TODO: convertir en widget personalizado para usar en otros lugares(Barra de búsqueda)
                                TextField(
                                  controller: bloc.searchController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    constraints: BoxConstraints(
                                      maxWidth: widtdh * 0.3,
                                    ),
                                    hintText: "Buscar carpetas...",
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
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
                                SizedBox(width: 30),
                                IconButton(
                                  tooltip: 'Inicio',
                                  icon: Icon(
                                    Icons.list,
                                    color: SchemaColors.primary700,
                                    size: 30,
                                  ),
                                  onPressed:
                                      () => bloc.add(
                                        ChangeViewTypeEvent(
                                          viewType: FileExplorerViewType.list(),
                                        ),
                                      ),
                                ),
                                IconButton(
                                  tooltip: 'Cuadrícula',
                                  icon: Icon(
                                    Icons.grid_view,
                                    color: SchemaColors.primary700,
                                    size: 30,
                                  ),
                                  onPressed:
                                      () => bloc.add(
                                        ChangeViewTypeEvent(
                                          viewType: FileExplorerViewType.grid(),
                                        ),
                                      ),
                                ),
                                IconButton(
                                  tooltip: 'Bodega',
                                  icon: Icon(
                                    Icons.details,
                                    color: SchemaColors.primary700,
                                    size: 30,
                                  ),
                                  onPressed:
                                      () => bloc.add(
                                        ChangeViewTypeEvent(
                                          viewType:
                                              FileExplorerViewType.details(),
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: value.viewType.when(
                          list: () => FileExplorerListView(bloc: bloc),
                          grid: () => FileExplorerGridView(bloc: bloc),
                          details: () => FileExplorerDetailsView(bloc: bloc),
                        ),
                      ),

                      // SizedBox(height: 15),
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
