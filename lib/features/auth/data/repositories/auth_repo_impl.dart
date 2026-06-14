import 'package:injectable/injectable.dart';
import '../../domain/repositories/auth_repo.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {}
