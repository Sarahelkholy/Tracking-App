import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flower_driver/config/di/di.dart';
import 'package:flower_driver/features/auth/presentation/apply/manager/apply_cubit.dart';
import 'package:flower_driver/features/auth/presentation/apply/view/widgets/apply_screen.dart';

class ApplyPage extends StatelessWidget {
  const ApplyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ApplyCubit>(),
      child: const ApplyScreen(),
    );
  }
}