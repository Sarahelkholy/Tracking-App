import 'package:equatable/equatable.dart';

import '../../../../orders/domain/entities/order_entity.dart';

class SplashState extends Equatable {
  const SplashState({this.acceptedOrder , this.isLoading=false});

  final OrderEntity? acceptedOrder;
  final bool isLoading;

  @override
  List<Object?> get props => [acceptedOrder , isLoading];
}
