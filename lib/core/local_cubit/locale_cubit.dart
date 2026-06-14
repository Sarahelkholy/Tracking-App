import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../config/secure_cache/secure_cache/cache_keys.dart';
import '../../config/secure_cache/secure_cache/secure_cache.dart';

@lazySingleton
class LocaleCubit extends Cubit<Locale> {
  final SecureCache secureCache;

  LocaleCubit(this.secureCache) : super(const Locale('en'));

  Future<void> loadSavedLanguage() async {
    final languageCode = await secureCache.getData(key: CacheKeys.languageCode);

    emit(Locale(languageCode ?? 'en'));
  }

  Future<void> toggleLanguage() async {
    final code = state.languageCode == 'en' ? 'ar' : 'en';

    await _changeLanguage(code);
  }

  Future<void> _changeLanguage(String code) async {
    await secureCache.saveData(key: CacheKeys.languageCode, value: code);

    emit(Locale(code));
  }
}
