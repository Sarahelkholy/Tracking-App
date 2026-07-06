import 'package:flower_driver/features/orders/domain/entities/enums/order_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../localization/l10n/app_localizations.dart';

@lazySingleton
class NotificationLocalizer {
  // Accepted Notification
  String getOrderAcceptedTitle(String langCode) {
    final localizations = lookupAppLocalizations(Locale(langCode));
    return localizations.orderAcceptedTitle;
  }

  String getOrderAcceptedBody(String langCode, String orderNumber) {
    final localizations = lookupAppLocalizations(Locale(langCode));
    return localizations.orderAcceptedBody(orderNumber);
  }

  // Update Notification
  String getOrderUpdateTitle(String langCode) {
    final localizations = lookupAppLocalizations(Locale(langCode));
    return localizations.orderUpdateTitle;
  }

  String getOrderUpdateBody(
    String langCode,
    String orderNumber,
    OrderStatusEnum status,
  ) {
    final localizations = lookupAppLocalizations(Locale(langCode));
    final localizedStatus = _getLocalizedStatus(status, localizations);
    return localizations.orderUpdateBody(orderNumber, localizedStatus);
  }

  String _getLocalizedStatus(
    OrderStatusEnum status,
    AppLocalizations localizations,
  ) {
    switch (status) {
      case OrderStatusEnum.pending:
        return 'Pending'; // Usually not sent as notification
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
    }
  }
}

class LocalizedNotificationData {
  final String title;
  final String body;

  LocalizedNotificationData({required this.title, required this.body});
}
