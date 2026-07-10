import '../../domain/entities/user_notification_entity.dart';
import '../models/responses/user_firestore_model.dart';

extension UserFirestoreModelMapper on UserFirestoreModel {
  UserNotificationEntity toNotificationEntity() {
    return UserNotificationEntity(
      fcmToken: fcmToken ?? '',
      language: language ?? 'en',
    );
  }
}
