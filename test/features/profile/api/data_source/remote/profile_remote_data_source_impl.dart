import 'package:flower_driver/features/profile/api/data_source/api_profile.dart';
import 'package:flower_driver/features/profile/api/data_source/remote/profile_remote_data_source_impl.dart';
import 'package:flower_driver/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([ApiProfile])
void main() {
ProfileRemoteDataSourceImpl(apiProfile: apiProfile)

}
