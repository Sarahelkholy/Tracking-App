import '../../../../../core/localization/l10n/app_localizations.dart';

extension OrderStatusExtension on OrderStatus {
  String localized(AppLocalizations localizations) {
    switch (this) {
      case OrderStatus.accepted:
        return localizations.accepted;

      case OrderStatus.picked:
        return localizations.picked;

      case OrderStatus.outForDelivery:
        return localizations.outForDelivery;

      case OrderStatus.arrived:
        return localizations.arrived;

      case OrderStatus.delivered:
        return localizations.delivered;
    }
  }

  int get step {
    switch (this) {
      case OrderStatus.accepted:
        return 1;

      case OrderStatus.picked:
        return 2;

      case OrderStatus.outForDelivery:
        return 3;

      case OrderStatus.arrived:
        return 4;

      case OrderStatus.delivered:
        return 5;
    }
  }
}

enum OrderStatus { accepted, picked, outForDelivery, arrived, delivered }
