import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../domain/entities/enums/order_status_enum.dart';

extension OrderStatusPresentationExtension on OrderStatusEnum {
  String localized(AppLocalizations localizations) {
    switch (this) {
      case OrderStatusEnum.pending:
        return 'Pending';
      case OrderStatusEnum.accepted:
        return localizations.accepted;
      case OrderStatusEnum.picked:
        return localizations.picked;
      case OrderStatusEnum.outForDelivery:
        return localizations.outForDelivery;
      case OrderStatusEnum.arrived:
        return localizations.arrived;
      case OrderStatusEnum.delivered:
        return localizations.delivered;
      case OrderStatusEnum.completed:
        return "Completed";
    }
  }

  int get step {
    switch (this) {
      case OrderStatusEnum.accepted:
        return 1;
      case OrderStatusEnum.picked:
        return 2;
      case OrderStatusEnum.outForDelivery:
        return 3;
      case OrderStatusEnum.arrived:
        return 4;
      case OrderStatusEnum.delivered:
        return 5;
      case OrderStatusEnum.completed:
        return 5;
      default:
        return 1;
    }
  }

  String buttonTitle(AppLocalizations localizations) {
    switch (this) {
      case OrderStatusEnum.accepted:
        return localizations.arrivedAtPickupPoint;
      case OrderStatusEnum.picked:
        return localizations.startDeliver;
      case OrderStatusEnum.outForDelivery:
        return localizations.arrivedToTheUser;
      case OrderStatusEnum.arrived:
        return localizations.deliveredToTheUser;
      case OrderStatusEnum.delivered:
        return localizations.deliveredToTheUser;
      default:
        return localizations.arrivedAtPickupPoint;
    }
  }
}
