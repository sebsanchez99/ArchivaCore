import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/user_model.dart';
import 'package:frontend/domain/repositories/administration_repository.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_bloc.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_events.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_state.dart';

class AdministrationView extends StatelessWidget {
  const AdministrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdministrationBloc>(
      create:
          (_) =>
              AdministrationBloc(AdministrationState.loading(), administrationRepository: context.read<AdministrationRepository>())
                ..add(InitializeEvent()),
      child: BlocBuilder<AdministrationBloc, AdministrationState>(
        builder: (context, state) {
          final bloc = context.read<AdministrationBloc>();

          return state.map(
            loading: (_) => Center(child: CircularProgressIndicator()),
            loaded: (value) {
              final tableRow = TableRow(users: value.filteredUsers);

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
                      header: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: 40,
                              maxWidth: 500,
                            ),
                            child: SearchAnchor.bar(
                              viewConstraints: BoxConstraints(
                                minHeight: kToolbarHeight,
                                maxHeight: kToolbarHeight * 4,
                              ),
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
                          SizedBox(
                            width: 185,
                            height: 40,
                            child: FilledButton.tonalIcon(
                              onPressed: () {},
                              label: Text('Agregar usuario'),
                              icon: Icon(Icons.add),
                              iconAlignment: IconAlignment.end,
                              style: ButtonStyle(
                                elevation: WidgetStatePropertyAll(3),
                                iconSize: WidgetStatePropertyAll(30),
                              ),
                            ),
                          ),
                        ],
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
          );
        },
      ),
    );
  }
}

class TableRow extends DataTableSource {
  final List<UserModel> users;

  TableRow({required this.users});

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
              IconButton(icon: Icon(Icons.edit), onPressed: () {}),
              IconButton(icon: Icon(Icons.delete), onPressed: () {}),
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
