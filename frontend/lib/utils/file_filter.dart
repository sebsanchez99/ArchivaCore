// lib/services/file_filter_service.dart

import 'package:frontend/domain/models/file_model.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/domain/models/folder_response.dart';

class FileFilter {
  FolderResponse applyAllFilters({
    required FolderResponse content,
    required String query,
    required Set<String> selectedTypes,
    required Set<String> selectedAuthors,
  }) {
    final lowerCaseQuery = query.toLowerCase();

    final noFilters = query.trim().isEmpty && selectedTypes.isEmpty && selectedAuthors.isEmpty;
    if (noFilters) {
      return content;
    }

    final List<FileModel> allFiles = [];
    _collectAllFiles(content.files, content.folders, allFiles);

    final List<FolderModel> allFolders = [];
    _collectAllFolders(content.folders, allFolders);

    final filteredFiles = allFiles.where((file) {
      final matchesName = query.trim().isEmpty || file.name.toLowerCase().contains(lowerCaseQuery);
      final matchesType = selectedTypes.isEmpty || selectedTypes.contains(file.type);
      final matchesAuthor = selectedAuthors.isEmpty || (file.author.isNotEmpty && selectedAuthors.contains(file.author));
      return matchesName && matchesType && matchesAuthor;
    }).toList();

    final filteredFolders = allFolders.where((folder) {
      final matchesName = query.trim().isEmpty || folder.name.toLowerCase().contains(lowerCaseQuery);
      return query.trim().isNotEmpty && matchesName;
    }).toList();

    final hasFileFiltersOnly = query.trim().isEmpty && (selectedTypes.isNotEmpty || selectedAuthors.isNotEmpty);

    return FolderResponse(
      folders: hasFileFiltersOnly ? [] : filteredFolders,
      files: filteredFiles,
    );
  }
  
  // Incluimos todas las funciones auxiliares aquí.
  
  void _collectAllFolders(List<FolderModel> rootFolders, List<FolderModel> allFolders) {
    allFolders.addAll(rootFolders);
    for (final folder in rootFolders) {
      _collectAllFolders(folder.subFolders, allFolders);
    }
  }

  void _collectAllFiles(List<FileModel> rootFiles, List<FolderModel> rootFolders, List<FileModel> allFiles) {
    allFiles.addAll(rootFiles);
    for (final folder in rootFolders) {
      _collectFilesFromFolder(folder, allFiles);
    }
  }

  void _collectFilesFromFolder(FolderModel folder, List<FileModel> allFiles) {
    allFiles.addAll(folder.files);
    for (final subFolder in folder.subFolders) {
      _collectFilesFromFolder(subFolder, allFiles);
    }
  }
  
  // Ahora, también movemos las funciones de recolección de autores y tipos
  
  List<String> getAllTypes(FolderResponse content) {
    final types = <String>{};
    _getTypesRecursively(content.files, types);
    for (final folder in content.folders) {
      _getTypesFromFolder(folder, types);
    }
    return types.toList();
  }

  void _getTypesFromFolder(FolderModel folder, Set<String> types) {
    _getTypesRecursively(folder.files, types);
    for (final subFolder in folder.subFolders) {
      _getTypesFromFolder(subFolder, types);
    }
  }

  void _getTypesRecursively(List<FileModel> files, Set<String> types) {
    for (final file in files) {
      types.add(file.type);
    }
  }

  List<String> getAllAuthors(FolderResponse content) {
    final authors = <String>{};
    _getAuthorsRecursively(content.files, authors);
    for (final folder in content.folders) {
      _getAuthorsFromFolder(folder, authors);
    }
    return authors.toList();
  }
  
  void _getAuthorsFromFolder(FolderModel folder, Set<String> authors) {
    _getAuthorsRecursively(folder.files, authors);
    for (final subFolder in folder.subFolders) {
      _getAuthorsFromFolder(subFolder, authors);
    }
  }

  void _getAuthorsRecursively(List<FileModel> files, Set<String> authors) {
    for (final file in files) {
      if (file.author.isNotEmpty) {
        authors.add(file.author);
      }
    }
  }
}