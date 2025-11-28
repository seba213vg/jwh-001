import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jwh_01/model/auth_model.dart';
import 'package:jwh_01/repository/auth_repo.dart';
import 'package:jwh_01/repository/user_repo.dart';
import 'package:jwh_01/route.dart';
import 'package:jwh_01/viewmodel/user_vm.dart';

class SignUpViewModel extends StateNotifier<AuthState> {
  final AuthRepository _authRepo;
  final UserRepository _userRepo = UserRepository();
  final Ref ref;

  SignUpViewModel(this._authRepo, this.ref) : super(AuthState.idle());

  Future<void> signUp() async {
    state = AuthState.loading();
    final signupinfo = ref.read(SignupInfo);
    final user = ref.read(UserVmProvider.notifier);
    try {
      final credential = await _authRepo.SignupWithEmail(
        email: signupinfo['email']!,
        password: signupinfo['password']!,
        name: signupinfo['name'],
      );
      print("my : $credential, sign : $signupinfo");
      await user.CreateUser(credential);
      state = AuthState.success(credential.user!);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  logOut() {
    _authRepo.logOut();
    state = AuthState.idle();
  }

  whenDeleteUserAccount() {
    _authRepo.logOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authRepo.ResetPassword(email);
      // state = AuthState.success(null);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> logIn() async {
    state = AuthState.loading();
    final logininfo = ref.read(LoginInfo);
    try {
      final credential = await _authRepo.logInWithEmail(
        email: logininfo['email']!,
        password: logininfo['password']!,
      );
      state = AuthState.success(credential.user!);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}

final SignupInfo = StateProvider<Map<String, String>>(
  (ref) => {'email': '', 'password': '', 'name': ''},
);

final LoginInfo = StateProvider<Map<String, String>>(
  (ref) => {'email': '', 'password': ''},
);

final SignUpVmProvider = StateNotifierProvider<SignUpViewModel, AuthState>(
  (ref) => SignUpViewModel(ref.read(authRepoProvider), ref),
);
