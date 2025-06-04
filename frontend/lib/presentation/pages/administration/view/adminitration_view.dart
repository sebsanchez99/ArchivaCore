import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/models/user_model.dart';
import 'package:frontend/domain/repositories/administration_repository.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
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
                        surfaceTintColor: SchemaColors.primary100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      dataTableTheme: DataTableThemeData(
                        headingRowAlignment: MainAxisAlignment.center,
                        headingRowColor: WidgetStatePropertyAll(SchemaColors.primary400),
                        headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: SchemaColors.neutral,
                        ),
                        dataTextStyle: const TextStyle(
                          color: SchemaColors.primary800,
                        ),
                        dividerThickness: 1.2,
                      )
                    ),
                    child: PaginatedDataTable(
                      showFirstLastButtons: true,
                      arrowHeadColor: SchemaColors.primary800,
                      actions: [
                        FilledButton.tonalIcon(
                          onPressed: () => _showCreateDialog(context),
                          label: Text(
                            'Agregar usuario',
                            style: TextStyle(color: SchemaColors.neutral),
                          ),
                          icon: Icon(Icons.add, color: SchemaColors.neutral),
                          iconAlignment: IconAlignment.start,
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(SchemaColors.primary400),
                            elevation: WidgetStatePropertyAll(3),
                            iconSize: WidgetStatePropertyAll(30),
                            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))
                          ),
                        ),
                      ],
                      header: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 500,
                          height: 40,
                          child: SearchAnchor.bar(
                            barBackgroundColor: WidgetStatePropertyAll(SchemaColors.neutral),
                            dividerColor: SchemaColors.primary500,
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
                                    title: Text(
                                      user.name,
                                      style: TextStyle(color: SchemaColors.textPrimary)
                                    ),
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
                        ),
                        DataColumn(
                          label: Text('Rol'),
                        ),
                        DataColumn(
                          label: Text('Acciones'),
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
                icon: Icon(Icons.edit, color: SchemaColors.primary800),
                onPressed: () => _showEditDialog(context, user),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: SchemaColors.error),
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
