import 'package:flower_driver/config/route_manager/routes.dart';
import 'package:flower_driver/core/helpers/app_snack_bar.dart';
import 'package:flower_driver/core/shared_widgets/custom_button.dart';
import 'package:flower_driver/core/shared_widgets/custom_text_form_field.dart';
import 'package:flower_driver/core/utils/app_colors.dart';
import 'package:flower_driver/core/utils/app_text_styles.dart';
import 'package:flower_driver/features/profile/data/models/request/edit_profile_request.dart';
import 'package:flower_driver/features/profile/presentation/manager/profile/profile_cubit.dart';
import 'package:flower_driver/features/profile/presentation/manager/profile/profile_intent.dart';
import 'package:flower_driver/features/profile/presentation/manager/profile/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _vehicleTypeController = TextEditingController();
  final _vehicleNumberController = TextEditingController();

  String _selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    _populateFields();
  }

  void _populateFields() {
    final state = context.read<ProfileCubit>().state;
    if (state is ProfileLoaded) {
      final driver = state.driverData.driver;
      _firstNameController.text = driver?.firstName ?? '';
      _lastNameController.text = driver?.lastName ?? '';
      _emailController.text = driver?.email ?? '';
      _phoneController.text = driver?.phone ?? '';
      _vehicleTypeController.text = driver?.vehicleType ?? '';
      _vehicleNumberController.text = driver?.vehicleNumber ?? '';
      _selectedGender = driver?.gender ?? 'Male';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _vehicleTypeController.dispose();
    _vehicleNumberController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final request = EditProfileRequest(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );
      context.read<ProfileCubit>().handleIntent(SubmitEditProfile(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Edit profile', style: AppTextStyles.bold20(context)),
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
          if (state is EditProfileSuccess) {
            AppSnackBar.success(context, state.message);
            Navigator.pop(context);
          } else if (state is EditProfileError) {
            AppSnackBar.error(context, state.message);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.grayLight,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.grayMedium,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: _firstNameController,
                          label: 'First name',
                          hint: 'First name',
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextFormField(
                          controller: _lastNameController,
                          label: 'Last name',
                          hint: 'Last name',
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Email',
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _phoneController,
                    label: 'Phone number',
                    hint: 'Phone number',
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: '******',
                    obscureText: true,
                    suffixIcon: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.changPasswordRoute);
                      },
                      child: Text(
                        'Change',
                        style: AppTextStyles.regular14(
                          context,
                        ).copyWith(color: AppColors.primaryColor),
                      ),
                    ),
                    validator: (v) => null, // Optional unless changing
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Gender', style: AppTextStyles.semiBold14(context)),
                      const Spacer(),
                      Radio<String>(
                        value: 'Female',
                        groupValue: _selectedGender,
                        activeColor: AppColors.primaryColor,
                        onChanged: (v) => setState(() => _selectedGender = v!),
                      ),
                      Text('Female', style: AppTextStyles.regular14(context)),
                      const SizedBox(width: 16),
                      Radio<String>(
                        value: 'Male',
                        groupValue: _selectedGender,
                        activeColor: AppColors.primaryColor,
                        onChanged: (v) => setState(() => _selectedGender = v!),
                      ),
                      Text('Male', style: AppTextStyles.regular14(context)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  CustomTextFormField(
                    controller: _vehicleTypeController,
                    label: 'Vehicle type',
                    hint: 'Vehicle type',
                    readOnly: true,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    validator: (v) => null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _vehicleNumberController,
                    label: 'Vehicle number',
                    hint: 'Vehicle number',
                    validator: (v) => null,
                  ),
                  const SizedBox(height: 16),
                  // Vehicle license mock
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grayLight),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vehicle license',
                              style: AppTextStyles.regular14(context).copyWith(
                                color: AppColors.grayDark,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Photo_12345678',
                              style: AppTextStyles.regular14(context),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.upload_outlined,
                          color: AppColors.black100,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    title: 'Update',
                    isLoading: state is EditProfileLoading,
                    onPressed: _submitForm,
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
