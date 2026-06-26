import 'package:flower_driver/core/shared_widgets/custom_button.dart';
import 'package:flower_driver/features/auth/presentation/widgets/logout_dialog.dart';
import 'package:flutter/material.dart';

import '../../../../config/route_manager/routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: CustomButton(
              title: 'logout',
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) => const LogoutDialog(),
                );
              },
            ),
          ),
          CustomButton(
            title: 'logout',
            onPressed: () async {
              Navigator.pushNamed(context, Routes.changPasswordRoute);
            },
          ),
        ],
      ),
    );
  }
}
