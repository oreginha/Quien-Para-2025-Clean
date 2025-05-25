// lib/core/models/data_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'data_state.freezed.dart';

@freezed
class DataState<T> with _$DataState<T> {
  const DataState._(); // Add this private constructor

  const factory DataState.initial() = _Initial<T>;
  const factory DataState.loading() = _Loading<T>;
  const factory DataState.success(final T data) = _Success<T>;
  const factory DataState.error(final String message) = _Error<T>;
}
