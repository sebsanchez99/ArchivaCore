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
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        child: PaginatedDataTable(
          header: Center(
            child: SearchAnchor.bar(
              searchController: _searchController,
              suggestionsBuilder: (context, controller) {
                final userName = controller.text.toLowerCase();
                final results =
                    users.where((user) {
                      return user.name.toLowerCase().contains(userName);
                    }).toList();
                return results.map((user) {
                  return ListTile(
                    title: Text(user.name),
                    onTap: () {
                      controller.closeView(user.name);
                      _searchController.text = user.name;
                    },
                  );
                });
              },
            ),
          ),

          rowsPerPage: 8,
          columns: [
            DataColumn(label: Text('Usuario')),
            DataColumn(label: Text('Rol')),
            DataColumn(label: Text('Acciones')),
          ],
          source: tableRow,
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
        DataCell(Text(user.name)),
        DataCell(Text(user.role)),
        DataCell(
          Row(
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
