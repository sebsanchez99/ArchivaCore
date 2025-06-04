import 'package:frontend/data/repositories_impl/administration_repository_impl.dart';
import 'package:frontend/data/repositories_impl/auth_repository_impl.dart';
import 'package:frontend/data/repositories_impl/file_explorer_repository_impl.dart';
import 'package:frontend/data/services/remote/administration_service.dart';
import 'package:frontend/data/services/remote/auth_service.dart';
import 'package:frontend/data/services/remote/file_explorer_service.dart';
import 'package:frontend/domain/repositories/administration_repository.dart';
import 'package:frontend/domain/repositories/auth_repository.dart';
import 'package:frontend/domain/repositories/file_explorer_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// [List] de providers que se utilizarán dentro de la apliacción
List<SingleChildWidget> appProviders = [
  Provider<AuthRepository>(
    create: (_) => AuthRepositoryImpl(AuthService()),
  ),
  Provider<AdministrationRepository>(
    create: (_)=> AdministrationRepositoryImpl(AdministrationService()),
  ),
  Provider<FileExplorerRepository>(
    create: (_) => FileExplorerRepositoryImpl(FileExplorerService()),
  ),
];

