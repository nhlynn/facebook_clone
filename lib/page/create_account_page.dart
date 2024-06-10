import 'dart:io';

import '../controllers/auth_controller.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/birthday_picker_widget.dart';
import '../widgets/gender_picker_widget.dart';
import '../widgets/pick_image_widget.dart';
import '../widgets/rounded_text_field_widget.dart';

final _formKey = GlobalKey<FormState>();

class CreateAccountPage extends ConsumerStatefulWidget {
  static const routeName = '/create-account';

  const CreateAccountPage({super.key});

  @override
  ConsumerState<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends ConsumerState<CreateAccountPage> {
  XFile? image;
  DateTime? birthday;
  String gender = 'male';

  // controllers
  late final TextEditingController _fNameController;
  late final TextEditingController _lNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _fNameController = TextEditingController();
    _lNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _fNameController.dispose();
    _lNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> createAccount() async {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();

      final file = image==null ? null : File(image!.path);
      ref.read(authControllerProvider.notifier).createAccount(
          fullName: '${_fNameController.text} ${_lNameController.text}',
          birthday: birthday ?? DateTime.now(),
          gender: gender,
          email: _emailController.text,
          password: _passwordController.text,
          image: file);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    if(authState.userCredential!=null) {
      if (!authState.userCredential!.user!.emailVerified) {
        WidgetsBinding.instance.addPostFrameCallback((timestamp) {
          context.go('/');
        });
      }
    }

    return Scaffold(
      backgroundColor: AppColors.realWhiteColor,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: Constants.defaultPadding,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    image = await pickImage();
                    setState(() {});
                  },
                  child: PickImageWidget(
                    image: image,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RoundedTextFieldWidget(
                        controller: _fNameController,
                        hint: 'First name',
                        keyboardType: TextInputType.text,
                        inputAction: TextInputAction.next,
                        validator: validateName,
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Last Name Text Field
                    Expanded(
                      child: RoundedTextFieldWidget(
                        controller: _lNameController,
                        hint: 'Last name',
                        keyboardType: TextInputType.text,
                        inputAction: TextInputAction.next,
                        validator: validateName,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                BirthdayPickerWidget(
                  onPressed: () async {
                    birthday = await pickSimpleDate(
                      context: context,
                      date: birthday,
                    );
                    setState(() {});
                  },
                  dateTime: birthday ?? DateTime.now(),
                ),
                const SizedBox(height: 20),
                GenderPickerWidget(
                  gender: gender,
                  onChanged: (value) {
                    gender = value ?? 'male';
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),
                RoundedTextFieldWidget(
                  controller: _emailController,
                  hint: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  inputAction: TextInputAction.next,
                  validator: validateEmail,
                ),
                const SizedBox(height: 20),
                RoundedTextFieldWidget(
                  controller: _passwordController,
                  hint: 'Password',
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                  inputAction: TextInputAction.done,
                  validator: validatePassword,
                ),
                const SizedBox(
                  height: 20,
                ),
                authState.loading ?
                const Center(
                  child: CircularProgressIndicator(),
                )
                    : FilledButton(
                  onPressed: createAccount,
                  child: const Text('Create Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
