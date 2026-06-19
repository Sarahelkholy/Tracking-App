import 'package:flutter/material.dart';
import '../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../core/utils/app_text_styles.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Back!',
              style: AppTextStyles.bold24(
                context,
              ).copyWith(color: AppColors.primaryColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Login screen placeholder.',
              style: AppTextStyles.regular16(
                context,
              ).copyWith(color: AppColors.grayDark),
            ),
          ],
        ),
      ),
    );
  }
}
