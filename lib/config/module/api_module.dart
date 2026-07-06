import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../core/values/api_end_points.dart';
import '../../core/values/api_strings.dart';
import '../di/di.dart';
import '../driver/manager/driver_cubit.dart';
import '../driver/manager/driver_events.dart';
import '../firebase/api/fcm_interceptor.dart';
import '../secure_cache/secure_cache/cache_keys.dart';
import '../secure_cache/secure_cache/secure_cache.dart';

@module
abstract class ApiModule {
  @lazySingleton
  BaseOptions providerOption() {
    return BaseOptions(
      baseUrl: ApiEndPoints.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    );
  }

  @lazySingleton
  PrettyDioLogger providerDioLogger() {
    return PrettyDioLogger(
      requestBody: true,
      request: true,
      responseBody: true,
      error: true,
      requestHeader: true,
      responseHeader: false,
      compact: true,
      maxWidth: 90,
      enabled: kDebugMode,
      filter: (options, args) {
        // don't print requests with uris containing '/posts'
        if (options.path.contains('/posts')) {
          return false;
        }
        // don't print responses with unit8 list data
        return !args.isResponse || !args.hasUint8ListData;
      },
    );
  }

  // @lazySingleton
  // SecureCache provideSecureCache() {
  //   return SecureCacheImpl(const FlutterSecureStorage());
  // }

  @lazySingleton
  Dio provideDio(
    BaseOptions option,
    PrettyDioLogger logger,
    SecureCache secureCache,
  ) {
    final dio = Dio(option);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final requiresAuth = options.extra[ApiStrings.requireAuth] ?? true;

          if (requiresAuth) {
            final token = await secureCache.getData(key: CacheKeys.token);

            if (token != null && token.isNotEmpty) {
              options.headers[ApiStrings.token] = 'Bearer $token';
            }
          }

          return handler.next(options);
        },

        onError: (error, handler) async {
          final requiresAuth =
              error.requestOptions.extra[ApiStrings.requireAuth] ?? true;

          final message = (error.response?.data?['error'] ?? "")
              .toString()
              .toLowerCase();

          final isTokenError =
              message.contains("expired token") ||
              message.contains("invalid token") ||
              message.contains("driver not found");

          if (requiresAuth && isTokenError) {
            await secureCache.removeData(key: CacheKeys.token);
            getIt<DriverCubit>().doEvent(UnauthorizedDriverEvent());
          }

          return handler.next(error);
        },
      ),
    );

    dio.interceptors.add(logger);

    return dio;
  }

  @Named(ApiStrings.fcmDio)
  @lazySingleton
  Dio provideFcmDio(PrettyDioLogger logger, FcmInterceptor fcmInterceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndPoints.fcmBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    dio.interceptors.add(fcmInterceptor);
    dio.interceptors.add(logger);
    return dio;
  }
}
