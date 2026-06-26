import 'package:flower_driver/config/route_manager/routes.dart';
import 'package:flower_driver/core/helpers/app_snack_bar.dart';
import 'package:flower_driver/core/shared_widgets/custom_bottom_nav.dart';
import 'package:flower_driver/core/utils/app_colors.dart';
import 'package:flower_driver/core/utils/app_text_styles.dart';
import 'package:flower_driver/features/profile/presentation/manager/profile/profile_cubit.dart';
import 'package:flower_driver/features/profile/presentation/manager/profile/profile_intent.dart';
import 'package:flower_driver/features/profile/presentation/manager/profile/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Profile', style: AppTextStyles.bold20(context)),
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
                    title: 'Language',
                    trailing: Text(
                      'English',
                      style: AppTextStyles.regular14(
                        context,
                      ).copyWith(color: AppColors.primaryColor),
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  _buildSettingsOption(
                    context: context,
                    icon: Icons.logout,
                    title: 'Logout',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      context.read<ProfileCubit>().handleIntent(
                        const LogoutIntent(),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Failed to load profile.'));
          }
        },
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, dynamic driver) {
    final name = '${driver?.firstName ?? 'John'} ${driver?.lastName ?? 'Doe'}';
    final email = driver?.email ?? 'JohnDoe@gmail.com';
    final phone = driver?.phone ?? '012113456789';

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
    final vehicleType = driver?.vehicleType ?? 'Bike';
    final vehicleNumber = driver?.vehicleNumber ?? 'UP16DL0007';

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
                    'Vehicle info',
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
