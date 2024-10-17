import 'package:treeview_tractian/data/utils/app_errors.dart';

class Resource<D> {
  final D? _data;
  final AppError? _error;

  Resource._(this._data, this._error);

  static Resource<D> success<D>({D? data}) => Resource._(data, null);

  static Resource<D> failure<D>(AppError error) => Resource._(null, error);

  bool isFailure() => _error != null;

  bool isSuccess() => _error == null;

  D? get data => _data;

  AppError? get error => _error;

  T fold<T>(
      T Function(AppError error) onFailure, T Function(D? data) onSuccess) {
    if (isFailure()) {
      return onFailure(_error!);
    } else if (isSuccess()) {
      return onSuccess(_data);
    }
    throw StateError('Resource must be either failure or success.');
  }
}
