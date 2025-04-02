import 'package:freezed_annotation/freezed_annotation.dart';

part 'either.freezed.dart';

/// Declaración de clase genérica que contiene dos posibles valores: L(Error), R(Éxito)
@freezed
class Either<L, R> with _$Either<L, R> {
  factory Either.right(R value) = _Right;
  factory Either.left(L value) = _Left;
}
