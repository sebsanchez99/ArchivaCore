import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/models/user_model.dart';
import 'package:frontend/domain/repositories/administration_repository.dart';
import 'package:frontend/presentation/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_bloc.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_events.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_state.dart';
import 'package:frontend/presentation/pages/administration/widgets/create_user_window.dart';
import 'package:frontend/presentation/pages/administration/widgets/edit_user_window.dart';
import 'package:frontend/presentation/widgets/dialogs/error_dialog.dart';
import 'package:frontend/presentation/widgets/dialogs/info_dialog.dart';
import 'package:frontend/presentation/widgets/dialogs/success_dialog.dart';
import 'package:frontend/presentation/widgets/states/failure_state.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';

part '../utils/utils.dart';

class AdministrationView extends StatelessWidget {
  const AdministrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdministrationBloc>(
      create: (_) => AdministrationBloc(AdministrationState.loading(),
        administrationRepository: context.read<AdministrationRepository>(),
      )..add(InitializeEvent()),
      child: BlocConsumer<AdministrationBloc, AdministrationState>(
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
          final bloc = context.read<AdministrationBloc>();

          return state.map(
            loading: (_) => LoadingState(),
            loaded: (value) {
              final tableRow = TableRow(context, users: value.filteredUsers);

              return SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      cardTheme: CardTheme(
                        elevation: 4,
                        surfaceTintColor: Colors.blueAccent,
                      ),
                    ),
                    child: PaginatedDataTable(
                      showFirstLastButtons: true,
                      arrowHeadColor: Colors.blue,
                      actions: [
                        SizedBox(
                          width: 185,
                          height: 40,
                          child: FilledButton.tonalIcon(
                            onPressed: () => _showCreateDialog(context),
                            label: Text('Agregar usuario'),
                            icon: Icon(Icons.add),
                            iconAlignment: IconAlignment.start,
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(SchemaColors.primary200),
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                              elevation: WidgetStatePropertyAll(3),
                              iconSize: WidgetStatePropertyAll(30),
                            ),
                          ),
                        ),
                      ],
                      header: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 500,
                          height: 40,
                          child: SearchAnchor.bar(
                            dividerColor: Color( 0xFF3A5A98),
                            viewConstraints: BoxConstraints(
                              minHeight: kToolbarHeight,
                              maxHeight: kToolbarHeight * 4,
                            ),
                            barShape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                            isFullScreen: false,
                            searchController: bloc.searchController,
                            suggestionsBuilder: (context, controller) {
                              final userName = controller.text.toLowerCase();
                              final results =
                                  value.users.where((user) {
                                    return user.name.toLowerCase().contains(
                                      userName,
                                    );
                                  }).toList();
                              return results.map((user) {
                                return SizedBox(
                                  child: ListTile(
                                    dense: true,
                                    title: Text(user.name),
                                    onTap: () {
                                      controller.closeView(user.name);
                                      bloc.searchController.text = user.name;
                                    },
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                      ),

                      rowsPerPage: 8,
                      columns: [
                        DataColumn(
                          label: Text('Usuario'),
                          headingRowAlignment: MainAxisAlignment.center,
                        ),
                        DataColumn(
                          label: Text('Rol'),
                          headingRowAlignment: MainAxisAlignment.center,
                        ),
                        DataColumn(
                          label: Text('Acciones'),
                          headingRowAlignment: MainAxisAlignment.center,
                        ),
                      ],
                      source: tableRow,
                    ),
                  ),
                ),
              );
            },
            failed:
                (value) => FailureState(
                  failure: value.failure,
                  onRetry: () => bloc.add(InitializeEvent()),
                ),
          );
        },
      ),
    );
  }
}

class TableRow extends DataTableSource {
  final List<UserModel> users;
  final BuildContext context;

  TableRow(this.context, {required this.users});

  @override
  DataRow getRow(int index) {
    final user = users[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Center(child: Text(user.name))),
        DataCell(Center(child: Text(user.role))),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _showEditDialog(context, user),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _showInfoDialog(context, user.id),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}
