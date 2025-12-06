import 'package:flutter/material.dart';

import '../app_state.dart';
import '../widgets/sigap_scaffold.dart';
import 'login_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  static const routeName = '/intro';

  @override
  Widget build(BuildContext context) {
    return SigapScaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/text_icon.png',
              height: 120,
            ),
            const SizedBox(height: 64),
            Image.asset(
              'assets/images/intro.png',
              height: 240,
            ),
            const SizedBox(height: 32),
            Text(
              'Selamat datang',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Layanan ini memudahkan konsultasi dengan dokter profesional dimana pun dan kapan pun.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await AppStateScope.of(context).markIntroSeen();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                      context,
                      LoginScreen.routeName,
                    );
                  }
                },
                child: const Text('Masuk'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
