import '../../domain/entities/change_password/change_password_request_entity.dart';
import '../models/response/change_password_response.dart';

extension ChangePasswordMapper on ChangePasswordResponse {
  ChangePasswordEntity toEntity() {
    return ChangePasswordEntity(message: message, token: token);
  }
}
