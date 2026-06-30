import 'package:flower_driver/config/route_manager/routes.dart';
import 'package:flower_driver/core/helpers/app_snack_bar.dart';
import 'package:flower_driver/core/local_cubit/locale_cubit.dart';
import 'package:flower_driver/core/utils/app_colors.dart';
import 'package:flower_driver/core/utils/app_text_styles.dart';
import 'package:flower_driver/features/auth/presentation/manager/logout/logout_cubit.dart';
import 'package:flower_driver/features/auth/presentation/manager/logout/logout_events.dart';
import 'package:flower_driver/features/profile/presentation/manager/profile/profile_cubit.dart';
import 'package:flower_driver/features/profile/presentation/manager/profile/profile_intent.dart';
import 'package:flower_driver/features/profile/presentation/manager/profile/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().handleIntent(const LoadProfileData());
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(local.profile, style: AppTextStyles.bold20(context)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_none, color: AppColors.black100),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            AppSnackBar.error(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final driver = state.driverData.driver;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildProfileCard(context, driver),
                  const SizedBox(height: 16),
                  _buildVehicleCard(context, driver),
                  const SizedBox(height: 32),
                  _buildSettingsOption(
                    context: context,
                    icon: Icons.language,
                    title: local.changeLanguage,
                    trailing: Text(
                      local.currentLang == local.arabic
                          ? local.english
                          : local.arabic,
                      style: AppTextStyles.regular14(
                        context,
                      ).copyWith(color: AppColors.primaryColor),
                    ),
                    onTap: () {
                      context.read<LocaleCubit>().toggleLanguage();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSettingsOption(
                    context: context,
                    icon: Icons.logout,
                    title: local.logout,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(local.logout),
                          content: Text(local.areYouSureYouWantToLogout),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(local.cancel),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<LogoutCubit>().doEvents(
                                  LogoutEvent(),
                                );
                              },
                              child: Text(local.logout),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text(local.failedToLoadProfile));
          }
        },
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, dynamic driver) {
    final name = '${driver?.firstName} ${driver?.lastName}';
    final email = driver?.email;
    final phone = driver?.phone;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.editProfileRoute,
        arguments: context.read<ProfileCubit>(),
      ), // Assumes this route exists
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grayLight),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.grayLight,
              child: Icon(Icons.person, size: 40, color: AppColors.grayMedium),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.semiBold16(context)),
                  const SizedBox(height: 4),
                  Text(email, style: AppTextStyles.regular14(context)),
                  const SizedBox(height: 4),
                  Text(phone, style: AppTextStyles.regular14(context)),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.black100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, dynamic driver) {
    final local = AppLocalizations.of(context)!;

    final vehicleType = driver?.vehicleType ?? local.vehicleType;
    final vehicleNumber = driver?.vehicleNumber ?? local.enterVehicleNumber;

    return GestureDetector(
      onTap: () {}, // Might navigate to vehicle edit in the future
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grayLight),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    local.vehicleInformation,
                    style: AppTextStyles.semiBold16(context),
                  ),
                  const SizedBox(height: 8),
                  Text(vehicleType, style: AppTextStyles.regular14(context)),
                  const SizedBox(height: 4),
                  Text(vehicleNumber, style: AppTextStyles.regular14(context)),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.black100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: AppColors.black100, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: AppTextStyles.semiBold16(context)),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
