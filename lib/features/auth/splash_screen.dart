import 'package:flutter/material.dart';
import 'auth_constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mock logo
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AuthConstants.primaryPurple,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Cashly',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AuthConstants.primaryPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
