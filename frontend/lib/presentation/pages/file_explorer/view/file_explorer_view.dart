import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/repositories/file_explorer_repository.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/enums/file_explorer_view_type.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_state.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/grid_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/grid_explorer_state.dart';
import 'package:frontend/presentation/pages/file_explorer/utils/utils.dart';
import 'package:frontend/presentation/pages/file_explorer/view/file_explorer_details_view.dart';
import 'package:frontend/presentation/pages/file_explorer/view/file_explorer_grid_view.dart';
import 'package:frontend/presentation/pages/file_explorer/view/file_explorer_list_view.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/states/failure_state.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';

class FileExplorerView extends StatelessWidget {
  const FileExplorerView({super.key});

  @override
  Widget build(BuildContext context) {
    final widtdh = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
      providers: [
        /// Bloc general
        BlocProvider<FileExplorerBloc>(
          create: (_) => FileExplorerBloc(
            FileExplorerState.loading(),
            fileExplorerRepository: context.read<FileExplorerRepository>(),
          )..add(InitializeEvent()),
        ),

        /// Bloc específico para Grid
        BlocProvider<GridExplorerBloc>(
          create: (_) => GridExplorerBloc(
            GridExplorerState.initial(rootFolders: []),
            fileExplorerRepository: context.read<FileExplorerRepository>(), rootFolders: [],
          ),
        ),
      ],
      child: BlocConsumer<FileExplorerBloc, FileExplorerState>(
        listener: (context, state) {},
        builder: (context, state) {
          final bloc = context.read<FileExplorerBloc>();
          final gridBloc = context.read<GridExplorerBloc>();

          return state.map(
            loading: (_) => const LoadingState(),
            loaded: (value) {
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Encabezado con título y menú
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Carpetas",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PopupMenuButton<String>(
                            tooltip: 'Crear Carpeta o Adjuntar Archivo',
                            offset: const Offset(0, 40),
                            itemBuilder: (BuildContext context) =>
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
                                    const SizedBox(width: 10),
                                    const Text('Crear Carpeta'),
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
                                    const SizedBox(width: 10),
                                    const Text('Adjuntar Archivo'),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (option) {
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
                              onPressed: null,
                              style: TextButton.styleFrom(
                                foregroundColor: SchemaColors.primary700,
                                backgroundColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
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
                      const SizedBox(height: 20),

                      /// Barra de búsqueda + filtros + botones de vista
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
                                TextField(
                                  controller: bloc.searchController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    constraints:
                                        BoxConstraints(maxWidth: widtdh * 0.3),
                                    hintText: "Buscar carpetas...",
                                    prefixIcon: const Icon(Icons.search),
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
                                CustomButton(onPressed: () {}, message: 'Tipo'),
                                const SizedBox(width: 20),
                                CustomButton(onPressed: () {}, message: 'Persona'),
                                const SizedBox(width: 20),
                                CustomButton(onPressed: () {}, message: 'Fecha'),
                                const SizedBox(width: 30),
                                IconButton(
                                  tooltip: 'Inicio',
                                  icon: Icon(
                                    Icons.list,
                                    color: SchemaColors.primary700,
                                    size: 30,
                                  ),
                                  onPressed: () => bloc.add(ChangeViewTypeEvent(
                                      viewType: FileExplorerViewType.list())),
                                ),
                                IconButton(
                                  tooltip: 'Cuadrícula',
                                  icon: Icon(
                                    Icons.grid_view,
                                    color: SchemaColors.primary700,
                                    size: 30,
                                  ),
                                  onPressed: () => bloc.add(ChangeViewTypeEvent(
                                      viewType: FileExplorerViewType.grid())),
                                ),
                                IconButton(
                                  tooltip: 'Bodega',
                                  icon: Icon(
                                    Icons.details,
                                    color: SchemaColors.primary700,
                                    size: 30,
                                  ),
                                  onPressed: () => bloc.add(ChangeViewTypeEvent(
                                      viewType: FileExplorerViewType.details())),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Vista principal: Lista, Grid o Details
                      Expanded(
                        child: value.viewType.when(
                          list: () => FileExplorerListView(bloc: bloc),
                          grid: () => FileExplorerGridView(
                            bloc: bloc,
                            gridBloc: gridBloc,
                          ),
                          details: () => FileExplorerDetailsView(bloc: bloc),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            failed: (value) =>
                FailureState(failure: value.failure, onRetry: () {}),
          );
        },
      ),
    );
  }
}
