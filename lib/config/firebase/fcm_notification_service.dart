import 'dart:convert';
import 'package:flower_driver/secret_keys.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@lazySingleton
class FcmNotificationService {
  static const _scopes = ['https://www.googleapis.com/auth/cloud-platform'];

  Future<String> _getAccessToken() async {
    final accountCredentials = ServiceAccountCredentials.fromJson(
      SecretKeys.serviceAccountJson,
    );
    final client = await clientViaServiceAccount(accountCredentials, _scopes);
    final accessToken = client.credentials.accessToken.data;
    client.close();
    return accessToken;
  }

  Future<void> sendNotification({
    required String fcmToken,
    required String title,
    required String body,
  }) async {
    final accessToken = await _getAccessToken();
    final projectId = SecretKeys.serviceAccountJson['project_id'];
    final url =
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'message': {
          'token': fcmToken,
          'notification': {'title': title, 'body': body},
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send notification: ${response.body}');
    }
  }
}
