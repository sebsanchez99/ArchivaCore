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
import 'package:frontend/presentation/pages/file_explorer/widgets/downloading_dialog.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/multi_select_dropdown.dart';
import 'package:frontend/presentation/pages/notification/bloc/notification_bloc.dart';
import 'package:frontend/presentation/widgets/buttons/custom_popupmenu.dart';
import 'package:frontend/presentation/widgets/states/failure_state.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/events/grid_explorer_events.dart'; // Importa los eventos del GridBloc

class FileExplorerView extends StatefulWidget {
  const FileExplorerView({super.key});

  @override
  State<FileExplorerView> createState() => _FileExplorerViewState();
}

class _FileExplorerViewState extends State<FileExplorerView> {
  BuildContext? _downloadingDialogContext;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FileExplorerBloc>(
          create: (_) => FileExplorerBloc(
            FileExplorerState.loading(),
            context.read<NotificationBloc>(),
            fileExplorerRepository: context.read<FileExplorerRepository>(),
          )..add(InitializeEvent()),
        ),
        BlocProvider<GridExplorerBloc>(
          create: (_) => GridExplorerBloc(GridExplorerState(folders: [], files: [], navigationStack: [], path: [], rootFolders: [])),
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

              if (value.downloading) {
                // Solo mostrar si no se ha mostrado ya
                if (_downloadingDialogContext == null) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) {
                      _downloadingDialogContext = dialogContext;
                      return const DownloadingDialog();
                    },
                  );
                }
              } else {
                // Si el diálogo está abierto, lo cerramos
                if (_downloadingDialogContext != null) {
                  Navigator.of(_downloadingDialogContext!, rootNavigator: true).pop();
                  _downloadingDialogContext = null;
                }
              }

              context.read<GridExplorerBloc>().add(UpdateFromExplorer(
                folders: value.filteredContent.folders,
                files: value.filteredContent.files,
              ));
            },
          );
        },
        builder: (context, state) {
          final bloc = context.read<FileExplorerBloc>();
          final gridBloc = context.read<GridExplorerBloc>();
          final isBusy = bloc.state.mapOrNull(loaded: (value) => value.isBusy) ?? false;

          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      AbsorbPointer(
                        absorbing: isBusy,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              CustomPopupMenu<String>(
                                icon: Icons.add_circle_outline_outlined,
                                tooltip: 'Agregar o crear',
                                onSelected: (option) async {
                                  Navigator.pop(context);
                                  if (option == 'Crear carpeta') {
                                    showCreateFolderDialog(context);
                                  } else if (option == 'Adjuntar archivo') {
                                    showAttachFolderDialog(context, bloc);
                                  }
                                },
                                items: const <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'Crear carpeta',
                                    child: Row(
                                      children: [
                                        Icon(Icons.folder, size: 25, color: SchemaColors.warning),
                                        SizedBox(width: 10),
                                        Text('Crear carpeta'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'Adjuntar archivo',
                                    child: Row(
                                      children: [
                                        Icon(Icons.file_copy, size: 25, color: SchemaColors.secondary500),
                                        SizedBox(width: 10),
                                        Text('Adjuntar Archivo'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                iconSize: 35,
                                tooltip: 'Refrescar',
                                onPressed: () => bloc.add(InitializeEvent()),
                                icon: const Icon(Icons.refresh),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth > 800;
                      return isDesktop ? _buildDesktopControls(bloc, bloc.searchController) : _buildMobileControls(bloc, bloc.searchController);
                    },
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: state.map(
                      loading: (_) => const LoadingState(),
                      failed: (value) => FailureState(failure: value.failure, onRetry: () => bloc.add(InitializeEvent())),
                      loaded: (value) {
                        if (value.isBusy) {
                          return const LoadingState();
                        }
                        
                        return value.viewType.when(
                          grid: () => FileExplorerGridView(bloc: bloc, gridBloc: gridBloc),
                          details: () => FileExplorerDetailsView(bloc: bloc),
                          list: () => FileExplorerListView(bloc: bloc),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopControls(FileExplorerBloc bloc, TextEditingController controller) {
    final isBusy = bloc.state.mapOrNull(loaded: (value) => value.isBusy) ?? false;
    return AbsorbPointer(
      absorbing: isBusy,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: SchemaColors.secondary500
                  )
                ),
                hintStyle: TextStyle(fontSize: 14),
                isDense: true,
                hintText: "Buscar carpetas...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
          const SizedBox(width: 30),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
      
              MultiSelectDropdown(
                hintText: 'Tipo',
                items: bloc.state.mapOrNull(loaded: (value) => value.allTypes) ?? [],
                tooltip: 'Tipo de archivo',
                onSelectionChanged: (selectedTypes) => bloc.add(FilterByTypesAndAuthorsEvent(selectedTypes: selectedTypes, selectedAuthors: bloc.state.mapOrNull(loaded: (v) => v.selectedAuthors) ?? {})),
              ),
              const SizedBox(width: 20),
              MultiSelectDropdown(
                hintText: 'Autor',
                items: bloc.state.mapOrNull(loaded: (value) => value.allAuthors) ?? [],
                tooltip: 'Autor de archivo',
                onSelectionChanged: (selectedAuthors) => bloc.add(FilterByTypesAndAuthorsEvent(selectedTypes: bloc.state.mapOrNull(loaded: (v) => v.selectedTypes) ?? {}, selectedAuthors: selectedAuthors)),
              ),
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
      ),
    );
  }

  Widget _buildMobileControls(FileExplorerBloc bloc, TextEditingController controller) {
    final isBusy = bloc.state.mapOrNull(loaded: (value) => value.isBusy) ?? false;

    return AbsorbPointer(
      absorbing: isBusy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              isDense: true,
              hintText: "Buscar carpetas...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              MultiSelectDropdown(
                hintText: 'Tipo',
                items: bloc.state.mapOrNull(loaded: (value) => value.allTypes) ?? [],
                tooltip: 'Tipo de archivo',
                onSelectionChanged: (selectedTypes) => bloc.add(FilterByTypesAndAuthorsEvent(selectedTypes: selectedTypes, selectedAuthors: bloc.state.mapOrNull(loaded: (v) => v.selectedAuthors) ?? {})),
              ),
              const SizedBox(width: 20),
              MultiSelectDropdown(
                hintText: 'Autor',
                items: bloc.state.mapOrNull(loaded: (value) => value.allAuthors) ?? [],
                tooltip: 'Autor de archivo',
                onSelectionChanged: (selectedAuthors) => bloc.add(FilterByTypesAndAuthorsEvent(selectedTypes: bloc.state.mapOrNull(loaded: (v) => v.selectedTypes) ?? {}, selectedAuthors: selectedAuthors)),
              ),
              IconButton(
                tooltip: 'Cuadrícula',
                icon: const Icon(Icons.grid_view),
                color: isBusy ? Colors.grey : SchemaColors.primary700,
                iconSize: 30,
                onPressed: isBusy ? null : () => bloc.add(ChangeViewTypeEvent(viewType: FileExplorerViewType.grid())),
              ),
              IconButton(
                tooltip: 'Lista',
                icon: const Icon(Icons.format_list_bulleted),
                color: isBusy ? Colors.grey : SchemaColors.primary700,
                iconSize: 30,
                onPressed: isBusy ? null : () => bloc.add(ChangeViewTypeEvent(viewType: FileExplorerViewType.details())),
              ),
              IconButton(
                tooltip: 'Tabla',
                icon: const Icon(Icons.table_chart),
                color: isBusy ? Colors.grey : SchemaColors.primary700,
                iconSize: 30,
                onPressed: isBusy ? null : () => bloc.add(ChangeViewTypeEvent(viewType: FileExplorerViewType.list())),
              ),
            ],
          ),
        ],
      ),
    );
  }
}