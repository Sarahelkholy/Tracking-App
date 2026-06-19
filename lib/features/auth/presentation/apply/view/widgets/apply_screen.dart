// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flower_driver/config/route_manager/routes.dart';
import 'package:flower_driver/core/helpers/app_snack_bar.dart';
import 'package:flower_driver/core/helpers/validator.dart';
import 'package:flower_driver/core/shared_widgets/custom_button.dart';
import 'package:flower_driver/core/utils/app_colors.dart';
import 'package:flower_driver/core/utils/app_text_styles.dart';
import 'package:flower_driver/core/values/app_strings.dart';
import 'package:flower_driver/features/auth/data/models/requests/apply_request.dart';
import 'package:flower_driver/features/auth/presentation/apply/manager/apply_cubit.dart';
import 'package:flower_driver/features/auth/presentation/apply/manager/apply_intents.dart';

class ApplyScreen extends StatefulWidget {
  const ApplyScreen({super.key});

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nidController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<Map<String, String>> _countries = [
    {'name': 'Egypt', 'flag': '🇪🇬'},
    {'name': 'Saudi Arabia', 'flag': '🇸🇦'},
    {'name': 'UAE', 'flag': '🇦🇪'},
    {'name': 'Kuwait', 'flag': '🇰🇼'},
    {'name': 'Bahrain', 'flag': '🇧🇭'},
  ];

  final List<String> _vehicleTypes = ['Car', 'Motorbike', 'Bicycle'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _vehicleNumberController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nidController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  final ImagePicker _picker = ImagePicker();

  String _getFileName(String path) {
    return path.split('/').last.split('\\').last;
  }

  Future<void> _pickImage(DocumentType docType, ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final File file = File(image.path);
        final int sizeInBytes = await file.length();
        final double sizeInMb = sizeInBytes / (1024 * 1024);

        if (sizeInMb <= 3) {
          if (mounted) {
            context.read<ApplyCubit>().handleIntent(
                  UploadDocumentIntent(docType, image.path),
                );
          }
        } else {
          if (mounted) {
            AppSnackBar.error(context, 'File size must be less than 3MB');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, 'Failed to pick image: $e');
      }
    }
  }

  void _showImagePicker(BuildContext context, DocumentType docType) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.current.selectUploadSource,
                  style: AppTextStyles.bold16(context),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: AppColors.primaryColor),
                  title: Text(AppStrings.current.takePhoto),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(docType, ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: AppColors.primaryColor),
                  title: Text(AppStrings.current.chooseGallery),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(docType, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper to format phone number with country code
  String _formatPhone(String? country, String rawPhone) {
    const countryCodes = {
      'Egypt': '+20',
      'Saudi Arabia': '+966',
      'UAE': '+971',
      'Kuwait': '+965',
      'Bahrain': '+973',
    };
    final code = countryCodes[country] ?? '';
    // Remove any non-digit characters
    final digits = rawPhone.replaceAll(RegExp(r'\\D'), '');
    return '$code$digits';
  }

  void _submitForm(ApplyState state) {
    if (_formKey.currentState!.validate()) {
      if (state.vehicleLicensePath == null) {
        AppSnackBar.error(context, AppStrings.current.errorUploadLicense);
        return;
      }
      if (state.nidImagePath == null) {
        AppSnackBar.error(context, AppStrings.current.errorUploadNid);
        return;
      }

      String vehicleTypeId = '';
      if (state.selectedVehicleType == 'Car') {
        vehicleTypeId = '6a32b278992612ae599acf91';
      } else if (state.selectedVehicleType == 'Motorbike') {
        vehicleTypeId = '6a32b312992612ae599acfb2';
      } else if (state.selectedVehicleType == 'Bicycle') {
        vehicleTypeId = '6a32b384992612ae599acfb9';
      }

      final request = ApplyRequest(
        country: state.selectedCountry,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        vehicleType: vehicleTypeId,
        vehicleNumber: _vehicleNumberController.text.trim(),
        vehicleLicense: state.vehicleLicensePath,
        nid: _nidController.text.trim(),
        nidImg: state.nidImagePath,
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rePassword: _confirmPasswordController.text,
        gender: state.selectedGender?.toLowerCase(),
        phone: _formatPhone(state.selectedCountry, _phoneController.text.trim()),
      );

      context.read<ApplyCubit>().handleIntent(SubmitApplyIntent(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApplyCubit, ApplyState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackBar.error(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        if (state.isSuccess) {
          return _buildSuccessView(context);
        }
        return _buildFormView(context, state);
      },
    );
  }

  Widget _buildFormView(BuildContext context, ApplyState state) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.current.apply,
          style: AppTextStyles.bold20(context),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.current.welcome,
                  style: AppTextStyles.bold24(context).copyWith(
                    color: AppColors.black100,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.current.joinTeam,
                  style: AppTextStyles.regular14(context).copyWith(
                    color: AppColors.grayDark,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 24),

                // Country Dropdown
                DropdownButtonFormField<String>(
                  value: state.selectedCountry,
                  decoration: InputDecoration(
                    labelText: AppStrings.current.country,
                  ),
                  items: _countries.map((c) {
                    return DropdownMenuItem<String>(
                      value: c['name'],
                      child: Row(
                        children: [
                          Text(
                            c['flag']!,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 10),
                          Text(c['name']!),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      context.read<ApplyCubit>().handleIntent(SelectCountryIntent(val));
                    }
                  },
                ),
                const SizedBox(height: 20),

                // First Legal Name
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: AppStrings.current.firstLegalName,
                    hintText: AppStrings.current.enterFirstLegalName,
                  ),
                  validator: Validator.name,
                ),
                const SizedBox(height: 20),

                // Second Legal Name
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: AppStrings.current.secondLegalName,
                    hintText: AppStrings.current.enterSecondLegalName,
                  ),
                  validator: Validator.name,
                ),
                const SizedBox(height: 20),

                // Vehicle Type Dropdown
                DropdownButtonFormField<String>(
                  value: state.selectedVehicleType,
                  decoration: InputDecoration(
                    labelText: AppStrings.current.vehicleType,
                  ),
                  items: _vehicleTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      context.read<ApplyCubit>().handleIntent(SelectVehicleTypeIntent(val));
                    }
                  },
                ),
                const SizedBox(height: 20),

                // Vehicle Number
                TextFormField(
                  controller: _vehicleNumberController,
                  decoration: InputDecoration(
                    labelText: AppStrings.current.vehicleNumber,
                    hintText: AppStrings.current.enterVehicleNumber,
                  ),
                  validator: (val) => Validator.name(val),
                ),
                const SizedBox(height: 20),

                // Vehicle License Upload Picker
                InkWell(
                  onTap: () => _showImagePicker(context, DocumentType.vehicleLicense),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: AppStrings.current.vehicleLicense,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            state.vehicleLicensePath != null
                                ? _getFileName(state.vehicleLicensePath!)
                                : AppStrings.current.uploadLicensePhoto,
                            style: AppTextStyles.regular14(context).copyWith(
                              color: state.vehicleLicensePath == null
                                  ? AppColors.grayMedium
                                  : AppColors.primaryColor,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.upload_sharp,
                          color: AppColors.grayDark,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: AppStrings.current.email,
                    hintText: AppStrings.current.enterEmail,
                  ),
                  validator: Validator.email,
                ),
                const SizedBox(height: 20),

                // Phone Number
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: AppStrings.current.phoneNumber,
                    hintText: AppStrings.current.enterPhoneNumber,
                  ),
                  validator: Validator.phone,
                ),
                const SizedBox(height: 20),

                // National ID Number
                TextFormField(
                  controller: _nidController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppStrings.current.idNumber,
                    hintText: AppStrings.current.enterIdNumber,
                  ),
                  validator: (val) => Validator.name(val),
                ),
                const SizedBox(height: 20),

                // National ID Image Upload Picker
                InkWell(
                  onTap: () => _showImagePicker(context, DocumentType.nidImage),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: AppStrings.current.idImage,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            state.nidImagePath != null
                                ? _getFileName(state.nidImagePath!)
                                : AppStrings.current.uploadIdImage,
                            style: AppTextStyles.regular14(context).copyWith(
                              color: state.nidImagePath == null
                                  ? AppColors.grayMedium
                                  : AppColors.primaryColor,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.upload_sharp,
                          color: AppColors.grayDark,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Side-by-side Password and Confirm Password fields
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: AppStrings.current.password,
                          hintText: AppStrings.current.enterPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              size: 18,
                              color: AppColors.grayDark,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: Validator.password,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          labelText: AppStrings.current.confirmPassword,
                          hintText: AppStrings.current.confirmPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                              size: 18,
                              color: AppColors.grayDark,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator: (val) =>
                            Validator.confirmPassword(val, _passwordController.text),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Gender Selection
                Row(
                  children: [
                    Text(
                      AppStrings.current.gender,
                      style: AppTextStyles.semiBold14(context).copyWith(
                        color: AppColors.black100,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'Female',
                            groupValue: state.selectedGender,
                            activeColor: AppColors.primaryColor,
                            onChanged: (val) {
                              if (val != null) {
                                context.read<ApplyCubit>().handleIntent(SelectGenderIntent(val));
                              }
                            },
                          ),
                          Text(
                            AppStrings.current.female,
                            style: AppTextStyles.regular14(context).copyWith(
                              color: AppColors.black100,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Radio<String>(
                            value: 'Male',
                            groupValue: state.selectedGender,
                            activeColor: AppColors.primaryColor,
                            onChanged: (val) {
                              if (val != null) {
                                context.read<ApplyCubit>().handleIntent(SelectGenderIntent(val));
                              }
                            },
                          ),
                          Text(
                            AppStrings.current.male,
                            style: AppTextStyles.regular14(context).copyWith(
                              color: AppColors.black100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Continue Button
                CustomButton(
                  title: AppStrings.current.continueText,
                  isLoading: state.isLoading,
                  onPressed: () => _submitForm(state),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Wave drawings at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 220,
              width: double.infinity,
              child: CustomPaint(
                painter: BottomWavesPainter(),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 3),
                    // Large checkmark with pink circle
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 3,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          size: 60,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Main title text
                    Text(
                      AppStrings.current.applicationSubmitted,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bold20(context).copyWith(
                        color: AppColors.black100,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Subtitle text
                    Text(
                      AppStrings.current.reviewApplication,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.regular14(context).copyWith(
                        color: AppColors.grayNeutral,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Login redirect button
                    CustomButton(
                      title: AppStrings.current.login,
                      onPressed: () {
                        // Redirect to Login Route
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.loginRoute,
                          (route) => false,
                        );
                      },
                    ),
                    const Spacer(flex: 4),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter to draw the wavy background lines exactly like the design
class BottomWavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = AppColors.primaryColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = AppColors.primaryColor.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    // First wave (lower)
    final path1 = Path();
    path1.moveTo(0, size.height * 0.55);
    path1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.25,
      size.width * 0.5,
      size.height * 0.55,
    );
    path1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.85,
      size.width,
      size.height * 0.55,
    );
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, paint1);

    // Second wave (higher/different offset)
    final path2 = Path();
    path2.moveTo(0, size.height * 0.65);
    path2.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.9,
      size.width * 0.65,
      size.height * 0.5,
    );
    path2.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.3,
      size.width,
      size.height * 0.45,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
