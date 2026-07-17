import 'package:dio/dio.dart';
import 'package:flower_driver/core/values/app_strings.dart';

class NetworkException {
  static String getMessageError(Exception exception) {
    if (exception is DioException) {
      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
          return AppStrings.current.connectionTimeoutMessage;

        case DioExceptionType.sendTimeout:
          return AppStrings.current.sendTimeoutMessage;

        case DioExceptionType.receiveTimeout:
          return AppStrings.current.receiveTimeoutMessage;

        case DioExceptionType.badCertificate:
          return AppStrings.current.badCertificateMessage;

        case DioExceptionType.badResponse:
          return _handleMessageResponse(exception);

        case DioExceptionType.cancel:
          return AppStrings.current.requestCancelledMessage;

        case DioExceptionType.connectionError:
          return AppStrings.current.connectionErrorMessage;

        case DioExceptionType.unknown:
          return AppStrings.current.unknownErrorMessage;
        case DioExceptionType.transformTimeout:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    } else {
      return AppStrings.current.unexpectedErrorMessage;
    }
  }

  static String _handleMessageResponse(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final data = e.response!.data;

      if (data is Map<String, dynamic>) {
        if (data['message'] != null) {
          return data['message'].toString();
        }
        if (data['error'] != null) {
          return data['error'].toString();
        }
      }

      switch (statusCode) {
        case 400:
          return AppStrings.current.error400;
        case 401:
          return AppStrings.current.error401;
        case 403:
          return AppStrings.current.error403;
        case 404:
          return AppStrings.current.error404;
        case 408:
          return AppStrings.current.error408;
        case 429:
          return AppStrings.current.error429;
        case 500:
          return AppStrings.current.error500;
        case 502:
          return AppStrings.current.error502;
        case 503:
          return AppStrings.current.error503;
        case 504:
          return AppStrings.current.error504;
        default:
          return 'Server error (${statusCode ?? 'unknown'}). Please try again.';
      }
    }

    return AppStrings.current.defaultError;
  }
}
