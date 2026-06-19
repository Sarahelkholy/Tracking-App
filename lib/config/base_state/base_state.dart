import 'package:equatable/equatable.dart';

class BaseState<T> extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final T? data;

  const BaseState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.data,
  });

  @override
  List<Object?> get props => [isLoading, errorMessage, isSuccess, data];
}
