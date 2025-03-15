import 'package:flutter/material.dart';
import 'package:frontend/domain/models/user_model.dart';

class AdminitrationView extends StatefulWidget {
  const AdminitrationView({super.key});

  @override
  State<AdminitrationView> createState() => _AdminitrationViewState();
}

class _AdminitrationViewState extends State<AdminitrationView> {
  final List<UserModel> users = [
    UserModel(name: 'Ignacio', role: 'user'),
    UserModel(name: 'Sebastian', role: 'user'),
    UserModel(name: 'Ignacio2', role: 'user'),
    UserModel(name: 'Leonardo', role: 'admin'),
    UserModel(name: 'Ignacio4', role: 'user'),
    UserModel(name: 'Ignacio5', role: 'user'),
  ];
  List<UserModel> filteredUsers = [];
  final SearchController _searchController = SearchController();
  late TableRow tableRow;

  @override
  void initState() {
    super.initState();
    filteredUsers = List.from(users);
    tableRow = TableRow(users: filteredUsers);
    _searchController.addListener(() {
      _filtrarUsuarios(_searchController.text);
    });
  }

  void _filtrarUsuarios(String userName) {
    setState(() {
      filteredUsers =
          users.where((user) {
            return user.name.toLowerCase().contains(userName.toLowerCase());
          }).toList();

      tableRow = TableRow(users: filteredUsers);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  constraints: BoxConstraints(maxHeight: 40, maxWidth: 500),
                  child: SearchAnchor.bar(
                    viewConstraints: BoxConstraints(
                      minHeight: kToolbarHeight,
                      maxHeight: kToolbarHeight * 4,
                    ),
                    isFullScreen: false,
                    searchController: _searchController,
                    suggestionsBuilder: (context, controller) {
                      final userName = controller.text.toLowerCase();
                      final results =
                          users.where((user) {
                            return user.name.toLowerCase().contains(userName);
                          }).toList();
                      return results.map((user) {
                        return SizedBox(
                          child: ListTile(
                            dense: true,
                            title: Text(user.name),
                            onTap: () {
                              controller.closeView(user.name);
                              _searchController.text = user.name;
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
