import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/repositories/file_explorer_repository.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/global/enums/file_explorer_view_type.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_state.dart';
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
      create: (_) => FileExplorerBloc(FileExplorerState.loading(),
        fileExplorerRepository: context.read<FileExplorerRepository>(),
      )..add(InitializeEvent()),
      child: BlocConsumer<FileExplorerBloc, FileExplorerState>(
        listener: (context, state) {

        },
        builder: (context, state) {
          final bloc = context.read<FileExplorerBloc>();
          return state.map(
            loading: (_) => LoadingState(),
            loaded: (value) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Carpetas",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: SchemaColors.primary600,
                        size: 35,
                      ),

                      tooltip: 'Agregar',
                      onPressed: () {
                        // Acción al presionar el botón de agregar
                      },
                    ),
                  ],
                ),
                body: Padding(
                  padding: EdgeInsets.only(left: 16.0,  top: 16.0),
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
                                CustomButton2(onPressed: () {}, message: 'Tipo'),
                                SizedBox(width: 20),
                                CustomButton2(onPressed: () {}, message: 'Persona'),
                                SizedBox(width: 20),
                                CustomButton2(onPressed: () {}, message: 'Fecha'),
                                SizedBox(width: 30),
                                IconButton(
                                  icon: Icon(Icons.list, color: SchemaColors.primary700, size: 30),
                                  onPressed: () => bloc.add(ChangeViewTypeEvent(viewType: FileExplorerViewType.list())),
                                ),
                                IconButton(
                                  icon: Icon(Icons.grid_view, color: SchemaColors.primary700, size: 30),
                                  onPressed: () => bloc.add(ChangeViewTypeEvent(viewType: FileExplorerViewType.grid())),
                                ),
                                IconButton(
                                  icon: Icon(Icons.details, color: SchemaColors.primary700, size: 30),
                                  onPressed: () => bloc.add(ChangeViewTypeEvent(viewType: FileExplorerViewType.details())),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: value.viewType.when(
                          list: () => FileExplorerListView(bloc: bloc), 
                          grid: () => FileExplorerGridView(bloc: bloc), 
                          details: () => FileExplorerDetailsView(bloc: bloc)
                        ),
                      )

                      // SizedBox(height: 15),

                    ],
                  ),
                ),
              );
            },
            failed: (value) => FailureState(failure: value.failure, onRetry: () {}),
          );
        },
      ),
    );
  }
}
