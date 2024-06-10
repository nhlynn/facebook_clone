import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_vo.dart';

class AuthState {
  final bool loading;
  final String? message;
  final UserCredential? userCredential;
  final UserVO? userData;

  AuthState({
    required this.loading,
    required this.message,
    required this.userCredential,
    required this.userData,
  });

  AuthState.initial({
    this.loading = false,
    this.message,
    this.userCredential,
    this.userData,
  });

  AuthState copyWith({
    bool? loading,
    String? message,
    UserCredential? userCredential,
    UserVO? userData,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      message: message ?? this.message,
      userCredential: userCredential ?? this.userCredential,
      userData: userData ?? this.userData,
    );
  }
}
