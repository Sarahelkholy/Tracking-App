import 'dart:convert';

import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/data/models/responses/country_model.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

abstract class CountryLocalDataSource {
  Future<Result<List<CountryModel>>> getCountries();
}

@Injectable(as: CountryLocalDataSource)
class CountryLocalDataSourceImpl implements CountryLocalDataSource {
  @override
  Future<Result<List<CountryModel>>> getCountries() async {
    final String response = await rootBundle.loadString('assets/country.json');
    final List<dynamic> data = await json.decode(response);
    return Success(data: data.map((json) => CountryModel.fromJson(json)).toList());
  }
}
