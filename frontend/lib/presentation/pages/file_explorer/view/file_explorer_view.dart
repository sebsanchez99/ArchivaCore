import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/repositories/file_explorer_repository.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/enums/file_explorer_view_type.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/events/file_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/states/file_explorer_state.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/grid_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/states/grid_explorer_state.dart';
import 'package:frontend/presentation/pages/file_explorer/utils/utils.dart';
import 'package:frontend/presentation/pages/file_explorer/view/file_explorer_details_view.dart';
import 'package:frontend/presentation/pages/file_explorer/view/file_explorer_grid_view.dart';
import 'package:frontend/presentation/pages/file_explorer/view/file_explorer_list_view.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:frontend/presentation/widgets/buttons/custom_popupmenu.dart';
import 'package:frontend/presentation/widgets/states/failure_state.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';

class FileExplorerView extends StatelessWidget {
  const FileExplorerView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FileExplorerBloc>(
          create: (_) => FileExplorerBloc(
            FileExplorerState.loading(),
            fileExplorerRepository: context.read<FileExplorerRepository>(),
          )..add(InitializeEvent()),
        ),
        BlocProvider<GridExplorerBloc>(
          create: (_) => GridExplorerBloc(GridExplorerState.initial(rootFolders: [])),
        ),
      ],
      child: BlocConsumer<FileExplorerBloc, FileExplorerState>(
        listener: (context, state) {
          state.mapOrNull(
            loaded: (value) {
              final response = value.response;
              if (response != null) {
                showResult(context, response);
                context.read<FileExplorerBloc>().add(DeleteResponseEvent());
              }
            },
          );
        },
        builder: (context, state) {
          final bloc = context.read<FileExplorerBloc>();

          return state.map(
            loading: (_) => const LoadingState(),
            loaded: (value) {
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Carpetas",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                CustomPopupMenu<String>(
                                  tooltip: 'Agregar o crear',
                                  onSelected: (option) {
                                    if (option == 'Crear carpeta') {
                                      Navigator.pop(context);
                                      showCreateFolderDialog(context);
                                    } else if (option == 'Adjuntar archivo') {
                                      Navigator.pop(context);
                                      showAttachFolderDialog(context, bloc);
                                    }
                                  },
                                  items: <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: 'Crear carpeta',
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.folder,
                                            size: 25,
                                            color: SchemaColors.warning,
                                          ),
                                          const SizedBox(width: 10),
                                          const Text('Crear carpeta'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'Adjuntar archivo',
                                      child: Row(
                                        children: [
                                          const Icon(
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
                                  child: CustomIconButton(
                                    message: 'Agregar o crear',
                                    icon: Icons.add,
                                    disabledBackgroundColor: SchemaColors.primary500,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                IconButton(
                                  tooltip: 'Refrescar',
                                  onPressed: () => bloc.add(InitializeEvent()),
                                  icon: Icon(Icons.refresh),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 800) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Search bar
                                Expanded(
                                  child: TextField(
                                    controller: bloc.searchController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: "Buscar carpetas...",
                                      prefixIcon: const Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 30),
                                // Filter and view type buttons
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
                                      tooltip: 'Cuadrícula',
                                      icon: const Icon(Icons.grid_view),
                                      color: SchemaColors.primary700,
                                      iconSize: 30,
                                      onPressed: () => bloc.add(ChangeViewTypeEvent(viewType: FileExplorerViewType.grid())),
                                    ),
                                    IconButton(
                                      tooltip: 'Lista',
                                      icon: const Icon(Icons.format_list_bulleted),
                                      color: SchemaColors.primary700,
                                      iconSize: 30,
                                      onPressed: () => bloc.add(ChangeViewTypeEvent(viewType: FileExplorerViewType.details())),
                                    ),
                                    IconButton(
                                      tooltip: 'Tabla',
                                      icon: const Icon(Icons.table_chart),
                                      color: SchemaColors.primary700,
                                      iconSize: 30,
                                      onPressed: () => bloc.add(ChangeViewTypeEvent(viewType: FileExplorerViewType.list())),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            // Mobile/tablet view (smaller screens)
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextField(
                                  controller: bloc.searchController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Buscar carpetas...",
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Wrap(
                                  spacing: 20,
                                  runSpacing: 10,
                                  children: [
                                    CustomButton(onPressed: () {}, message: 'Tipo'),
                                    CustomButton(onPressed: () {}, message: 'Persona'),
                                    CustomButton(onPressed: () {}, message: 'Fecha'),
                                    IconButton(
                                      tooltip: 'Cuadrícula',
                                      icon: const Icon(Icons.grid_view),
                                      color: SchemaColors.primary700,
                                      iconSize: 30,
                                      onPressed: () => bloc.add(ChangeViewTypeEvent(viewType: FileExplorerViewType.grid())),
                                    ),
                                    IconButton(
                                      tooltip: 'Lista',
                                      icon: const Icon(Icons.format_list_bulleted),
                                      color: SchemaColors.primary700,
                                      iconSize: 30,
                                      onPressed: () => bloc.add(ChangeViewTypeEvent(viewType: FileExplorerViewType.details())),
                                    ),
                                    IconButton(
                                      tooltip: 'Tabla',
                                      icon: const Icon(Icons.table_chart),
                                      color: SchemaColors.primary700,
                                      iconSize: 30,
                                      onPressed: () => bloc.add(ChangeViewTypeEvent(viewType: FileExplorerViewType.list())),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 20),

                      Expanded(
                        child: value.viewType.when(
                          grid: () => FileExplorerGridView(
                            bloc: bloc,
                            gridBloc: context.read<GridExplorerBloc>(),
                          ),
                          details: () => FileExplorerDetailsView(bloc: bloc),
                          list: () => FileExplorerListView(bloc: bloc),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            failed: (value) => FailureState(failure: value.failure, onRetry: () => bloc.add(InitializeEvent())),
          );
        },
      ),
    );
  }
}