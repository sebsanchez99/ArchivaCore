import 'package:frontend/data/repositories_impl/auth_repository_impl.dart';
import 'package:frontend/data/services/remote/auth_service.dart';
import 'package:frontend/domain/repositories/auth_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// Lista de providers que se utilizarán dentro de la apliacción
List<SingleChildWidget> appProviders = [
  Provider<AuthRepository>(
    create: (_) => AuthRepositoryImpl(AuthService()),
  ),
];
