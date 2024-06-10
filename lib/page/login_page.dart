import '../controllers/auth_controller.dart';
import '../page/create_account_page.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/rounded_text_field_widget.dart';

final _formKey = GlobalKey<FormState>();

class LoginPage extends ConsumerStatefulWidget {
  static const routeName = '/login';

  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();

      ref.read(authControllerProvider.notifier).signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    if (authState.userCredential != null) {
      WidgetsBinding.instance.addPostFrameCallback((timestamp) {
        context.go('/');
      });
    }
    return Scaffold(
      backgroundColor: AppColors.realWhiteColor,
      appBar: AppBar(),
      body: Padding(
        padding: Constants.defaultPadding,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/icons/fb_logo.png',
              width: 90,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  RoundedTextFieldWidget(
                    controller: _emailController,
                    hint: 'Email',
                    validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    inputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RoundedTextFieldWidget(
                    controller: _passwordController,
                    hint: 'Password',
                    inputAction: TextInputAction.done,
                    validator: validatePassword,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: login,
                      child: const Text('Login'),
                    ),
                  ),
                  authState.loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const SizedBox(
                          height: 10,
                        ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Forget Password'),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      context.push(CreateAccountPage.routeName);
                    },
                    child: const Text('Create Account'),
                  ),
                ),
                Image.asset(
                  'assets/icons/meta.png',
                  height: 50,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
