import 'package:flower_driver/config/di/di.dart';
import 'package:flower_driver/config/route_manager/routes.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/shared_widgets/custom_button.dart';
import 'package:flower_driver/core/utils/app_colors.dart';
import 'package:flower_driver/core/utils/app_text_styles.dart';
import 'package:flower_driver/features/auth/presentation/manager/logout/logout_cubit.dart';
import 'package:flower_driver/features/auth/presentation/manager/logout/logout_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => getIt<LogoutCubit>(),
      child: BlocListener<LogoutCubit, LogoutState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.loginRoute,
              (route) => false,
            );
          } else if (state is LogoutFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.background,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  local.logout.toUpperCase(),
                  style: AppTextStyles.semiBold18(context),
                ),
                const SizedBox(height: 8),
                Text(
                  local.confirmLogout,
                  style: AppTextStyles.regular16(
                    context,
                  ).copyWith(color: AppColors.darkBase),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: local.cancel,
                        borderColor: AppColors.grayDark,
                        titleStyle: AppTextStyles.medium14(
                          context,
                        ).copyWith(color: AppColors.darkBase),
                        onPressed: () => Navigator.pop(context),
                        backgroundColor: AppColors.background,
                      ),
                    ),

                    const SizedBox(width: 12),
                    Expanded(
                      child: BlocBuilder<LogoutCubit, LogoutState>(
                        builder: (context, state) {
                          final isLoading = state is LogoutLoading;

                          return CustomButton(
                            isLoading: isLoading,
                            title: local.logout,
                            backgroundColor: AppColors.primaryColor,
                            titleStyle: AppTextStyles.medium14(
                              context,
                            ).copyWith(color: AppColors.baseWhite),
                            onPressed: () {
                              context.read<LogoutCubit>().doEvents(
                                LogoutEvent(),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
