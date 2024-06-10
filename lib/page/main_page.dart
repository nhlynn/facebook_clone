import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';
import '../page/home_page.dart';
import '../page/login_page.dart';
import '../page/verified_page.dart';
import '../page/error_page.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginPage();
        }
        if (user.emailVerified) {
          return const HomePage();
        }
        return const VerifiedPage();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => ErrorPage(errorMessage: error.toString()),
    );
  }
}
