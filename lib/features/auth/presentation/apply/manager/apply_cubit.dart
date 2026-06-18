import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'apply_state.dart';

class ApplyCubit extends Cubit<ApplyState> {
  ApplyCubit() : super(ApplyInitial());
}
