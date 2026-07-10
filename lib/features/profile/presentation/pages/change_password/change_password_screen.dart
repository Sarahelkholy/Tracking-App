import 'package:flower_driver/config/base_cubit/base_event.dart';
import 'package:flower_driver/features/profile/presentation/manager/change_password_cubit/change_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/helpers/app_snack_bar.dart';
import '../../../../../core/helpers/validator.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/shared_widgets/custom_button.dart';
import '../../manager/change_password_cubit/change_password_event.dart';
import '../../manager/change_password_cubit/change_password_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late final ChangePasswordCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = context.read<ChangePasswordCubit>();

    _cubit.eventStream.listen((event) {
      switch (event) {
        case DisplayErrorEvent():
          if (!mounted) return;
          AppSnackBar.error(context, event.errorMsg);

        case DisplaySuccessEvent():
          if (!mounted) return;
          AppSnackBar.success(context, event.successMsg);

        case NavigationEvent():
          if (!mounted) return;
          Navigator.pushReplacementNamed(
            context,
            event.routeName,
          );
      }
    });
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(local.resetPassword),
      ),
      body: BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
        buildWhen: (previous, current) {
          return previous.changeOldPasswordState !=
              current.changeOldPasswordState;
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  ///? current password
                  TextFormField(
                    controller: oldPasswordController,
                    obscureText: true,
                    enabled: !state.changeOldPasswordState.isLoading,
                    validator: Validator.password,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: local.currentPassword,
                      hintText: local.currentPassword,
                    ),
                  ),
                  const SizedBox(height: 14),

                  ///? New password
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    enabled: !state.changeOldPasswordState.isLoading,
                    validator: Validator.password,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: local.newPassword,
                      hintText: local.newPassword,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: confirmNewPasswordController,
                    obscureText: true,
                    enabled: !state.changeOldPasswordState.isLoading,
                    validator: (value) => Validator.confirmPassword(
                      value,
                      newPasswordController.text,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: local.confirmNewPassword,
                      hintText: local.confirmNewPassword,
                    ),
                  ),
                  const SizedBox(height: 40),

                  ///? Click Button
                  CustomButton(
                    title: local.update,
                    isLoading: state.changeOldPasswordState.isLoading,
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;

                      if (oldPasswordController.text.trim() ==
                          newPasswordController.text.trim()) {
                        AppSnackBar.error(context, local.oldAndNewPasswordSame);
                        return;
                      }

                      _cubit.doEventChangePassword(
                        SubmitChangePasswordEvent(
                          password: oldPasswordController.text.trim(),
                          newPassword: newPasswordController.text.trim(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
