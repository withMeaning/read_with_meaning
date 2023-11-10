import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:read_with_meaning/public/constants/app_sizes.dart';
import 'package:read_with_meaning/public/features/boot_up/login/data/secure_login/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class NotYetImplementedScreen extends StatelessWidget {
  const NotYetImplementedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Not Yet Implemented'),
            gapH12,
            Consumer(builder: (context, ref, _) {
              return ElevatedButton(
                  onPressed: () {
                    logOut(ref);
                    //context.goNamed(AppRoute.login.name);
                  },
                  child: const Text('Log Out'));
            }),
            gapH12,
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 51, 20, 18),
                    foregroundColor: const Color.fromARGB(255, 159, 19, 9)),
                onPressed: () => launchUrl(Uri(
                        scheme: 'mailto',
                        path: 'hello@withmeaning.io',
                        queryParameters: {
                          'subject': 'Please delete my account',
                        })),
                child: const Text('Delete Account')),
            gapH12,
            ElevatedButton(
                onPressed: () => context.pop(), child: const Text('Go Back')),
          ],
        ),
      ),
    );
  }
}
