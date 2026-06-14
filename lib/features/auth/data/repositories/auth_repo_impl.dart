import 'package:flower_driver/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/auth_repo.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;

  const AuthRepoImpl(this._authRemoteDataSource);
}
