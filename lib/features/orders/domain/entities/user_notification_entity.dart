import 'package:equatable/equatable.dart';

class UserNotificationEntity extends Equatable {
  final String fcmToken;
  final String language;

  const UserNotificationEntity({
    required this.fcmToken,
    required this.language,
  });

  @override
  List<Object?> get props => [fcmToken, language];
}
