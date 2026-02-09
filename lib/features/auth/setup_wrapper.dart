import 'package:finapp/features/auth/account_setup_screen.dart';
import 'package:finapp/features/auth/category_setup_screen.dart';
import 'package:flutter/material.dart';

/// Wrapper screen that handles the setup flow for new users
/// Shows category setup first, then account setup
class SetupWrapper extends StatefulWidget {
  const SetupWrapper({super.key});

  @override
  State<SetupWrapper> createState() => _SetupWrapperState();
}

class _SetupWrapperState extends State<SetupWrapper> {
  bool _showAccountSetup = false;

  @override
  Widget build(BuildContext context) {
    // Start with category setup, then move to account setup
    if (!_showAccountSetup) {
      return CategorySetupScreen(
        onComplete: () {
          setState(() {
            _showAccountSetup = true;
          });
        },
      );
    }

    // Show account setup
    // When account setup is done, it calls AuthController.completeSetup()
    // which triggers AuthWrapper (parent) to switch to dashboard.
    return const AccountSetupScreen();
  }
}
