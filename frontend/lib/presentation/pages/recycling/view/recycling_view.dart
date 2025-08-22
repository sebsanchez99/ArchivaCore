import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/file_model.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/repositories/recycle_repository.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/recycling/bloc/recycle_bloc.dart';
import 'package:frontend/presentation/pages/recycling/bloc/recycle_events.dart';
import 'package:frontend/presentation/pages/recycling/bloc/recycle_state.dart';
import 'package:frontend/presentation/pages/recycling/widgets/file_tile.dart';
import 'package:frontend/presentation/pages/recycling/widgets/folder_details_window.dart';
import 'package:frontend/presentation/pages/recycling/widgets/folder_tile.dart';
import 'package:frontend/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:frontend/presentation/widgets/dialogs/error_dialog.dart';
import 'package:frontend/presentation/widgets/dialogs/info_dialog.dart';
import 'package:frontend/presentation/widgets/dialogs/success_dialog.dart';
import 'package:frontend/presentation/widgets/states/failure_state.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';
import 'package:lucide_icons/lucide_icons.dart';

part '../utils/utils.dart';

class RecyclingView extends StatelessWidget {
  const RecyclingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecycleBloc>(
      create: (_) => RecycleBloc(RecycleState.loading(),
        recycleRepository: context.read<RecycleRepository>(),
      )..add(InitializeEvent()),
      child: BlocConsumer<RecycleBloc, RecycleState>(
        listener: (context, state) {
          state.mapOrNull(
            loaded: (value) {
              final response = value.response;
              if (response != null) {
                _showResult(context, response);
              }
            },
          );
        },
        builder: (context, state) {
          final bloc = context.read<RecycleBloc>();
          return state.map(
            loading: (_) => const LoadingState(),
            loaded: (value) {
              final folderList = value.filteredContent.folders;
              final filesList = value.filteredContent.files;

              final combinedList = [...folderList, ...filesList];

              if (combinedList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.delete_sweep_outlined,
                        color: Colors.grey,
                        size: 80,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tu papelera está vacía.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Los archivos y carpetas que elimines aparecerán aquí.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: bloc.searchController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: SchemaColors.secondary500
                                  )
                                ),
                                hintStyle: TextStyle(fontSize: 14),
                                isDense: true,
                                hintText: "Buscar contenido...",
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          CustomIconButton(
                            message: 'Refrescar', 
                            icon: LucideIcons.refreshCcw, 
                            onPressed: () => bloc.add(InitializeEvent())
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: combinedList.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = combinedList[index];
                        if (item is FolderModel) {
                          return FolderTile(
                            folder: item,
                            viewDetailsAction: () => _showFolderDetailsDialog(context, item),
                            deleteAction: () => _showDeleteFolderInfoDialog(context, item),
                            restoreAction: () => _showRestoreFolderInfoDialog(context, item),
                          );
                        } else if (item is FileModel) {
                          return FileTile(
                            file: item,
                            deleteAction: () => _showDeleteFileInfoDialog(context, item),
                            restoreAction: () => _showRestoreFileInfoDialog(context, item),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              );
            },
            failed: (value) => FailureState(
              failure: value.failure,
              onRetry: () => bloc.add(InitializeEvent()),
            ),
          );
        },
      ),
    );
  }
}