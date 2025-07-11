import 'package:flutter/material.dart';

class RecyclingView extends StatefulWidget {
  const RecyclingView({super.key});

  @override
  State<RecyclingView> createState() => _RecyclingViewState();
}

class _RecyclingViewState extends State<RecyclingView> {
  final TextEditingController _searchController = TextEditingController();

  // Lista original de archivos y carpetas eliminados
  final List<Map<String, dynamic>> _reciclados = [
    {
      'nombre': 'Documento.pdf',
      'tipo': 'archivo',
      'icono': Icons.insert_drive_file,
    },
    {'nombre': 'Empresa_2', 'tipo': 'carpeta', 'icono': Icons.folder},
    {
      'nombre': 'Notas.txt',
      'tipo': 'archivo',
      'icono': Icons.insert_drive_file,
    },
    {'nombre': 'Empresa_1', 'tipo': 'carpeta', 'icono': Icons.folder},
  ];

  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filtra la lista según el texto de búsqueda
    final List<Map<String, dynamic>> recicladosFiltrados =
        _reciclados
            .where(
              (item) =>
                  item['nombre'].toLowerCase().contains(_search.toLowerCase()),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Papelera de reciclaje')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar archivos o carpetas...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                isDense: true,
              ),
              onChanged: (value) {
                setState(() {
                  _search = value;
                });
              },
            ),
          ),
          Expanded(
            child:
                recicladosFiltrados.isEmpty
                    ? Center(
                      child: Text('No hay archivos o carpetas en la papelera.'),
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: recicladosFiltrados.length,
                      separatorBuilder: (_, __) => Divider(),
                      itemBuilder: (context, index) {
                        final item = recicladosFiltrados[index];
                        return ListTile(
                          leading: Icon(
                            item['icono'],
                            color:
                                item['tipo'] == 'carpeta'
                                    ? Colors.amber
                                    : Colors.blue,
                          ),
                          title: Text(item['nombre']),
                          subtitle: Text(
                            item['tipo'] == 'carpeta'
                                ? 'Carpeta eliminada'
                                : 'Archivo eliminado',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Restaurar',
                                icon: Icon(Icons.restore, color: Colors.green),
                                onPressed: () {
                                  // Acción para restaurar el archivo o carpeta
                                },
                              ),
                              IconButton(
                                tooltip: 'Eliminar definitivamente',
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  // Acción para eliminar definitivamente
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
