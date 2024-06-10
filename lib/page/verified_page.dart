import '../controllers/auth_controller.dart';
import '../page/home_page.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class VerifiedPage extends ConsumerWidget {
  static const routeName = '/verify';

  const VerifiedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    Future<void> refreshPage() async {
      await FirebaseAuth.instance.currentUser!.reload();
      final verifiedEmail = FirebaseAuth.instance.currentUser?.emailVerified;
      if (verifiedEmail == true) {
        context.pushReplacement(HomePage.routeName);
      }
    }

    return Scaffold(
      body: Padding(
        padding: Constants.defaultPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            authState.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  ref.read(authControllerProvider.notifier).verifyAccount();
                },
                child: const Text('Verify Email'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  refreshPage();
                },
                child: const Text('Refresh'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  ref.read(authProvider).singOut();
                },
                child: const Text('Change Email'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
