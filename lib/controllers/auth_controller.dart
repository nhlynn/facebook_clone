import 'dart:io';

import '../states/auth_state.dart';
import '../utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositorys/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: repository);
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthController({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(AuthState.initial());

  void createAccount({
    required String fullName,
    required DateTime birthday,
    required String gender,
    required String email,
    required String password,
    required File? image,
  }) async {
    if (state.loading) {
      return;
    }
    if (image == null) {
      showToastMessage(text: 'Please choose profile picture');
      return;
    }
    state = state.copyWith(loading: true);

    final response = await _authRepository.createAccount(
        fullName: fullName,
        birthday: birthday,
        gender: gender,
        email: email,
        password: password,
        image: image);

    if (response == null) {
      state = state.copyWith(loading: false);
    } else {
      state = state.copyWith(loading: false);
      state = state.copyWith(userCredential: response);
    }
  }

  void verifyAccount() async{
    if(state.loading){
      return;
    }
    state = state.copyWith(loading: true);

    final response = await _authRepository.verifyEmail();

    if(response==null){
      state = state.copyWith(loading: false);
    } else {
      state = state.copyWith(loading: false);
      showToastMessage(text: response);
    }
  }

  void signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (state.loading) {
      return;
    }
    state = state.copyWith(loading: true);

    final response = await _authRepository.signInWithEmailAndPassword(
        email: email, password: password);

    if (response == null) {
      state = state.copyWith(loading: false);
    } else {
      state = state.copyWith(loading: false);
      state = state.copyWith(userCredential: response);
    }
  }
}
