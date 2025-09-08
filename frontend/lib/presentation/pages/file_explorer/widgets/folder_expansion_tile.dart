import 'package:flutter/material.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/events/file_explorer_events.dart';

class FolderExpansionTile extends StatelessWidget {
  final FolderModel folder;
  final FileExplorerBloc bloc;
  const FolderExpansionTile({
    super.key, 
    required this.folder,
    required this.bloc,
  });

  IconData _getFileIcon(String type) {
    switch (type.toLowerCase()) {
      case "pdf":
        return Icons.picture_as_pdf;
      case "doc":
      case "docx":
        return Icons.description;
      case "jpg":
      case "png":
      case "jpeg":
        return Icons.image;
      case "mp4":
      case "avi":
        return Icons.movie;
      case "mp3":
      case "wav":
        return Icons.music_note;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String type) {
    switch (type.toLowerCase()) {
      case "pdf":
        return Colors.red;
      case "doc":
      case "docx":
        return Colors.blue;
      case "jpg":
      case "png":
      case "jpeg":
        return Colors.orange;
      case "mp4":
      case "avi":
        return Colors.purple;
      case "mp3":
      case "wav":
        return Colors.green;
      default:
        return SchemaColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = folder.subFolders.isEmpty && folder.files.isEmpty;

    if (isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.folder,
            color: SchemaColors.warning,
            size: 30,
          ),
          title: Tooltip(
            message: folder.name, 
            child: Text(
              folder.name,
              overflow: TextOverflow.ellipsis, 
              maxLines: 1,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: SchemaColors.textPrimary,
              ),
            ),
          ),
          trailing: null,
          onTap: null, 
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: ExpansionTile(
          dense: true,
          tilePadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          shape: const Border(),
          collapsedShape: const Border(),
          leading: const Icon(
            Icons.folder,
            color: SchemaColors.warning,
            size: 30,
          ),
          title: Tooltip(
            message: folder.name, 
            child: InkWell(
              onTap: () {
                bloc.add(FileExplorerEvents.selectFolder(folder: folder));
              },
              child: Text(
                folder.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: SchemaColors.textPrimary,
                ),
              ),
            ),
          ),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          children: [
            // Subcarpetas
            ...folder.subFolders.map((sub) => FolderExpansionTile(folder: sub, bloc: bloc,)),

            // Archivos
            ...folder.files.map(
              (file) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  leading: Icon(
                    _getFileIcon(file.type),
                    color: _getFileColor(file.type),
                    size: 28,
                  ),
                  title: Tooltip(
                    message: file.name, 
                    child: Text(
                      file.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    file.type,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                  trailing: Text(
                    "${file.size} MB",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    bloc.add(FileExplorerEvents.selectFile(file: file));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
