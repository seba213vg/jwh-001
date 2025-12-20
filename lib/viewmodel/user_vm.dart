import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwh_01/model/user_model.dart';
import 'package:jwh_01/repository/auth_repo.dart';
import 'package:jwh_01/repository/user_repo.dart';
import 'package:jwh_01/viewmodel/sign_up_vm.dart';

class UserViewModel extends AsyncNotifier<UserModel> {
  late UserRepository _userRepo;
  late AuthRepository _authRepo;

  @override
  FutureOr<UserModel> build() async {
    _userRepo = ref.read(userRepoProvider);
    _authRepo = ref.read(authRepoProvider);
    
    // Watch state to rebuild on auth changes
    final authState = ref.watch(authStreamState);
    final user = authState.valueOrNull;

    if (user != null) {
      final userId = user.uid;
      final profile = await _userRepo.findProfile(userId);
      if (profile != null) {
        return UserModel.fromJson(profile);
      }
    }
    // Return empty user model when not logged in
    return UserModel.empty(); 
  }

  Future<void> CreateUser(UserCredential credential) async {
    state = AsyncValue.loading();
    final AdditionalUserInfo = ref.read(SignupInfo);
    final user = UserModel(
      name: credential.user!.displayName ?? AdditionalUserInfo['name']!,
      uid: credential.user!.uid,
      email: credential.user!.email ?? "anon@anon.co",
      bio: 'undefined',
      link: 'undefined',
      photoUrl: 'undefined',
      volume: 1.0,
      textsize: 1.0,
      notification: true,
    );

    await _userRepo.createUser(user);
    state = AsyncValue.data(user);
  }

  Future<bool> deleteUserAccount(String password) async {
    try {
      final user = _authRepo.user;
      final email = user?.email;

      if (user != null && email != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);
        final result = await _userRepo.deleteAccountAndData();
        if (result) {
          Fluttertoast.showToast(
            msg: "회원탈퇴가 완료되었습니다",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return true;
        }
        // await _authRepo.logOut();
        // await _userRepo.deleteUser(user.uid);
        // await user.delete();
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "회원탈퇴하기 실패",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
    return false;
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    //state = AsyncValue.loading();
    final user = _authRepo.user;
    if (user == null) return;
    
    final userId = user.uid;
    await _userRepo.updateUser(userId, data);
    
    // Refresh to update local state
    final updatedUser = await _userRepo.findProfile(userId);
    if (updatedUser != null) {
      state = AsyncValue.data(UserModel.fromJson(updatedUser)); // Optimistic update
    } else {
       state = AsyncValue.error(
        'Failed to update user profile',
        StackTrace.current,
      );
    }
  }
}

final UserVmProvider = AsyncNotifierProvider<UserViewModel, UserModel>(
  () => UserViewModel(),
);
