import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:frontend/domain/models/file_model.dart';
import 'package:frontend/presentation/widgets/buttons/custom_popupmenu.dart';
import 'package:intl/intl.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

class FolderExpandableTable extends StatelessWidget {
  final List<FolderModel> folders;
  final void Function(FileModel file)? onPreviewFile;
  final void Function(FolderModel folder)? onEditFolder;
  final void Function(FolderModel folder)? onOrganizeFolder;

  const FolderExpandableTable({
    super.key,
    required this.folders,
    this.onPreviewFile,
    this.onEditFolder,
    this.onOrganizeFolder,
  });

  static const double _rowHeight = 48.0;

  /// Construye un header con fondo, sombra y padding
  Widget _buildHeaderCell(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: SchemaColors.primary200,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
        border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: child,
    );
  }

  /// Construye la celda de la fila para archivos
  ExpandableTableCell _buildFileCell(String text, {TextAlign align = TextAlign.center}) {
    return ExpandableTableCell(
      child: Center(child: Text(text, style: const TextStyle(fontSize: 13), textAlign: align)),
    );
  }

  /// Construye la fila de un archivo
  ExpandableTableRow _buildFileRow(FileModel file, int depth) {
    final formattedCreated = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(file.initialDate));
    final formattedLastModified = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(file.date));

    return ExpandableTableRow(
      height: _rowHeight,
      firstCell: ExpandableTableCell(
        builder: (context, details) {
          return Padding(
            padding: EdgeInsets.only(left: 24.0 * depth + 15),
            child: Row(
              children: [
                const Text('📃', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(child: Text(file.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14))),
              ],
            ),
          );
        },
      ),
      cells: [
        _buildFileCell('${file.type} • ${file.size} MB'),  // Detalles
        _buildFileCell(formattedCreated),                  // Creado
        _buildFileCell(formattedLastModified),            // Última vez
        _buildFileCell(file.author),                       // Autor
        ExpandableTableCell(                               // Acciones
          child: Center(
            child: ElevatedButton(
              onPressed: () => onPreviewFile?.call(file),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: const Text('👁️'),
            ),
          ),
        ),
      ],
    );
  }

  /// Construye la fila de una carpeta
  ExpandableTableRow _buildFolderRow(FolderModel folder, int depth) {
    final hasChildren = folder.files.isNotEmpty || folder.subFolders.isNotEmpty;
    final totalSizeMB = folder.files.fold<double>(0.0, (sum, f) => sum + (double.tryParse(f.size) ?? 0.0));

    final sortedSubFolders = [...folder.subFolders]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    final sortedFiles = [...folder.files]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    final children = [
      ...sortedFiles.map((f) => _buildFileRow(f, depth + 1)),
      ...sortedSubFolders.map((sf) => _buildFolderRow(sf, depth + 1)),
    ];

    return ExpandableTableRow(
      height: _rowHeight,
      firstCell: ExpandableTableCell(
        builder: (context, details) {
          return MouseRegion(
            cursor: hasChildren ? SystemMouseCursors.click : SystemMouseCursors.basic,
            child: Padding(
              padding: EdgeInsets.only(left: 25.0 * depth + 15),
              child: Row(
                children: [
                  if (hasChildren)
                    AnimatedRotation(
                      alignment: Alignment.center,
                      duration: const Duration(milliseconds: 300),
                      turns: details.row?.childrenExpanded == true ? 0.25 : 0,
                      child: const Text('›', style: TextStyle(fontSize: 28)),
                    ),
                  const SizedBox(width: 8),
                  const Text('📁', style: TextStyle(fontSize: 18, color: Colors.black)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      folder.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      cells: [
        _buildFileCell('${folder.files.length} archivos • ${totalSizeMB.toStringAsFixed(2)} MB'), // Última vez
        _buildFileCell('--'),                                     // Detalles
        _buildFileCell('--'),                                     // Creado
        _buildFileCell('--'),                                     // Autor
        ExpandableTableCell(                                       // Acciones
          child: Center(
            child: SizedBox(
              width: 36,
              height: 36,
              child: CustomPopupMenu<String>(
                onSelected: (option) {
                  if (option == 'edit') onEditFolder?.call(folder);
                  if (option == 'organize') onOrganizeFolder?.call(folder);
                },
                items: const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 6),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'organize',
                    child: Row(
                      children: [
                        Icon(Icons.folder_open, size: 18),
                        SizedBox(width: 6),
                        Text('Organizar'),
                      ],
                    ),
                  ),
                ],
                child: const Text('・・・', textAlign: TextAlign.center),
              ),
            ),
          ),
        ),
      ],
      children: children,
    );
  }

  List<ExpandableTableRow> _buildRows(List<FolderModel> folders) {
    // Ordena carpetas por nombre
    final sorted = [...folders]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return sorted.map((f) => _buildFolderRow(f, 0)).toList();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;

        final firstColumnWidth = totalWidth * 0.3;
        final detailsColumnWidth = totalWidth * 0.2;
        final createdColumnWidth = totalWidth * 0.15;
        final lastModifiedColumnWidth = totalWidth * 0.15;
        final authorColumnWidth = totalWidth * 0.15;
        final remainingWidth = totalWidth - (firstColumnWidth + detailsColumnWidth + createdColumnWidth + lastModifiedColumnWidth + authorColumnWidth);
        final actionColumnWidth = remainingWidth > 80.0 ? remainingWidth : 80.0;

        return ExpandableTable(
          key: ValueKey(folders.hashCode),
          firstHeaderCell: ExpandableTableCell(
            child: _buildHeaderCell(
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ),
          firstColumnWidth: firstColumnWidth,
          headers: [
            ExpandableTableHeader(
              cell: ExpandableTableCell(child: _buildHeaderCell(const Text('Detalles', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)))),
              width: detailsColumnWidth,
            ),
            ExpandableTableHeader(
              cell: ExpandableTableCell(child: _buildHeaderCell(const Text('Creado', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)))),
              width: createdColumnWidth,
            ),
            ExpandableTableHeader(
              cell: ExpandableTableCell(child: _buildHeaderCell(const Text('Última vez', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)))),
              width: lastModifiedColumnWidth,
            ),
            ExpandableTableHeader(
              cell: ExpandableTableCell(child: _buildHeaderCell(const Text('Autor', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)))),
              width: authorColumnWidth,
            ),
            ExpandableTableHeader(
              cell: ExpandableTableCell(
                child: _buildHeaderCell(
                  const Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                ),
              ),
              width: actionColumnWidth,
            ),
          ],
          thumbVisibilityScrollbar: true,
          rows: _buildRows(folders),
          headerHeight: 40,
          defaultsRowHeight: _rowHeight,
          visibleScrollbar: true,
          expanded: true,
        );
      },
    );
  }
}
